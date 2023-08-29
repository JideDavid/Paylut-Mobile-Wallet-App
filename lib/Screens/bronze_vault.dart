import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paylut/models/user_model.dart';
import 'dart:math';

class BronzeVault extends StatefulWidget {
  final UserDetails userDetails;
  const BronzeVault({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<BronzeVault> createState() => _BronzeVaultState(userDetails: userDetails);
}

class _BronzeVaultState extends State<BronzeVault> with TickerProviderStateMixin {
  UserDetails userDetails;
  _BronzeVaultState({required this.userDetails});

  bool isLoading = true;
  int number1 = 1;
  bool isScrolling1 = false;
  int number2 = 1;
  bool isScrolling2 = false;
  int number3 = 1;
  bool isScrolling3 = false;
  int number4 = 1;
  bool isScrolling4 = false;
  int number5 = 1;
  bool isScrolling5 = false;
  int number6 = 1;
  bool isScrolling6 = false;
  int number7 = 1;
  bool isScrolling7 = false;
  bool hasInputAmount = false;
  int amount = 0;
  int possibleEarnings = 0;
  int vaultAmount = 5000000;
  String entryValue = '';
  int initialEntryCount = 0;
  bool hasPlayed = false;
  bool isRecordingEntry = false;
  String transactionRef = '';
  int newBalance = 0;
  DateTime now = DateTime.now();
  int initialBalance = 0;
  int playedNumber1 = 0;
  int playedNumber2 = 0;
  int playedNumber3 = 0;
  int playedNumber4 = 0;
  int playedNumber5 = 0;
  int playedNumber6 = 0;
  int playedNumber7 = 0;
  int amountPlayed = 0;
  bool hasResult = false;
  int result1 = 0;
  int result2 = 0;
  int result3 = 0;
  int result4 = 0;
  int result5 = 0;
  int result6 = 0;
  int result7 = 0;
  bool entry1Win = false;
  bool entry2Win = false;
  bool entry3Win = false;
  bool entry4Win = false;
  bool entry5Win = false;
  bool entry6Win = false;
  bool entry7Win = false;
  int winEntryCount = 0;

  TextEditingController amountController = TextEditingController();
  Animation? animation;
  AnimationController? animationControllerBronze;

  //function to calculate possible earnings
  void calculatePossibleEarnings(int amount) {
    setState(() {
      Random random = Random();
      int randomNumber = random.nextInt(10) + 7; // from 10 up to 100 included
      possibleEarnings = randomNumber * amount;
    });
  }

  Future<void> updateAmountInVault() async {
    Random random = Random();
    int randomTime = random.nextInt(6) + 1; // from 1 up to 3 included
    int randomAmount = random.nextInt(9999) + 10; // from 10 up to 9999

    for (int i = 0; i < 1000 && mounted; i++) {
      int oldVaultAmount = vaultAmount;
      int newVaultAmount = vaultAmount + randomAmount;
      animationControllerBronze = AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      );
      animation = IntTween(begin: oldVaultAmount, end: newVaultAmount)
          .animate(CurvedAnimation(parent: animationControllerBronze!, curve: Curves.easeOut));
      animationControllerBronze!.forward();
      if (mounted) {
        animationControllerBronze!.addListener(() {
          setState(() {});
        });
      }
      vaultAmount = newVaultAmount;
      await Future.delayed(Duration(seconds: randomTime), () {});
    }
  }

  //function to charge wallet
  Future<void> chargeWallet(int chargeAmount) async {
    DateTime now = DateTime.now();

    //getting initial balance
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userDetails.uid).get();

    //charging wallet
    initialBalance = snapshot.get('walletBalance');
    newBalance = initialBalance - chargeAmount;

    //updating wallet
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userDetails.uid)
        .update({'walletBalance': newBalance});

    //formatting and setting transaction reference
    String ref = "ref_$now";
    ref = ref.replaceAll(' ', '');
    ref = ref.replaceAll('_', '');
    ref = ref.replaceAll('-', '');
    ref = ref.replaceAll(':', '');
    ref = ref.replaceAll('.', '');
    transactionRef = ref;

    //recording transaction in history
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userDetails.uid)
        .collection('transactions')
        .doc(transactionRef)
        .set({
      'type': 'game',
      'isCredit': false,
      'amount': amount,
      'gameCategory': 'vault break',
      'date': now,
      'transactionRef': transactionRef,
      'initialBalance': initialBalance,
      'newBalance': newBalance
    });
    if (kDebugMode) {
      print('recoded vault transaction in history');
    }
  }

  //function to record vault entries
  Future<void> recordVaultEntries() async {
    //recording vault break entries
    await FirebaseFirestore.instance
        .collection('vaults')
        .doc('bronze')
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(now))
        .collection('entries')
        .doc(userDetails.uid)
        .set({
      'entry1': number1,
      'entry2': number2,
      'entry3': number3,
      'entry4': number4,
      'entry5': number5,
      'entry6': number6,
      'entry7': number7,
      'date': now,
      'amount': amount,
      'uid': userDetails.uid
    });
    if (kDebugMode) {
      print('recoded vault entries');
    }

    //add entries to entry count

    //making a for loop to switch the function for all entry values
    for (int i = 0; i < 7; i++) {
      switch (i) {
        case 0:
          entryValue = number1.toString();
        case 1:
          entryValue = number2.toString();
        case 2:
          entryValue = number3.toString();
        case 3:
          entryValue = number4.toString();
        case 4:
          entryValue = number5.toString();
        case 5:
          entryValue = number6.toString();
        case 6:
          entryValue = number7.toString();
      }

      //get entry count value
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('vaults')
          .doc('bronze')
          .collection('dailyEntries')
          .doc(DateFormat('yyyy-MM-dd').format(now))
          .collection('entries')
          .doc('entryCount')
          .get();

      if (snapshot.exists) {
        initialEntryCount = snapshot.get(entryValue);
        if (kDebugMode) {
          print('got entry count value');
        }
      } else {
        if (kDebugMode) {
          print('no vault entries yet');
        }

        initialEntryCount = 0;

        //create a default document on entry count path with default entry count values of zero
        await FirebaseFirestore.instance
            .collection('vaults')
            .doc('bronze')
            .collection('dailyEntries')
            .doc(DateFormat('yyyy-MM-dd').format(now))
            .collection('entries')
            .doc('entryCount')
            .set({
          '1': 0,
          '2': 0,
          '3': 0,
          '4': 0,
          '5': 0,
          '6': 0,
          '7': 0,
          '8': 0,
          '9': 0,
          '10': 0,
          '11': 0,
          '12': 0,
          '13': 0,
          '14': 0,
          '15': 0,
          '16': 0,
          '17': 0,
          '18': 0,
          '19': 0,
          '20': 0,
          '21': 0,
          '22': 0,
          '23': 0,
          '24': 0,
          '25': 0,
          '26': 0,
          '27': 0,
          '28': 0,
          '29': 0,
          '30': 0,
          '31': 0,
          '32': 0,
          '33': 0,
          '34': 0,
          '35': 0,
          '36': 0,
          '37': 0,
          '38': 0,
          '39': 0,
          '40': 0,
          '41': 0,
          '42': 0,
          '43': 0,
          '44': 0,
          '45': 0,
          '46': 0,
          '47': 0,
          '48': 0,
          '49': 0,
          '50': 0,
          '51': 0,
          '52': 0,
          '53': 0,
          '54': 0,
          '55': 0,
          '56': 0,
          '57': 0,
          '58': 0,
          '59': 0,
          '60': 0,
          '61': 0,
          '62': 0,
          '63': 0,
          '64': 0,
          '65': 0,
          '66': 0,
          '67': 0,
          '68': 0,
          '69': 0,
          '70': 0,
          '71': 0,
          '72': 0,
          '73': 0,
          '74': 0,
          '75': 0,
          '76': 0,
          '77': 0,
          '78': 0,
          '79': 0,
          '80': 0,
          '81': 0,
          '82': 0,
          '83': 0,
          '84': 0,
          '85': 0,
          '86': 0,
          '87': 0,
          '88': 0,
          '89': 0,
          '90': 0,
          '91': 0,
          '92': 0,
          '93': 0,
          '94': 0,
          '95': 0,
          '96': 0,
          '97': 0,
          '98': 0,
          '99': 0
        });
        if (kDebugMode) {
          print('created default document for vault entry count');
        }

        //creating result document template in vault break codes path
        await FirebaseFirestore.instance
            .collection('vaults')
            .doc('bronze')
            .collection('dailyEntries')
            .doc(DateFormat('yyyy-MM-dd').format(now))
            .set({
          'result1': 0,
          'result2': 0,
          'result3': 0,
          'result4': 0,
          'result5': 0,
          'result6': 0,
          'result7': 0,
          'hasResult': false
        });
        if (kDebugMode) {
          print('created default document for vault break codes results');
        }
      }

      //increment entry count value
      await FirebaseFirestore.instance
          .collection('vaults')
          .doc('bronze')
          .collection('dailyEntries')
          .doc(DateFormat('yyyy-MM-dd').format(now))
          .collection('entries')
          .doc('entryCount')
          .update({entryValue: initialEntryCount + 1});
      if (kDebugMode) {
        print('incremented vault entry count');
      }
    }
  }

  //function to check if player has made any entry
  Future<void> checkPlayed() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('vaults')
        .doc('bronze')
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .collection('entries')
        .doc(userDetails.uid)
        .get();

    if (snapshot.exists) {
      playedNumber1 = snapshot.get('entry1');
      playedNumber2 = snapshot.get('entry2');
      playedNumber3 = snapshot.get('entry3');
      playedNumber4 = snapshot.get('entry4');
      playedNumber5 = snapshot.get('entry5');
      playedNumber6 = snapshot.get('entry6');
      playedNumber7 = snapshot.get('entry7');
      amountPlayed = snapshot.get('amount');
      hasPlayed = true;
      await getResults();
      checkWin();
    } else {
      hasPlayed = false;
    }

    isLoading = false;
  }

  //function to charge wallet and record transaction and entries in history
  Future<void> chargeWalletAndRecordVaultEntry() async {
    DocumentSnapshot userData =
        await FirebaseFirestore.instance.collection('users').doc(userDetails.uid).get();
    int walletBalance = userData.get('walletBalance');

    //checking wallet balance before charging wallet
    if (walletBalance >= amount) {
      isRecordingEntry = true;
      //charging wallet
      await chargeWallet(amount);
      //recording vault entries
      await recordVaultEntries();
      isRecordingEntry = false;
      await checkPlayed();
      setState(() {});
    } else {
      int difference = amount - walletBalance;
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.redAccent,
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel_rounded,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Error',
                    style: TextStyle(color: Colors.white),
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
                          style: const TextStyle(color: Colors.white),
                        )
                      ])),
            );
          });
    }
  }

  //function to get result
  Future<void> getResults() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('vaults')
        .doc('bronze')
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .get();
    bool result = snapshot.get('hasResult');
    if (result) {
      result1 = snapshot.get('result1');
      result2 = snapshot.get('result2');
      result3 = snapshot.get('result3');
      result4 = snapshot.get('result4');
      result5 = snapshot.get('result5');
      result6 = snapshot.get('result6');
      result7 = snapshot.get('result7');
      hasResult = true;
      setState(() {});
    } else {
      hasResult = false;
    }
  }

  //function to check if user has a winning entry
  checkWin() {
    //check entry1
    if (playedNumber1 == result1 ||
        playedNumber1 == result2 ||
        playedNumber1 == result3 ||
        playedNumber1 == result4 ||
        playedNumber1 == result5 ||
        playedNumber1 == result6 ||
        playedNumber1 == result7) {
      entry1Win = true;
      winEntryCount++;
    } else {
      entry1Win = false;
    }
    //check entry2
    if (playedNumber2 == result1 ||
        playedNumber2 == result2 ||
        playedNumber2 == result3 ||
        playedNumber2 == result4 ||
        playedNumber2 == result5 ||
        playedNumber2 == result6 ||
        playedNumber2 == result7) {
      entry2Win = true;
      winEntryCount++;
    } else {
      entry2Win = false;
    }
    //check entry3
    if (playedNumber3 == result1 ||
        playedNumber3 == result2 ||
        playedNumber3 == result3 ||
        playedNumber3 == result4 ||
        playedNumber3 == result5 ||
        playedNumber3 == result6 ||
        playedNumber3 == result7) {
      entry3Win = true;
      winEntryCount++;
    } else {
      entry3Win = false;
    }
    //check entry4
    if (playedNumber4 == result1 ||
        playedNumber4 == result2 ||
        playedNumber4 == result3 ||
        playedNumber4 == result4 ||
        playedNumber4 == result5 ||
        playedNumber4 == result6 ||
        playedNumber4 == result7) {
      entry4Win = true;
      winEntryCount++;
    } else {
      entry4Win = false;
    }
    //check entry5
    if (playedNumber5 == result1 ||
        playedNumber5 == result2 ||
        playedNumber5 == result3 ||
        playedNumber5 == result4 ||
        playedNumber5 == result5 ||
        playedNumber5 == result6 ||
        playedNumber5 == result7) {
      entry5Win = true;
      winEntryCount++;
    } else {
      entry5Win = false;
    }
    //check entry6
    if (playedNumber6 == result1 ||
        playedNumber6 == result2 ||
        playedNumber6 == result3 ||
        playedNumber6 == result4 ||
        playedNumber6 == result5 ||
        playedNumber6 == result6 ||
        playedNumber6 == result7) {
      entry6Win = true;
      winEntryCount++;
    } else {
      entry6Win = false;
    }
    //check entry7
    if (playedNumber7 == result1 ||
        playedNumber7 == result2 ||
        playedNumber7 == result3 ||
        playedNumber7 == result4 ||
        playedNumber7 == result5 ||
        playedNumber7 == result6 ||
        playedNumber7 == result7) {
      entry7Win = true;
      winEntryCount++;
    } else {
      entry7Win = false;
    }

    if (kDebugMode) {
      print("winEntryCount: $winEntryCount");
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //checking if user has made an entry for the day
    checkPlayed();
    //vault amount update and animation
    updateAmountInVault();
  }

  @override
  void dispose() {
    animationControllerBronze!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle heading = const TextStyle(
      fontWeight: FontWeight.bold,
    );
    TextStyle subHeading = const TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
           title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bronze Vault",
              style: heading,
            ),
            Text(
              "crack the vault codes to share the treasure",
              style: subHeading,
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert_outlined,
              ))
        ],
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : (hasPlayed
              ?
              //showing user selected vault entries
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color: Colors.grey.withOpacity(0.2),
                            child: Column(
                              children: [
                                //amount in vault and results
                                Expanded(
                                  flex: 5,
                                  child: Stack(children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage('assets/banners/golden_vault.jpg'),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    Container(color: Colors.black.withOpacity(0.4)),
                                    //amount in vault and result
                                    hasResult
                                        ? Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                                //top space
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Expanded(child: Container()),
                                                      //amount in vault
                                                      Expanded(
                                                        flex: 2,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.center,
                                                              children: [
                                                                Image.asset(
                                                                  "lib/icons/naira.png",
                                                                  color: Colors.white,
                                                                  scale: 20,
                                                                ),
                                                                Text(
                                                                  animation!.value.toString(),
                                                                  style: const TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 35),
                                                                ),
                                                              ],
                                                            ),
                                                            const Expanded(
                                                              child: Text(
                                                                "amount in vault",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 15),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      //middle space
                                                      Expanded(child: Container()),
                                                      //results
                                                      Expanded(
                                                        flex: 2,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.center,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                //numbers
                                                                Expanded(
                                                                    flex: 4,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment.center,
                                                                      children: [
                                                                        //number cards
                                                                        //number 1
                                                                        Container(
                                                                          height: 50,
                                                                          width: 35,
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(
                                                                                  width: 2,
                                                                                  color:
                                                                                      Colors.white),
                                                                              borderRadius:
                                                                                  BorderRadius
                                                                                      .circular(
                                                                                          10)),
                                                                          child: Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment
                                                                                    .center,
                                                                            children: [
                                                                              const Icon(Icons.star,
                                                                                  size: 10,
                                                                                  color:
                                                                                      Colors.red),
                                                                              Text(
                                                                                result1.toString(),
                                                                                style: const TextStyle(
                                                                                    fontWeight:
                                                                                        FontWeight
                                                                                            .normal,
                                                                                    fontSize: 16,
                                                                                    color: Colors
                                                                                        .white),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 8,
                                                                        ),
                                                                        //number2
                                                                        Container(
                                                                          height: 50,
                                                                          width: 35,
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(
                                                                                  width: 2,
                                                                                  color:
                                                                                      Colors.white),
                                                                              borderRadius:
                                                                                  BorderRadius
                                                                                      .circular(
                                                                                          10)),
                                                                          child: Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment
                                                                                    .center,
                                                                            children: [
                                                                              const Icon(Icons.star,
                                                                                  size: 10,
                                                                                  color:
                                                                                      Colors.red),
                                                                              Text(
                                                                                result2.toString(),
                                                                                style: const TextStyle(
                                                                                    fontWeight:
                                                                                        FontWeight
                                                                                            .normal,
                                                                                    fontSize: 16,
                                                                                    color: Colors
                                                                                        .white),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 8,
                                                                        ),
                                                                        //number3
                                                                        Container(
                                                                          height: 50,
                                                                          width: 35,
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(
                                                                                  width: 2,
                                                                                  color:
                                                                                      Colors.white),
                                                                              borderRadius:
                                                                                  BorderRadius
                                                                                      .circular(
                                                                                          10)),
                                                                          child: Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment
                                                                                    .center,
                                                                            children: [
                                                                              const Icon(Icons.star,
                                                                                  size: 10,
                                                                                  color:
                                                                                      Colors.red),
                                                                              Text(
                                                                                result3.toString(),
                                                                                style: const TextStyle(
                                                                                    fontWeight:
                                                                                        FontWeight
                                                                                            .normal,
                                                                                    fontSize: 16,
                                                                                    color: Colors
                                                                                        .white),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 8,
                                                                        ),
                                                                        //number4
                                                                        Container(
                                                                          height: 50,
                                                                          width: 35,
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(
                                                                                  width: 2,
                                                                                  color:
                                                                                      Colors.white),
                                                                              borderRadius:
                                                                                  BorderRadius
                                                                                      .circular(
                                                                                          10)),
                                                                          child: Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment
                                                                                    .center,
                                                                            children: [
                                                                              const Icon(Icons.star,
                                                                                  size: 10,
                                                                                  color:
                                                                                      Colors.red),
                                                                              Text(
                                                                                result4.toString(),
                                                                                style: const TextStyle(
                                                                                    fontWeight:
                                                                                        FontWeight
                                                                                            .normal,
                                                                                    fontSize: 16,
                                                                                    color: Colors
                                                                                        .white),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 8,
                                                                        ),
                                                                        //number5
                                                                        Container(
                                                                          height: 50,
                                                                          width: 35,
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(
                                                                                  width: 2,
                                                                                  color:
                                                                                      Colors.white),
                                                                              borderRadius:
                                                                                  BorderRadius
                                                                                      .circular(
                                                                                          10)),
                                                                          child: Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment
                                                                                    .center,
                                                                            children: [
                                                                              const Icon(Icons.star,
                                                                                  size: 10,
                                                                                  color:
                                                                                      Colors.red),
                                                                              Text(
                                                                                result5.toString(),
                                                                                style: const TextStyle(
                                                                                    fontWeight:
                                                                                        FontWeight
                                                                                            .normal,
                                                                                    fontSize: 16,
                                                                                    color: Colors
                                                                                        .white),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 8,
                                                                        ),
                                                                        //number6
                                                                        Container(
                                                                          height: 50,
                                                                          width: 35,
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(
                                                                                  width: 2,
                                                                                  color:
                                                                                      Colors.white),
                                                                              borderRadius:
                                                                                  BorderRadius
                                                                                      .circular(
                                                                                          10)),
                                                                          child: Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment
                                                                                    .center,
                                                                            children: [
                                                                              const Icon(Icons.star,
                                                                                  size: 10,
                                                                                  color:
                                                                                      Colors.red),
                                                                              Text(
                                                                                result6.toString(),
                                                                                style: const TextStyle(
                                                                                    fontWeight:
                                                                                        FontWeight
                                                                                            .normal,
                                                                                    fontSize: 16,
                                                                                    color: Colors
                                                                                        .white),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 8,
                                                                        ),
                                                                        //number7
                                                                        Container(
                                                                          height: 50,
                                                                          width: 35,
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(
                                                                                  width: 2,
                                                                                  color:
                                                                                      Colors.white),
                                                                              borderRadius:
                                                                                  BorderRadius
                                                                                      .circular(
                                                                                          10)),
                                                                          child: Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment
                                                                                    .center,
                                                                            children: [
                                                                              const Icon(Icons.star,
                                                                                  size: 10,
                                                                                  color:
                                                                                      Colors.red),
                                                                              Text(
                                                                                result7.toString(),
                                                                                style: const TextStyle(
                                                                                    fontWeight:
                                                                                        FontWeight
                                                                                            .normal,
                                                                                    fontSize: 16,
                                                                                    color: Colors
                                                                                        .white),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ))
                                                              ],
                                                            ),
                                                            const SizedBox(height: 8),
                                                            const Expanded(
                                                              child: Text(
                                                                "vault result codes",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 15),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      //down space
                                                      Expanded(child: Container()),
                                                    ],
                                                  ),
                                                ),
                                              ])
                                        //amount in vault only,
                                        : Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    "lib/icons/naira.png",
                                                    color: Colors.white,
                                                    scale: 20,
                                                  ),
                                                  Text(
                                                    animation!.value.toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white, fontSize: 35),
                                                  ),
                                                ],
                                              ),
                                              const Text(
                                                "amount in vault",
                                                style: TextStyle(color: Colors.white, fontSize: 15),
                                              ),
                                            ],
                                          )
                                  ]),
                                ),
                                //selected numbers preview
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      //selected numbers
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "your crack codes entries",
                                              style: TextStyle(color: Colors.red),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Row(
                                              children: [
                                                //numbers
                                                Expanded(
                                                    flex: 4,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        //number cards
                                                        //number 1
                                                        Container(
                                                          height: 50,
                                                          width: 35,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  width: 2, color: Colors.grey),
                                                              borderRadius:
                                                                  BorderRadius.circular(10)),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                playedNumber1.toString(),
                                                                style: const TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    fontSize: 16,
                                                                    color: Colors.red),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        //number2
                                                        Container(
                                                          height: 50,
                                                          width: 35,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  width: 2, color: Colors.grey),
                                                              borderRadius:
                                                                  BorderRadius.circular(10)),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                playedNumber2.toString(),
                                                                style: const TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    fontSize: 16,
                                                                    color: Colors.red),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        //number3
                                                        Container(
                                                          height: 50,
                                                          width: 35,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  width: 2, color: Colors.grey),
                                                              borderRadius:
                                                                  BorderRadius.circular(10)),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                playedNumber3.toString(),
                                                                style: const TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    fontSize: 16,
                                                                    color: Colors.red),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        //number4
                                                        Container(
                                                          height: 50,
                                                          width: 35,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  width: 2, color: Colors.grey),
                                                              borderRadius:
                                                                  BorderRadius.circular(10)),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                playedNumber4.toString(),
                                                                style: const TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    fontSize: 16,
                                                                    color: Colors.red),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        //number5
                                                        Container(
                                                          height: 50,
                                                          width: 35,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  width: 2, color: Colors.grey),
                                                              borderRadius:
                                                                  BorderRadius.circular(10)),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                playedNumber5.toString(),
                                                                style: const TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    fontSize: 16,
                                                                    color: Colors.red),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        //number6
                                                        Container(
                                                          height: 50,
                                                          width: 35,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  width: 2, color: Colors.grey),
                                                              borderRadius:
                                                                  BorderRadius.circular(10)),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                playedNumber6.toString(),
                                                                style: const TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    fontSize: 16,
                                                                    color: Colors.red),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        //number7
                                                        Container(
                                                          height: 50,
                                                          width: 35,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  width: 2, color: Colors.grey),
                                                              borderRadius:
                                                                  BorderRadius.circular(10)),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                playedNumber7.toString(),
                                                                style: const TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    fontSize: 16,
                                                                    color: Colors.red),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "lib/icons/naira.png",
                                                  color: Colors.grey,
                                                  scale: 30,
                                                ),
                                                Text(
                                                  amountPlayed.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.grey, fontSize: 25),
                                                ),
                                              ],
                                            ),
                                            const Text(
                                              "vault break token",
                                              style: TextStyle(color: Colors.grey, fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //claim button
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: winEntryCount == 0 ? null : () {},
                                              style: ButtonStyle(
                                                  backgroundColor: winEntryCount == 0
                                                      ? const MaterialStatePropertyAll(Colors.grey)
                                                      : const MaterialStatePropertyAll(Colors.red),
                                                  shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20.0),
                                                    ),
                                                  )),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(vertical: 12),
                                                child: Text("Claim Wins"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //info text
                                Expanded(
                                    flex: 2,
                                    child: hasResult
                                        ? Container(
                                            width: double.infinity,
                                            color: Colors.grey.withOpacity(0.2),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.info,
                                                    size: 25, color: Colors.grey),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(horizontal: 12),
                                                  child: winEntryCount == 0
                                                      ? const Text(
                                                          'results are out, you have 0 winning entries',
                                                          textAlign: TextAlign.center)
                                                      : Text(
                                                          'results are out, you have $winEntryCount winning entries',
                                                          textAlign: TextAlign.center),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                    winEntryCount == 0
                                                        ? 'don\'t give up, try again tomorrow'
                                                        : 'claim your winnings',
                                                    style: const TextStyle(
                                                        color: Colors.grey, fontSize: 12)),
                                              ],
                                            ),
                                          )
                                        : Container(
                                            width: double.infinity,
                                            color: Colors.grey.withOpacity(0.2),
                                            child: const Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('results are shown by 6:00pm daily'),
                                                Text('happy cracking',
                                                    style: TextStyle(
                                                        color: Colors.grey, fontSize: 12)),
                                              ],
                                            ),
                                          ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              //uploading codes feedback section
              : isRecordingEntry
                  ? const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 8,
                              width: 8,
                              child: CircularProgressIndicator(
                                color: Colors.red,
                                strokeWidth: 2,
                              )),
                          SizedBox(
                            width: 4,
                          ),
                          Text('uploading codes please wait'),
                        ],
                      ),
                    )
                  //selecting vault codes section
                  : Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                //Amount Section
                                SizedBox(
                                  child: TextField(
                                    controller: amountController,
                                    onChanged: (value) {
                                      amount = int.tryParse(amountController.text)!;
                                      if (amount < 10) {
                                        setState(() {
                                          hasInputAmount = false;
                                          possibleEarnings = 0;
                                        });
                                      } else {
                                        setState(() {
                                          hasInputAmount = true;
                                          calculatePossibleEarnings(amount);
                                        });
                                      }
                                    },
                                    maxLength: 6,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              const BorderSide(color: Colors.red, width: 1.0),
                                          borderRadius: BorderRadius.circular(20)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.deepPurple, width: 1.0),
                                          borderRadius: BorderRadius.circular(20)),
                                      hintText: 'Enter Amount',
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                //possible earning
                                Container(
                                  height: 60,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.deepPurple),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "lib/icons/naira.png",
                                            color: Colors.red,
                                            scale: 20,
                                          ),
                                          Text(
                                            possibleEarnings.toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 30,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                      const Text(
                                        "Possible Earnings",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12,
                                            color: Colors.deepPurple),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                //number selection & preview
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      color: Colors.grey.withOpacity(0.2),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.deepPurple,
                                                borderRadius: BorderRadius.circular(0),
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        "assets/patterns/dotPattern.png"),
                                                    fit: BoxFit.cover),
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  const Text(
                                                    "crack codes",
                                                    style: TextStyle(color: Colors.red),
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  Row(
                                                    children: [
                                                      //numbers
                                                      Expanded(
                                                          flex: 4,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            children: [
                                                              //number cards
                                                              //number 1
                                                              Container(
                                                                height: 50,
                                                                width: 35,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: isScrolling1
                                                                            ? Colors.red
                                                                            : Colors.white),
                                                                    borderRadius:
                                                                        BorderRadius.circular(10)),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      number1.toString(),
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                          fontSize: 16,
                                                                          color: Colors.white),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              //number2
                                                              Container(
                                                                height: 50,
                                                                width: 35,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: isScrolling2
                                                                            ? Colors.red
                                                                            : Colors.white),
                                                                    borderRadius:
                                                                        BorderRadius.circular(10)),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      number2.toString(),
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                          fontSize: 16,
                                                                          color: Colors.white),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              //number3
                                                              Container(
                                                                height: 50,
                                                                width: 35,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: isScrolling3
                                                                            ? Colors.red
                                                                            : Colors.white),
                                                                    borderRadius:
                                                                        BorderRadius.circular(10)),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      number3.toString(),
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                          fontSize: 16,
                                                                          color: Colors.white),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              //number4
                                                              Container(
                                                                height: 50,
                                                                width: 35,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: isScrolling4
                                                                            ? Colors.red
                                                                            : Colors.white),
                                                                    borderRadius:
                                                                        BorderRadius.circular(10)),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      number4.toString(),
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                          fontSize: 16,
                                                                          color: Colors.white),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              //number5
                                                              Container(
                                                                height: 50,
                                                                width: 35,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: isScrolling5
                                                                            ? Colors.red
                                                                            : Colors.white),
                                                                    borderRadius:
                                                                        BorderRadius.circular(10)),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      number5.toString(),
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                          fontSize: 16,
                                                                          color: Colors.white),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              //number6
                                                              Container(
                                                                height: 50,
                                                                width: 35,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: isScrolling6
                                                                            ? Colors.red
                                                                            : Colors.white),
                                                                    borderRadius:
                                                                        BorderRadius.circular(10)),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      number6.toString(),
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                          fontSize: 16,
                                                                          color: Colors.white),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              //number7
                                                              Container(
                                                                height: 50,
                                                                width: 35,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: isScrolling7
                                                                            ? Colors.red
                                                                            : Colors.white),
                                                                    borderRadius:
                                                                        BorderRadius.circular(10)),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      number7.toString(),
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                          fontSize: 16,
                                                                          color: Colors.white),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ))
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Image.asset(
                                                        "lib/icons/naira.png",
                                                        color: Colors.white,
                                                        scale: 30,
                                                      ),
                                                      Text(
                                                        animation!.value.toString(),
                                                        style: const TextStyle(
                                                            color: Colors.white, fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                  const Text(
                                                    "amount in vault",
                                                    style: TextStyle(
                                                        color: Colors.white, fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          //number picker section
                                          Expanded(
                                            flex: 6,
                                            child: Stack(
                                                alignment: AlignmentDirectional.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(horizontal: 16),
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 35,
                                                      color: Colors.grey.withOpacity(0.2),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      //scroll wheel1
                                                      SizedBox(
                                                        width: 30,
                                                        child: ListWheelScrollView.useDelegate(
                                                          onSelectedItemChanged: (value) async {
                                                            setState(() {
                                                              if (value <= 98) {
                                                                number1 = value + 1;
                                                                isScrolling1 = true;
                                                              } else {
                                                                number1 = 99;
                                                              }
                                                              Future.delayed(
                                                                  const Duration(seconds: 1), () {
                                                                isScrolling1 = false;
                                                                setState(() {});
                                                              });
                                                            });
                                                          },
                                                          squeeze: 5,
                                                          itemExtent: 100,
                                                          perspective: 0.009,
                                                          diameterRatio: 1,
                                                          physics: const FixedExtentScrollPhysics(),
                                                          childDelegate:
                                                              ListWheelChildBuilderDelegate(
                                                                  childCount: 100,
                                                                  builder: (context, index) {
                                                                    return Text(
                                                                      index.toString(),
                                                                      style: TextStyle(
                                                                          fontWeight: number1 ==
                                                                                  index
                                                                              ? FontWeight.bold
                                                                              : FontWeight.normal,
                                                                          fontSize: 20,
                                                                          color: number1 == index
                                                                              ? Colors.red
                                                                              : Colors.grey),
                                                                    );
                                                                  }),
                                                        ),
                                                      ),
                                                      const VerticalDivider(
                                                        indent: 150,
                                                        endIndent: 150,
                                                        thickness: 2,
                                                      ),
                                                      //scroll wheel2
                                                      SizedBox(
                                                        width: 30,
                                                        child: ListWheelScrollView.useDelegate(
                                                          onSelectedItemChanged: (value) {
                                                            setState(() {
                                                              if (value <= 98) {
                                                                number2 = value + 1;
                                                                isScrolling2 = true;
                                                              } else {
                                                                number2 = 99;
                                                              }
                                                              Future.delayed(
                                                                  const Duration(seconds: 1), () {
                                                                isScrolling2 = false;
                                                                setState(() {});
                                                              });
                                                            });
                                                          },
                                                          squeeze: 5,
                                                          itemExtent: 100,
                                                          perspective: 0.009,
                                                          diameterRatio: 1,
                                                          physics: const FixedExtentScrollPhysics(),
                                                          childDelegate:
                                                              ListWheelChildBuilderDelegate(
                                                                  childCount: 100,
                                                                  builder: (context, index) {
                                                                    return Text(
                                                                      index.toString(),
                                                                      style: TextStyle(
                                                                          fontWeight: number2 ==
                                                                                  index
                                                                              ? FontWeight.bold
                                                                              : FontWeight.normal,
                                                                          fontSize: 20,
                                                                          color: number2 == index
                                                                              ? Colors.red
                                                                              : Colors.grey),
                                                                    );
                                                                  }),
                                                        ),
                                                      ),
                                                      const VerticalDivider(
                                                        indent: 150,
                                                        endIndent: 150,
                                                        thickness: 2,
                                                      ),
                                                      //scroll wheel3
                                                      SizedBox(
                                                        width: 30,
                                                        child: ListWheelScrollView.useDelegate(
                                                          onSelectedItemChanged: (value) {
                                                            setState(() {
                                                              if (value <= 98) {
                                                                number3 = value + 1;
                                                                isScrolling3 = true;
                                                              } else {
                                                                number3 = 99;
                                                              }
                                                              Future.delayed(
                                                                  const Duration(seconds: 1), () {
                                                                isScrolling3 = false;
                                                                setState(() {});
                                                              });
                                                            });
                                                          },
                                                          squeeze: 5,
                                                          itemExtent: 100,
                                                          perspective: 0.009,
                                                          diameterRatio: 1,
                                                          physics: const FixedExtentScrollPhysics(),
                                                          childDelegate:
                                                              ListWheelChildBuilderDelegate(
                                                                  childCount: 100,
                                                                  builder: (context, index) {
                                                                    return Text(
                                                                      index.toString(),
                                                                      style: TextStyle(
                                                                          fontWeight: number3 ==
                                                                                  index
                                                                              ? FontWeight.bold
                                                                              : FontWeight.normal,
                                                                          fontSize: 20,
                                                                          color: number3 == index
                                                                              ? Colors.red
                                                                              : Colors.grey),
                                                                    );
                                                                  }),
                                                        ),
                                                      ),
                                                      const VerticalDivider(
                                                        indent: 150,
                                                        endIndent: 150,
                                                        thickness: 2,
                                                      ),
                                                      //scroll wheel4
                                                      SizedBox(
                                                        width: 30,
                                                        child: ListWheelScrollView.useDelegate(
                                                          onSelectedItemChanged: (value) {
                                                            setState(() {
                                                              if (value <= 98) {
                                                                number4 = value + 1;
                                                                isScrolling4 = true;
                                                              } else {
                                                                number4 = 99;
                                                              }
                                                              Future.delayed(
                                                                  const Duration(seconds: 1), () {
                                                                isScrolling4 = false;
                                                                setState(() {});
                                                              });
                                                            });
                                                          },
                                                          squeeze: 5,
                                                          itemExtent: 100,
                                                          perspective: 0.009,
                                                          diameterRatio: 1,
                                                          physics: const FixedExtentScrollPhysics(),
                                                          childDelegate:
                                                              ListWheelChildBuilderDelegate(
                                                                  childCount: 100,
                                                                  builder: (context, index) {
                                                                    return Text(
                                                                      index.toString(),
                                                                      style: TextStyle(
                                                                          fontWeight: number4 ==
                                                                                  index
                                                                              ? FontWeight.bold
                                                                              : FontWeight.normal,
                                                                          fontSize: 20,
                                                                          color: number4 == index
                                                                              ? Colors.red
                                                                              : Colors.grey),
                                                                    );
                                                                  }),
                                                        ),
                                                      ),
                                                      const VerticalDivider(
                                                        indent: 150,
                                                        endIndent: 150,
                                                        thickness: 2,
                                                      ),
                                                      //scroll wheel5
                                                      SizedBox(
                                                        width: 30,
                                                        child: ListWheelScrollView.useDelegate(
                                                          onSelectedItemChanged: (value) {
                                                            setState(() {
                                                              if (value <= 98) {
                                                                number5 = value + 1;
                                                                isScrolling5 = true;
                                                              } else {
                                                                number5 = 99;
                                                              }
                                                              Future.delayed(
                                                                  const Duration(seconds: 1), () {
                                                                isScrolling5 = false;
                                                                setState(() {});
                                                              });
                                                            });
                                                          },
                                                          squeeze: 5,
                                                          itemExtent: 100,
                                                          perspective: 0.009,
                                                          diameterRatio: 1,
                                                          physics: const FixedExtentScrollPhysics(),
                                                          childDelegate:
                                                              ListWheelChildBuilderDelegate(
                                                                  childCount: 100,
                                                                  builder: (context, index) {
                                                                    return Text(
                                                                      index.toString(),
                                                                      style: TextStyle(
                                                                          fontWeight: number5 ==
                                                                                  index
                                                                              ? FontWeight.bold
                                                                              : FontWeight.normal,
                                                                          fontSize: 20,
                                                                          color: number5 == index
                                                                              ? Colors.red
                                                                              : Colors.grey),
                                                                    );
                                                                  }),
                                                        ),
                                                      ),
                                                      const VerticalDivider(
                                                        indent: 150,
                                                        endIndent: 150,
                                                        thickness: 2,
                                                      ),
                                                      //scroll wheel6
                                                      SizedBox(
                                                        width: 30,
                                                        child: ListWheelScrollView.useDelegate(
                                                          onSelectedItemChanged: (value) {
                                                            setState(() {
                                                              if (value <= 98) {
                                                                number6 = value + 1;
                                                                isScrolling6 = true;
                                                              } else {
                                                                number6 = 99;
                                                              }
                                                              Future.delayed(
                                                                  const Duration(seconds: 1), () {
                                                                isScrolling6 = false;
                                                                setState(() {});
                                                              });
                                                            });
                                                          },
                                                          squeeze: 5,
                                                          itemExtent: 100,
                                                          perspective: 0.009,
                                                          diameterRatio: 1,
                                                          physics: const FixedExtentScrollPhysics(),
                                                          childDelegate:
                                                              ListWheelChildBuilderDelegate(
                                                                  childCount: 100,
                                                                  builder: (context, index) {
                                                                    return Text(
                                                                      index.toString(),
                                                                      style: TextStyle(
                                                                          fontWeight: number6 ==
                                                                                  index
                                                                              ? FontWeight.bold
                                                                              : FontWeight.normal,
                                                                          fontSize: 20,
                                                                          color: number6 == index
                                                                              ? Colors.red
                                                                              : Colors.grey),
                                                                    );
                                                                  }),
                                                        ),
                                                      ),
                                                      const VerticalDivider(
                                                        indent: 150,
                                                        endIndent: 150,
                                                        thickness: 2,
                                                      ),
                                                      //scroll wheel7
                                                      SizedBox(
                                                        width: 30,
                                                        child: ListWheelScrollView.useDelegate(
                                                          onSelectedItemChanged: (value) {
                                                            setState(() {
                                                              if (value <= 98) {
                                                                number7 = value + 1;
                                                                isScrolling7 = true;
                                                              } else {
                                                                number7 = 99;
                                                              }
                                                              Future.delayed(
                                                                  const Duration(seconds: 1), () {
                                                                isScrolling7 = false;
                                                                setState(() {});
                                                              });
                                                            });
                                                          },
                                                          squeeze: 5,
                                                          itemExtent: 100,
                                                          perspective: 0.009,
                                                          diameterRatio: 1,
                                                          physics: const FixedExtentScrollPhysics(),
                                                          childDelegate:
                                                              ListWheelChildBuilderDelegate(
                                                                  childCount: 100,
                                                                  builder: (context, index) {
                                                                    return Text(
                                                                      index.toString(),
                                                                      style: TextStyle(
                                                                          fontWeight: number7 ==
                                                                                  index
                                                                              ? FontWeight.bold
                                                                              : FontWeight.normal,
                                                                          fontSize: 20,
                                                                          color: number7 == index
                                                                              ? Colors.red
                                                                              : Colors.grey),
                                                                    );
                                                                  }),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //crack vault button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed:
                                      !hasInputAmount ? null : chargeWalletAndRecordVaultEntry,
                                  style: ButtonStyle(
                                      backgroundColor: !hasInputAmount
                                          ? const MaterialStatePropertyAll(Colors.grey)
                                          : const MaterialStatePropertyAll(Colors.red),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18.0),
                                        ),
                                      )),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Text("Crack Vault"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
    );
  }
}
