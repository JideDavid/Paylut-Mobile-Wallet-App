import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paylut/Screens/receipt.dart';
import 'package:paylut/models/user_model.dart';

class Transfer extends StatefulWidget {
  final UserDetails userDetails;
  const Transfer({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<Transfer> createState() => _TransferState(userDetails: userDetails);
}

class _TransferState extends State<Transfer> {
  final UserDetails userDetails;
  _TransferState({required this.userDetails});

  TextStyle heading = const TextStyle(
    fontWeight: FontWeight.bold,
  );
  TextStyle subHeading = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
  );

  TextEditingController userTagController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  bool hasValue = true;
  List<UserDetails> tagUsers = [];
  int amount = 0;
  int walletBalance = 0;
  bool isLoading = false;
  bool gettingContacts = false;
  String transactionRef = '';
  List<UserDetails> contacts = [];
  bool isSending = false;

  Future<void> getUserWithUserTag(String userTag) async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("walletTag", isEqualTo: userTag)
        .get();

    tagUsers = [];
    if (mounted) {
      isLoading = false;
      setState(() {});
    }

    var col = snapshot.docs;
    for (var doc in col) {
      UserDetails user = UserDetails.fromJson(doc);
      if (user.email != userDetails.email) {
        tagUsers = [];
        tagUsers.add(user);
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  Future<void> transferToUser() async {
    DateTime now = DateTime.now();

    //formatting and setting transaction reference
    String ref = "ref_$now";
    ref = ref.replaceAll(' ', '');
    ref = ref.replaceAll('-', '');
    ref = ref.replaceAll(':', '');
    ref = ref.replaceAll('.', '');
    transactionRef = ref;

    //getting user balance
    DocumentSnapshot walletSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userDetails.uid).get();
    walletBalance = walletSnapshot.get('walletBalance');
    int newWalletBalance = walletBalance - amount;

    //getting receiver's balance
    DocumentSnapshot userWallet =
        await FirebaseFirestore.instance.collection('users').doc(tagUsers[0].uid).get();
    int receiverBalance = userWallet.get('walletBalance');
    int newReceiverBalance = receiverBalance + amount;

    if (walletBalance >= amount) {
      //debiting user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userDetails.uid)
          .update({'walletBalance': newWalletBalance});

      //crediting receiver
      await FirebaseFirestore.instance
          .collection('users')
          .doc(tagUsers[0].uid)
          .update({"walletBalance": newReceiverBalance});

      //recording transaction to user's history
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userDetails.uid)
          .collection('transactions')
          .doc(transactionRef)
          .set({
        'amount': amount,
        'date': now,
        'initialBalance': walletBalance,
        'newBalance': newWalletBalance,
        'isCredit': false,
        'transactionRef': transactionRef,
        'type': 'transfer',
        'userTag': tagUsers[0].walletTag,
        'username': tagUsers[0].name,
        'userId': tagUsers[0].uid
      });

      //recording transaction to user's history
      await FirebaseFirestore.instance
          .collection('users')
          .doc(tagUsers[0].uid)
          .collection('transactions')
          .doc(transactionRef)
          .set({
        'amount': amount,
        'date': now,
        'initialBalance': receiverBalance,
        'newBalance': newReceiverBalance,
        'isCredit': true,
        'transactionRef': transactionRef,
        'type': 'transfer',
        'userTag': userDetails.walletTag,
        'username': userDetails.name,
        'userId': userDetails.uid
      });

      // ignore: use_build_context_synchronously
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            //pushing
            Future.delayed(const Duration(seconds: 3), () {
              Navigator.of(context).pop();
              // ignore: use_build_context_synchronously
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Receipt(userDetails: userDetails, transactionRef: transactionRef)));
            });

            return AlertDialog(
              backgroundColor: Colors.green,
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Transaction Successful',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              content: SizedBox(
                  height: 200,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 50,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          'You have successfully transfer a sum of ${amount}NGN to ${contacts[0].name}',
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )
                      ])),
            );
          });
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            int difference = amount - walletBalance;

            return AlertDialog(
              //backgroundColor: Colors.white,
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel_rounded,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Error',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
              content: SizedBox(
                  height: 100,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Insufficient balance, you need NGN$difference to complete transaction',
                          style: const TextStyle(),
                          textAlign: TextAlign.center,
                        )
                      ])),
            );
          });
    }
  }

  Future<void> getContacts() async {
    if (mounted) {
      gettingContacts = true;
      setState(() {});
    }
    contacts = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userDetails.uid)
        .collection('contacts')
        .get();

    if (snapshot.docs.isEmpty) {
      gettingContacts = false;
      if (mounted) {
        setState(() {});
      }
      return;
    } else {
      var col = snapshot.docs;
      for (var doc in col) {
        DocumentSnapshot dSnapshot =
            await FirebaseFirestore.instance.collection('users').doc(doc['uid']).get();
        UserDetails contact = UserDetails.fromJson(dSnapshot);
        contacts.add(contact);
      }
    }

    if (kDebugMode) {
      print('contact length: ${contacts.length}');
    }

    if (mounted) {
      gettingContacts = false;
      setState(() {});
    }
  }

  Future<void> addToContact(String userID) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userDetails.uid)
        .collection('contacts')
        .doc(userID)
        .set({'uid': userID, 'date': DateTime.now()});
    //refresh contact list
    getContacts();
  }

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Transfer",
              style: heading,
            ),
            Text(
              "Make wallet transfer to your friends",
              style: subHeading,
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.history,
              ))
        ],
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0),
      ),
      body: isSending ? const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20, width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
            SizedBox(width: 4,),
            Text('Processing...')
          ],
        ),
      )
      : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          //wallet tag text field
          TextField(
            controller: userTagController,
            onChanged: (value) {
              getUserWithUserTag(value);
            },
            maxLength: 25,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              counterText: "",
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(20)),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple, width: 1.0),
                  borderRadius: BorderRadius.circular(20)),
              hintText: 'Enter UserTag',
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          //amount text field
          TextField(
            controller: amountController,
            onChanged: (value) {
              if (value.isEmpty) {
                amount = 0;
                setState(() {});
                return;
              } else {
                amount = int.tryParse(value)!;
                setState(() {});
              }
            },
            maxLength: 25,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              counterText: "",
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(20)),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple, width: 1.0),
                  borderRadius: BorderRadius.circular(20)),
              hintText: 'Enter Amount',
            ),
          ),
          userTagController.text.isEmpty
              ? (gettingContacts
                  ? const Expanded(
                      child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text('getting contacts'),
                        ],
                      ),
                    ))
                  //contact list
                  : contacts.isEmpty
                      ? Expanded(
                          child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey)),
                            child: const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Your contact list empty',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      Text(
                                        'Search users with userTag in the field above',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                      : Expanded(
                          child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey)),
                            child: Column(
                              children: [
                                //section info
                                const Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    'users on your contact list',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                //contact list
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: contacts.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              16, 16, 16, index + 1 == contacts.length ? 16 : 0),
                                          child: GestureDetector(
                                            onTap: () {
                                              userTagController.text = contacts[index].walletTag;
                                              getUserWithUserTag(contacts[index].walletTag);
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Container(
                                                height: 80,
                                                width: double.infinity,
                                                color: Colors.grey.withOpacity(0.2),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 16, vertical: 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundColor: Colors.grey,
                                                            backgroundImage:
                                                                NetworkImage(contacts[index].image),
                                                            radius: 32,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                contacts[index].name,
                                                                style:
                                                                    const TextStyle(fontSize: 20),
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                              Text(
                                                                contacts[index].walletTag,
                                                                style: const TextStyle(
                                                                    fontSize: 12,
                                                                    color: Colors.grey),
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      IconButton(
                                                          onPressed: () async {
                                                            await FirebaseFirestore.instance
                                                                .collection('users')
                                                                .doc(userDetails.uid)
                                                                .collection('contacts')
                                                                .doc(contacts[index].uid)
                                                                .delete();
                                                            getContacts();
                                                          },
                                                          icon: const Icon(Icons.cancel_outlined))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        )))
              : (isLoading
                  ?
                  //loading indicator
                  Expanded(
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: CircularProgressIndicator(),
                          ),
                          Expanded(child: Container())
                        ],
                      ),
                    )
                  : (tagUsers.isEmpty
                      //no user found text feedback
                      ? const Expanded(
                          child: Center(
                          child: Text('No user found'),
                        ))
                      //receiver details card
                      : Expanded(
                          child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey.withOpacity(0.2)),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: CircleAvatar(
                                        radius: 130,
                                        backgroundColor: Colors.grey.withOpacity(0.4),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.grey.withOpacity(0.2),
                                            radius: 130,
                                            backgroundImage: NetworkImage(tagUsers[0].image),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Username',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        Text(
                                          tagUsers[0].name,
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        const Text(
                                          'Wallet Tag',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        Text(
                                          tagUsers[0].walletTag,
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        ElevatedButton(
                                          onPressed: (contacts.contains(UserDetails(
                                                  uid: tagUsers[0].uid,
                                                  name: tagUsers[0].name,
                                                  email: tagUsers[0].email,
                                                  walletTag: tagUsers[0].walletTag,
                                                  walletBalance: tagUsers[0].walletBalance,
                                                  image: tagUsers[0].image,
                                                  date: tagUsers[0].date)))
                                              ? null
                                              : () {
                                                  addToContact(tagUsers[0].uid);
                                                },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  const MaterialStatePropertyAll(Colors.red),
                                              shape:
                                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(18.0),
                                                ),
                                              )),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 12),
                                            child: Text("Add to contact"),
                                          ),
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                              )),
                        )))),
          //transfer button
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: tagUsers.length == 1 && amount > 0
                        ? () async{
                            if (mounted) {
                              setState(() {
                                isSending = true;
                              });
                            }
                            await transferToUser();
                            if (mounted) {
                              setState(() {
                                isSending = false;
                              });
                            }
                          }
                        : null,
                    style: ButtonStyle(
                        backgroundColor: tagUsers.length == 1 && amount > 0
                            ? const MaterialStatePropertyAll(Colors.red)
                            : const MaterialStatePropertyAll(Colors.grey),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        )),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text("Transfer"),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
