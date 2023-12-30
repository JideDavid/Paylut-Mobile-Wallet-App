import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'vault_winners.dart';
import 'package:paylut/models/user_model.dart';

class ClaimVaultWin extends StatefulWidget {
  final UserDetails userDetails;
  final String vault;
  const ClaimVaultWin({super.key, required this.userDetails, required this.vault});

  @override
  // ignore: no_logic_in_create_state
  State<ClaimVaultWin> createState() => _ClaimVaultWinState(userDetails: userDetails, vault: vault);
}

class _ClaimVaultWinState extends State<ClaimVaultWin> {
  UserDetails userDetails;
  String vault;
  _ClaimVaultWinState({required this.userDetails, required this. vault});

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
  int winningEntryCount = 0;
  bool loading = true;
  bool pressed = false;
  bool pressed2 = false;
  bool claimed = false;
  int multiplier = 1;

  getEnteredNumbers() async {
    bool userClaim = await getClaimed();

    if (userClaim) {
      if (kDebugMode) {
        print('User already claimed winnings');
      }

      //getting user entry snapshot
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('vaults')
          .doc(vault)
          .collection('dailyEntries')
          .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
          .collection('entries')
          .doc(userDetails.uid).get();
      if(vault == 'bronze'){
        entryNumbers.add(snapshot.get('entry1'));
        entryNumbers.add(snapshot.get('entry2'));
        entryNumbers.add(snapshot.get('entry3'));
        entryNumbers.add(snapshot.get('entry4'));
        entryNumbers.add(snapshot.get('entry5'));
        entryNumbers.add(snapshot.get('entry6'));
        entryNumbers.add(snapshot.get('entry7'));
      }
      else if (vault == 'silver'){
        entryNumbers.add(snapshot.get('entry1'));
        entryNumbers.add(snapshot.get('entry2'));
        entryNumbers.add(snapshot.get('entry3'));
        entryNumbers.add(snapshot.get('entry4'));
        entryNumbers.add(snapshot.get('entry5'));
      }
      else{
        entryNumbers.add(snapshot.get('entry1'));
        entryNumbers.add(snapshot.get('entry2'));
        entryNumbers.add(snapshot.get('entry3'));
      }

      winningAmount = snapshot.get('amountClaimed');
      multiplier = snapshot.get('multiplier');
      var initLotAmount = winningAmount / multiplier;
      lotAmount = initLotAmount.toInt();

      DocumentSnapshot rSnapshot = await FirebaseFirestore.instance
      .collection('vaults')
      .doc(vault)
      .collection('dailyEntries')
      .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
      .get();
      if(rSnapshot.exists){
        if(vault == 'bronze'){
          resultNumbers.add(rSnapshot.get('result1'));
          resultNumbers.add(rSnapshot.get('result2'));
          resultNumbers.add(rSnapshot.get('result3'));
          resultNumbers.add(rSnapshot.get('result4'));
          resultNumbers.add(rSnapshot.get('result5'));
          resultNumbers.add(rSnapshot.get('result6'));
          resultNumbers.add(rSnapshot.get('result7'));
        }
        else if(vault == 'silver'){
          resultNumbers.add(rSnapshot.get('result1'));
          resultNumbers.add(rSnapshot.get('result2'));
          resultNumbers.add(rSnapshot.get('result3'));
          resultNumbers.add(rSnapshot.get('result4'));
          resultNumbers.add(rSnapshot.get('result5'));
        }
        else{
          resultNumbers.add(rSnapshot.get('result1'));
          resultNumbers.add(rSnapshot.get('result2'));
          resultNumbers.add(rSnapshot.get('result3'));
        }
      }

      if(kDebugMode){
        print('entryNumbers: $entryNumbers, winningEntryCount: $winningEntryCount');
      }

      //get user winning entry counts
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

      if(kDebugMode){
        print('here***********s\n'
            'winningAmount: $winningAmount, '
            'multiplier: $multiplier, '
            'initLotAmount: $initLotAmount, '
            'lotAmount: $lotAmount');
      }

      claimed = userClaim;
      loading = false;
      if (mounted) {
        setState((){});
      }
      return;
    } else {
      if (kDebugMode) {
        print('User has not claim winnings');
      }
    }

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('vaults')
        .doc(vault)
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .collection('entries')
        .doc(userDetails.uid)
        .get();
    entryNumbers = [];
    if (snapshot.exists) {
      if(vault == 'bronze'){
        entryNumbers.add(snapshot.get('entry1'));
        entryNumbers.add(snapshot.get('entry2'));
        entryNumbers.add(snapshot.get('entry3'));
        entryNumbers.add(snapshot.get('entry4'));
        entryNumbers.add(snapshot.get('entry5'));
        entryNumbers.add(snapshot.get('entry6'));
        entryNumbers.add(snapshot.get('entry7'));
      }
      else if(vault == 'silver'){
        entryNumbers.add(snapshot.get('entry1'));
        entryNumbers.add(snapshot.get('entry2'));
        entryNumbers.add(snapshot.get('entry3'));
        entryNumbers.add(snapshot.get('entry4'));
        entryNumbers.add(snapshot.get('entry5'));
      }
      else{
        entryNumbers.add(snapshot.get('entry1'));
        entryNumbers.add(snapshot.get('entry2'));
        entryNumbers.add(snapshot.get('entry3'));
      }

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
        .doc(vault)
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .get();
    resultNumbers = [];
    if (snapshot.exists) {
      if(vault == 'bronze'){
        resultNumbers.add(snapshot.get('result1'));
        resultNumbers.add(snapshot.get('result2'));
        resultNumbers.add(snapshot.get('result3'));
        resultNumbers.add(snapshot.get('result4'));
        resultNumbers.add(snapshot.get('result5'));
        resultNumbers.add(snapshot.get('result6'));
        resultNumbers.add(snapshot.get('result7'));
      }
      else if( vault == 'silver'){
        resultNumbers.add(snapshot.get('result1'));
        resultNumbers.add(snapshot.get('result2'));
        resultNumbers.add(snapshot.get('result3'));
        resultNumbers.add(snapshot.get('result4'));
        resultNumbers.add(snapshot.get('result5'));
      }
      else{
        resultNumbers.add(snapshot.get('result1'));
        resultNumbers.add(snapshot.get('result2'));
        resultNumbers.add(snapshot.get('result3'));
      }

      distributionAmount = snapshot.get('distributionAmount');

      if (kDebugMode) {
        print('got $vault results');
      }
    } else {
      if (kDebugMode) {
        print('$vault result for ${DateFormat('yyyy-MM-dd').format(DateTime.now())} do not exist');
      }
    }

    getResultEntryCounts();
  }

  getResultEntryCounts() async {
    resultEntryCounts = [];

    for (int i = 0; i < resultNumbers.length; i++) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('vaults')
          .doc(vault)
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

  calculateWinnings() async {
    //calculating lot amount
    int totalResultEntryCounts = 0;
    for (int i = 0; i < resultEntryCounts.length; i++) {
      totalResultEntryCounts += resultEntryCounts[i];
      if (kDebugMode) {
        print('totalEntries: $totalResultEntryCounts');
      }
    }
    double lotDAmount = distributionAmount / totalResultEntryCounts;

    if (kDebugMode) {
      print('distributionAmount: $distributionAmount, globalResultEntryCounts: $totalResultEntryCounts');
    }

    lotAmount = lotDAmount.toInt();
    if (kDebugMode) {
      print('lotAmount: $lotAmount');
    }

    //get user winning entry counts
    for (int i = 0; i < entryNumbers.length; i++) {
      if (resultNumbers.contains(entryNumbers[i])) {
        winningEntryCount++;
        if (kDebugMode) {
          print('userWinningEntryCount: $winningEntryCount');
        }
      } else {
        if (kDebugMode) {
          print('entry number ${entryNumbers[i]} is not a winning number');
        }
      }
    }

    //getting multiplier
    DocumentSnapshot mSnapshot = await FirebaseFirestore.instance
    .collection('vaults')
    .doc(vault)
    .collection('dailyEntries')
    .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
    .collection('entries')
    .doc(userDetails.uid)
    .get();
    if(mSnapshot.exists){
      multiplier = mSnapshot.get('multiplier');
    }else{
      if(kDebugMode){
        print('daily entry of ${DateFormat('yyyy-MM-dd').format(DateTime.now())} does not exist');
      }
    }

    //calculate winning amount
    winningAmount = winningEntryCount * lotAmount * multiplier;
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
        .doc(vault)
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .collection('entries')
        .doc(userDetails.uid)
        .get();

    if (snapshot.exists) {

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

    //checking if user has claimed already
    DocumentSnapshot claimSnapshot = await FirebaseFirestore.instance
        .collection('vaults')
        .doc(vault)
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .collection('entries')
        .doc(userDetails.uid)
        .get();

    if (claimSnapshot.exists) {
      bool claimed2 = claimSnapshot.get('claimed');
      if (claimed2) {
        if (kDebugMode) {
          print('user ${userDetails.uid} has already claimed winnings');
        }
      } else {
        //updating claim for user
        await FirebaseFirestore.instance
            .collection('vaults')
            .doc(vault)
            .collection('dailyEntries')
            .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
            .collection('entries')
            .doc(userDetails.uid)
            .update(
                {'claimed': true, 'amountClaimed': winningAmount, 'claimedDate': DateTime.now()});

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
          'vault': vault,
          'initialBalance': initBal,
          'isCredit': true,
          'newBalance': newBal,
          'transactionRef': ref,
          'type': "game"
        });

        //recording claim on bronze vault
        FirebaseFirestore.instance
            .collection('vaults')
            .doc(vault)
            .collection('dailyEntries')
            .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
            .collection('claims')
            .doc(userDetails.uid)
            .set({
          'uid': userDetails.uid,
          'name': userDetails.name,
          'amountClaimed': winningAmount,
          'date': now,
          'vault': vault,
          'winningEntryCount': winningEntryCount
        });
      }
    } else {
      if (kDebugMode) {
        print('user ${userDetails.uid} has not make an entry today');
      }
    }

    setState(() {
      claimed = true;
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
                        const SizedBox(height: 32,),
                        loading
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  'calculating your winnings...',
                                  style: TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.normal, color: Colors.red),
                                ),
                              )
                            : Column(
                              children: [
                                claimed ? Text('${winningAmount ~/ multiplier} x $multiplier')
                                : Text('${lotAmount * winningEntryCount} x $multiplier'),
                                Row(
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
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: claimed ? Colors.grey : Colors.red),
                                      ),
                                    ],
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
                                            builder: (context) {
                                              bool pressedClaim = false;
                                              return StatefulBuilder(builder: (context, setState) {
                                                return AlertDialog(
                                                  title: const Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text('Claim now'),
                                                    ],
                                                  ),
                                                  content: pressedClaim
                                                      ? const Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            SizedBox(
                                                              height: 15,
                                                              width: 15,
                                                              child: CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                color: Colors.red,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            Text('Loading')
                                                          ],
                                                        )
                                                      : Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              '${f.format(winningAmount)} NGN will be credited to your wallet instantly',
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ],
                                                        ),
                                                  actions: [
                                                    Visibility(
                                                      visible: pressedClaim ? false : true,
                                                      child: Row(
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
                                                                if (pressedClaim == false) {
                                                                  setState(() {
                                                                    pressedClaim = true;
                                                                  });
                                                                  await claimAction();
                                                                  // ignore: use_build_context_synchronously
                                                                  Navigator.of(context).pop();
                                                                } else {
                                                                  return;
                                                                }
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
                                                      ),
                                                    )
                                                  ],
                                                );
                                              });
                                            });
                                      },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: pressed ? Colors.red.withOpacity(0.2) : null,
                                    border: Border.all(
                                      color: loading ? Colors.grey : Colors.red,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child:  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                    child: Text(
                                      'Claim',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: loading ? Colors.grey : null),
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(
                          height: 32,
                        ),
                        GestureDetector(
                          onTapDown: (tapDetails) {
                            setState(() {
                              pressed2 = true;
                            });
                          },
                          onTapUp: (tapDetails) {
                            setState(() {
                              pressed2 = false;
                            });
                          },
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return VaultWinners(date: DateTime.now());
                            }));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: pressed2 ? Colors.red.withOpacity(0.2) : null,
                              border: Border.all(
                                color: Colors.red,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              child: Text(
                                'View Results Details',
                                style: TextStyle(fontWeight: FontWeight.bold,),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),

              ],
            )
          ],
        ),
      ),
    );
  }
}
