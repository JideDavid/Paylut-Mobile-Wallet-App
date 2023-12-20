import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paylut/models/user_model.dart';

class Receipt extends StatefulWidget {
  final UserDetails userDetails;
  final String transactionRef;
  final bool newTransaction;
  const Receipt({super.key, required this.userDetails, required this.transactionRef, required this.newTransaction});

  @override
  State<Receipt> createState() =>
      // ignore: no_logic_in_create_state
      _ReceiptState(userDetails: userDetails, transactionRef: transactionRef, newTransaction: newTransaction);
}

class _ReceiptState extends State<Receipt> {
  UserDetails userDetails;
  String transactionRef;
  bool newTransaction;
  _ReceiptState({required this.userDetails, required this.transactionRef, required this.newTransaction});

  var f = NumberFormat("##,###,###", "en_US");

  int amount = 0;
  Timestamp date = Timestamp.now();
  int initialBalance = 0;
  int newBalance = 0;
  String ref = '';
  String type = '';
  String userTag = '';
  String username = '';
  bool isLoading = false;
  bool isCredit = false;

  TextStyle heading = const TextStyle(
    fontWeight: FontWeight.bold,
  );
  TextStyle subHeading = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
  );

  Future<void> getReceipt() async {
    isLoading = true;
    if (mounted) {
      setState(() {});
    }

    DocumentSnapshot rSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userDetails.uid)
        .collection('transactions')
        .doc(transactionRef)
        .get();

    amount = rSnapshot.get('amount');
    date = rSnapshot.get('date');
    initialBalance = rSnapshot.get('initialBalance');
    newBalance = rSnapshot.get('newBalance');
    ref = rSnapshot.get('transactionRef');
    type = rSnapshot.get('type');
    userTag = rSnapshot.get('userTag');
    username = rSnapshot.get('username');
    isCredit = rSnapshot.get('isCredit');

    if (kDebugMode) {
      print(
          '$amount, $date, $initialBalance, $newBalance, $ref, $type, $userTag, $username, $isCredit');
    }

    isLoading = false;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getReceipt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Receipt",
              style: heading,
            ),
            Text(
              "Transaction details",
              style: subHeading,
            )
          ],
        ),
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
                  color: isLoading ? Colors.grey : (isCredit ? Colors.green : Colors.red)),
              borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  const Text('Amount'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: const AssetImage(
                          'lib/icons/naira.png',
                        ),
                        height: 30,
                        color: isLoading ? Colors.grey : (isCredit ? Colors.green : Colors.red),
                      ),
                      Text(
                        f.format(amount).toString(),
                        style: TextStyle(
                            fontSize: 30,
                            color:
                                isLoading ? Colors.grey : (isCredit ? Colors.green : Colors.red)),
                      )
                    ],
                  ),
                  const Divider(
                    height: 80,
                    thickness: 1,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'SUCCESS',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isCredit ? 'From user' : 'To user',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Text(
                          username.toString(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'User Tag',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          userTag.toString(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Date',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(DateFormat('yy-MM-dd - kk:mm')
                            .format(DateTime.parse(date.toDate().toString()))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Reference',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(ref),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transaction type',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text('Transfer'),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 80,
                    thickness: 1,
                  ),
                  Visibility(
                    visible: newTransaction,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.grey.withOpacity(0.2),
                        width: double.infinity,
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(
                                Icons.info,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'The recipient account is expected to be credited within 2 minutes.',
                                style: TextStyle(),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.share,
                          color: Colors.red,
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
