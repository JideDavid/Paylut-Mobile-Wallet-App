import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paylut/Screens/vault_winners.dart';
import 'package:paylut/models/user_model.dart';

class SilverVaultEntry extends StatefulWidget {
  final UserDetails userDetails;
  const SilverVaultEntry({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<SilverVaultEntry> createState() => _SilverVaultEntryState(userDetails: userDetails);
}

class _SilverVaultEntryState extends State<SilverVaultEntry> {
  UserDetails userDetails;
  _SilverVaultEntryState({required this.userDetails});

  var f = NumberFormat("##,###,###", "en_US");

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
  bool hasInputAmount = false;
  int amount = 0;
  int possibleEarnings = 0;
  int initialBalance = 0;
  int newBalance = 0;
  String transactionRef = '';
  String entryValue = '';
  int initialEntryCount = 0;
  DateTime now = DateTime.now();
  int vaultAmount = 1000000;
  int multiplier = 1;
  bool makingEntry = false;
  bool canPlay = true;
  bool pressed = false;
  bool pressedButton = false;

  TextEditingController amountController = TextEditingController();
  Animation? animation;
  AnimationController? animationControllerBronze;

  //function to calculate possible earnings
  void calculatePossibleEarnings(int amount) {
    if (mounted) {
      setState(() {
        Random random = Random();
        int randomNumber = random.nextInt(10) + 7; // from 10 up to 100 included
        possibleEarnings = randomNumber * amount * 5;
      });
    }
  }

  //function to set lot multiplier
  void setMultiplier(int amount) async{
    if(amount < 200){
      multiplier = 1;
    }else if(amount >= 200 && amount < 500){
      multiplier = 2;
    }else if(amount >= 500 && amount < 1000){
      multiplier = 3;
    }else if(amount >= 1000 && amount < 2000){
      multiplier = 4;
    }else if(amount >= 2000 && amount < 3000){
      multiplier = 5;
    }else if(amount >= 3000 && amount < 4000){
      multiplier = 6;
    }else if(amount >= 5000 && amount < 6000){
      multiplier = 7;
    }else if(amount >= 7000 && amount < 8000){
      multiplier = 8;
    }else if(amount >= 8000 && amount < 9000){
      multiplier = 9;
    }else if(amount >= 9000 && amount < 1000){
      multiplier = 10;
    }else{
      multiplier = 15;
    }
  }

  //function to record vault entries
  Future<void> recordVaultEntries() async {
    //recording vault break entries
    await FirebaseFirestore.instance
        .collection('vaults')
        .doc('silver')
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
      'date': now,
      'amount': amount,
      'uid': userDetails.uid,
      'amountClaimed': 0,
      'dateClaimed': DateTime.now(),
      'claimed': false,
      'completeEntry': false,
      'multiplier' : multiplier
    });
    if (kDebugMode) {
      print('recoded vault entries');
    }

    //add entries to entry count
    for (int i = 0; i < 5; i++) {
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
      }

      //get entry count value
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('vaults')
          .doc('silver')
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
      }
      //creating database templates
      else {
        if (kDebugMode) {
          print('no vault entries yet');
        }

        initialEntryCount = 0;

        //create a default document on entry count path with default entry count values of zero
        await FirebaseFirestore.instance
            .collection('vaults')
            .doc('silver')
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
          '99': 0,
        });
        if (kDebugMode) {
          print('created default document for vault entry count');
        }

        //creating result document template in vault break codes path
        await FirebaseFirestore.instance
            .collection('vaults')
            .doc('silver')
            .collection('dailyEntries')
            .doc(DateFormat('yyyy-MM-dd').format(now))
            .set({
          'result1': 1,
          'result2': 2,
          'result3': 3,
          'result4': 4,
          'result5': 5,
          'hasResult': false,
          'vaultAmount': 1000000,
          'distributionAmount': 0,
        });
        if (kDebugMode) {
          print('created default document for vault break codes results');
        }
      }

      //increment entry count value
      await FirebaseFirestore.instance
          .collection('vaults')
          .doc('silver')
          .collection('dailyEntries')
          .doc(DateFormat('yyyy-MM-dd').format(now))
          .collection('entries')
          .doc('entryCount')
          .update({entryValue: initialEntryCount + multiplier});
      if (kDebugMode) {
        print('incremented vault entry count');
      }
    }


    //add user input amount to update amount in vault
    DocumentSnapshot resultSnapshot = await FirebaseFirestore.instance
        .collection('vaults')
        .doc('silver')
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .get();
    int vAmount = resultSnapshot.get('vaultAmount');

    await FirebaseFirestore.instance
        .collection('vaults')
        .doc('silver')
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .update({'vaultAmount': vAmount + amount});

    //marking entries as complete
    await FirebaseFirestore.instance
        .collection('vaults')
        .doc('silver')
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(now))
        .collection('entries')
        .doc(userDetails.uid)
    .update({'completeEntry': true});
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
      'gameCategory': 'silver vault break',
      'date': now,
      'transactionRef': transactionRef,
      'initialBalance': initialBalance,
      'newBalance': newBalance
    });
    if (kDebugMode) {
      print('recoded vault transaction in history');
    }
  }

  //function to charge wallet and record transaction and entries in history
  Future<void> chargeWalletAndRecordVaultEntry() async {
    //disabling entry button
    setState(() {
      pressedButton = true;
    });

    //checking if player is allowed to play
    bool playable = await getCanPlay();
    if(!playable) {
      return;
    }

    DocumentSnapshot userData =
        await FirebaseFirestore.instance.collection('users').doc(userDetails.uid).get();
    int walletBalance = userData.get('walletBalance');

    //checking wallet balance before charging wallet
    if (walletBalance >= amount) {

      //charging wallet
      await chargeWallet(amount);
      //recording vault entries
      await recordVaultEntries();

    } else {
      int difference = amount - walletBalance;
      setState(() {
        pressedButton = false;
      });
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              //backgroundColor: Colors.redAccent,
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
                          'Insufficient balance, you need NGN${f.format(difference)} to complete transaction',
                          style: const TextStyle(),
                          textAlign: TextAlign.center,
                        )
                      ])),
            );
          });
    }
  }

  //getting vault amount
  Future<void> getVaultAmount() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('vaults')
        .doc('silver')
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .get();

    if(snapshot.exists){
      vaultAmount = snapshot.get('vaultAmount');
      if (mounted) {
        setState(() {});
      }
    }else{
      if(kDebugMode){
        print('vault amount for silver ${DateFormat('yyyy-MM-dd').format(DateTime.now())} do not exist');
      }
    }


  }

  //checking if result is out already and setting if user can play
  Future<bool> getCanPlay() async{
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('vaults')
        .doc('silver')
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .get();

    if(snapshot.exists){
      bool hasResult = snapshot.get('hasResult');
      if(hasResult){
        canPlay = false;
        if(mounted){
          setState(() {});
        }
        return canPlay;
      }else{
        canPlay = true;
        if(mounted){
          setState(() {});
        }
        return canPlay;
      }
    }else{
      canPlay = true;
      if(mounted){
        setState(() {});
      }
      return canPlay;
    }
  }

  @override
  void initState() {
    super.initState();
    getVaultAmount();
    getCanPlay();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
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
                      if (amount < 50) {
                        setState(() {
                          hasInputAmount = false;
                          possibleEarnings = 0;
                        });
                      } else {
                        setState(() {
                          hasInputAmount = true;
                          setMultiplier(amount);
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
                          borderSide: const BorderSide(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.deepPurple, width: 1.0),
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
                  child: Row(
                    children: [
                      Expanded(
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
                      const VerticalDivider(
                        color: Colors.deepPurple,
                        thickness: 1,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "x$multiplier",
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 30, color: Colors.red),
                            ),
                            const Text(
                              "multiplier",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: Colors.deepPurple),
                            )
                          ],
                        ),
                      ),
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
                      color: Colors.red.withOpacity(0.1),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.deepPurple[700],
                                borderRadius: BorderRadius.circular(0),
                                image: const DecorationImage(
                                    image: AssetImage("assets/patterns/dotPattern.png"),
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
                                            mainAxisAlignment: MainAxisAlignment.center,
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
                                                            : Colors.white,
                                                        width: isScrolling1 ? 3 : 1),
                                                    borderRadius: BorderRadius.circular(10)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      number1.toString(),
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.normal,
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
                                                            : Colors.white,
                                                        width: isScrolling2 ? 3 : 1),
                                                    borderRadius: BorderRadius.circular(10)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      number2.toString(),
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.normal,
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
                                                            : Colors.white,
                                                        width: isScrolling3 ? 3 : 1),
                                                    borderRadius: BorderRadius.circular(10)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      number3.toString(),
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.normal,
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
                                                            : Colors.white,
                                                        width: isScrolling4 ? 3 : 1),
                                                    borderRadius: BorderRadius.circular(10)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      number4.toString(),
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.normal,
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
                                                            : Colors.white,
                                                        width: isScrolling5 ? 3 : 1),
                                                    borderRadius: BorderRadius.circular(10)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      number5.toString(),
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.normal,
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
                                        vaultAmount.toString(),
                                        style: const TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    "amount in vault",
                                    style: TextStyle(color: Colors.white, fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //number picker section
                          Expanded(
                            flex: 6,
                            child: Stack(alignment: AlignmentDirectional.center, children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                          Future.delayed(const Duration(seconds: 1), () {
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
                                      childDelegate: ListWheelChildBuilderDelegate(
                                          childCount: 100,
                                          builder: (context, index) {
                                            return Text(
                                              index.toString(),
                                              style: TextStyle(
                                                  fontWeight: number1 == index
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  fontSize: 20,
                                                  color:
                                                      number1 == index ? Colors.red : Colors.grey),
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
                                          Future.delayed(const Duration(seconds: 1), () {
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
                                      childDelegate: ListWheelChildBuilderDelegate(
                                          childCount: 100,
                                          builder: (context, index) {
                                            return Text(
                                              index.toString(),
                                              style: TextStyle(
                                                  fontWeight: number2 == index
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  fontSize: 20,
                                                  color:
                                                      number2 == index ? Colors.red : Colors.grey),
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
                                          Future.delayed(const Duration(seconds: 1), () {
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
                                      childDelegate: ListWheelChildBuilderDelegate(
                                          childCount: 100,
                                          builder: (context, index) {
                                            return Text(
                                              index.toString(),
                                              style: TextStyle(
                                                  fontWeight: number3 == index
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  fontSize: 20,
                                                  color:
                                                      number3 == index ? Colors.red : Colors.grey),
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
                                          Future.delayed(const Duration(seconds: 1), () {
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
                                      childDelegate: ListWheelChildBuilderDelegate(
                                          childCount: 100,
                                          builder: (context, index) {
                                            return Text(
                                              index.toString(),
                                              style: TextStyle(
                                                  fontWeight: number4 == index
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  fontSize: 20,
                                                  color:
                                                      number4 == index ? Colors.red : Colors.grey),
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
                                          Future.delayed(const Duration(seconds: 1), () {
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
                                      childDelegate: ListWheelChildBuilderDelegate(
                                          childCount: 100,
                                          builder: (context, index) {
                                            return Text(
                                              index.toString(),
                                              style: TextStyle(
                                                  fontWeight: number5 == index
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  fontSize: 20,
                                                  color:
                                                      number5 == index ? Colors.red : Colors.grey),
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
                  onPressed: !hasInputAmount || pressedButton ? null : chargeWalletAndRecordVaultEntry,
                  style: ButtonStyle(
                      backgroundColor: !hasInputAmount || pressedButton
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
        ),
        Visibility(
          visible: canPlay ? false : true,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7)
            ),
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Oops! Results are out already,',
                    textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                      color: Colors.white
                      ),
                    ),
                    const Text('Check back tomorrow to make entries',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12,
                          color: Colors.white
                      ),
                    ),
                    const SizedBox(height: 20,),
                    GestureDetector(
                      onTapDown: (tapDetails){
                        setState(() {
                          pressed = true;
                        });
                      },
                      onTapUp: (tapDetails){
                        setState(() {
                          pressed = false;
                        });
                      },
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context){
                              return VaultWinners(date: DateTime.now());
                            }));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: pressed ? Colors.red.withOpacity(0.2) : null,
                          border: Border.all(
                            color: Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          child: Text(
                            'View Results',
                            style: TextStyle(fontWeight: FontWeight.bold,
                            color: Colors.red
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        )
      ]
    );
  }
}
