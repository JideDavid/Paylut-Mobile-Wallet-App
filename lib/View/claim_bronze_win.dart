import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paylut/models/user_model.dart';

class ClaimBronzeWin extends StatefulWidget {
  final UserDetails userDetails;
  const ClaimBronzeWin({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<ClaimBronzeWin> createState() => _ClaimBronzeWinState(userDetails: userDetails);
}

class _ClaimBronzeWinState extends State<ClaimBronzeWin> {
  UserDetails userDetails;
  _ClaimBronzeWinState({required this.userDetails});

  TextStyle heading = const TextStyle(
    fontWeight: FontWeight.bold,
  );
  TextStyle subHeading = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
  );

  var f = NumberFormat("##,###,###.00", "en_US");

  List<int> entryNumbers = [];
  int amountPlayed = 0;
  List<int> resultNumbers = [];
  int distributionAmount = 0;
  List<int> resultEntryCounts = [];
  int lotAmount = 0;
  int winningAmount = 0;
  bool loading = true;
  bool pressed = false;
  bool claimed = false;

  getEnteredNumbers() async {
    bool userClaim = await getClaimed();

    if (userClaim) {
      if (kDebugMode) {
        print('User already claimed winnings');
      }
      claimed = userClaim;
      loading = false;
      if (mounted) {
        setState(() {});
      }
      return;
    } else {
      if (kDebugMode) {
        print('User has not claim winnings');
      }
    }

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('vaults')
        .doc('bronze')
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .collection('entries')
        .doc(userDetails.uid)
        .get();
    entryNumbers = [];
    if (snapshot.exists) {
      entryNumbers.add(snapshot.get('entry1'));
      entryNumbers.add(snapshot.get('entry2'));
      entryNumbers.add(snapshot.get('entry3'));
      entryNumbers.add(snapshot.get('entry4'));
      entryNumbers.add(snapshot.get('entry5'));
      entryNumbers.add(snapshot.get('entry6'));
      entryNumbers.add(snapshot.get('entry7'));
      amountPlayed = snapshot.get('amount');

      if (kDebugMode) {
        print('got user entry data');
      }
    } else {}

    getResultNumbers();
  }

  getResultNumbers() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('vaults')
        .doc('bronze')
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .get();
    resultNumbers = [];
    if (snapshot.exists) {
      resultNumbers.add(snapshot.get('result1'));
      resultNumbers.add(snapshot.get('result2'));
      resultNumbers.add(snapshot.get('result3'));
      resultNumbers.add(snapshot.get('result4'));
      resultNumbers.add(snapshot.get('result5'));
      resultNumbers.add(snapshot.get('result6'));
      resultNumbers.add(snapshot.get('result7'));
      distributionAmount = snapshot.get('distributionAmount');

      if (kDebugMode) {
        print('got bronze results');
      }
    } else {
      if (kDebugMode) {
        print('bronze result for ${DateFormat('yyyy-MM-dd').format(DateTime.now())} do not exist');
      }
    }

    getResultEntryCounts();
  }

  getResultEntryCounts() async {
    resultEntryCounts = [];

    for (int i = 0; i < resultNumbers.length; i++) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('vaults')
          .doc('bronze')
          .collection('dailyEntries')
          .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
          .collection('entries')
          .doc('entryCount')
          .get();
      if (snapshot.exists) {
        resultEntryCounts.add(snapshot.get((resultNumbers[i]).toString()));
        if (kDebugMode) {
          print('counts for ${resultNumbers[i]} is ${resultEntryCounts[i]}');
        }
      } else {
        if (kDebugMode) {
          print('entry count for ${resultNumbers[i]} do not exist');
        }
      }
    }

    calculateWinnings();
  }

  calculateWinnings() {
    //calculating lot amount
    int totalEntries = 0;
    for (int i = 0; i < resultEntryCounts.length; i++) {
      totalEntries += resultEntryCounts[i];
      if (kDebugMode) {
        print('totalEntries: $totalEntries');
      }
    }
    double lotDAmount = distributionAmount / totalEntries;
    lotAmount = lotDAmount.toInt();
    if (kDebugMode) {
      print('lotAmount: $lotAmount');
    }

    //get user winning entry counts
    int winningEntryCount = 0;
    for (int i = 0; i < entryNumbers.length; i++) {
      if (resultNumbers.contains(entryNumbers[i])) {
        winningEntryCount++;
        if (kDebugMode) {
          print('winningEntryCount: $winningEntryCount');
        }
      } else {
        if (kDebugMode) {
          print('entry number ${entryNumbers[i]} is not a winning number');
        }
      }
    }

    //calculate winning amount
    winningAmount = winningEntryCount * lotAmount;
    if (kDebugMode) {
      print('winningAmount: $winningAmount');
    }
    loading = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<bool> getClaimed() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('vaults')
        .doc('bronze')
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .collection('entries')
        .doc(userDetails.uid)
        .get();

    if (snapshot.exists) {
      winningAmount = snapshot.get('amountClaimed');
      bool userClaim = snapshot.get('claimed');
      return userClaim;
    } else {
      if (kDebugMode) {
        print('user ${userDetails.uid} has not played today');
      }
      return false;
    }
  }

  claimAction() async {
    if (kDebugMode) {
      print('running claim action');
    }

    //updating claim for user
    await FirebaseFirestore.instance
        .collection('vaults')
        .doc('bronze')
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .collection('entries')
        .doc(userDetails.uid)
        .update({'claimed': true, 'amountClaimed': winningAmount, 'claimedDate': DateTime.now()});

    int initBal = 0;
    int newBal = 0;

    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userDetails.uid).get();
    if (snapshot.exists) {
      initBal = snapshot.get('walletBalance');
    } else {
      if (kDebugMode) {
        print('user ${userDetails.uid} does not exist on database');
      }
    }

    newBal = initBal + winningAmount;

    DateTime now = DateTime.now();
    String ref = 'ref_$now';
    ref = ref.replaceAll(' ', '');
    ref = ref.replaceAll('-', '');
    ref = ref.replaceAll(':', '');
    ref = ref.replaceAll('.', '');

    //crediting user wallet
    FirebaseFirestore.instance
        .collection('users')
        .doc(userDetails.uid)
        .update({'walletBalance': newBal});

    //recording transaction on user wallet
    FirebaseFirestore.instance
        .collection('users')
        .doc(userDetails.uid)
        .collection('transactions')
        .doc(ref)
        .set({
      'amount': winningAmount,
      'date': now,
      'gameCategory': "vault break",
      'vault': 'bronze',
      'initialBalance': initBal,
      'isCredit': true,
      'newBalance': newBal,
      'transactionRef': ref,
      'type': "game"
    });

    //recording claim on bronze vault
    FirebaseFirestore.instance
        .collection('vaults')
        .doc('bronze')
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .collection('claims')
        .doc(userDetails.uid)
        .set({
      'uid': userDetails.uid,
      'name': userDetails.name,
      'amountClaimed': winningAmount,
      'date': now,
    });

    if (kDebugMode) {
      print('finished claim action');
    }
  }

  @override
  void initState() {
    super.initState();
    getEnteredNumbers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/backgrounds/confetti.png'), fit: BoxFit.cover)),
            ),
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/backgrounds/win_people.png'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Center(
                  child: Column(
                    children: [
                      const Text(
                        'Congratulations',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        claimed ? 'You\'ve Claimed' : 'You\'ve Won',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      loading
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'calculating your winnings...',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.normal, color: Colors.red),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'lib/icons/naira.png',
                                  height: 32,
                                  color: claimed ? Colors.grey : Colors.red,
                                ),
                                Text(
                                  f.format(winningAmount).toString(),
                                  style: TextStyle(
                                      fontSize: 40, fontWeight: FontWeight.bold, color: claimed ? Colors.grey : Colors.red),
                                ),
                              ],
                            ),
                      const SizedBox(
                        height: 32,
                      ),
                      claimed
                          ? const CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 30,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 40,
                              ),
                            )
                          : GestureDetector(
                              onTapDown: loading
                                  ? null
                                  : (tapDownDetails) {
                                      pressed = true;
                                      if (mounted) {
                                        setState(() {});
                                      }
                                    },
                              onTapUp: loading
                                  ? null
                                  : (tapDownDetails) {
                                      pressed = false;
                                      if (mounted) {
                                        setState(() {});
                                      }

                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: const Text('Claim now'),
                                                content: Text(
                                                    '$winningAmount NGN will be credited to your wallet instantly'),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Row(
                                                            children: [
                                                              Icon(
                                                                Icons.cancel,
                                                                color: Colors.red,
                                                              ),
                                                              Text(
                                                                'Cancel',
                                                                style:
                                                                    TextStyle(color: Colors.grey),
                                                              )
                                                            ],
                                                          )),
                                                      TextButton(
                                                          onPressed: () async {
                                                            await claimAction();
                                                            setState(() {
                                                              claimed = true;
                                                            });
                                                            // ignore: use_build_context_synchronously
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Row(
                                                            children: [
                                                              Icon(
                                                                Icons.check_circle,
                                                                color: Colors.green,
                                                              ),
                                                              Text(
                                                                'Confirm',
                                                                style:
                                                                    TextStyle(color: Colors.grey),
                                                              )
                                                            ],
                                                          ))
                                                    ],
                                                  )
                                                ],
                                              ));
                                    },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: pressed ? Colors.red.withOpacity(0.2) : null,
                                  border: Border.all(
                                    color: loading ? Colors.grey : Colors.red,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                  child: Text(
                                    'Claim',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
