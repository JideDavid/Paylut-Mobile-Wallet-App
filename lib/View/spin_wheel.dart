import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paylut/models/user_model.dart';

class SpinWheel1 extends StatefulWidget {
  final UserDetails userDetails;
  const SpinWheel1({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<SpinWheel1> createState() => _SpinWheel1State(userDetails: userDetails);
}

class _SpinWheel1State extends State<SpinWheel1> {
  UserDetails userDetails;
  _SpinWheel1State({required this.userDetails});

  var f = NumberFormat("##,###,##0.00", "en_US");
  double turns = 0;
  int duration = 0;
  double step = 0.0625;
  int amount = 0;
  int winAmount = 0;
  int odd = 0;
  int walletBalance = 0;
  bool spinning = false;
  List<int> positions = [
    1,
    2,
    8,
    3,
    4,
    5,
    6,
    4,
    7,
    2,
    8,
    9,
    16,
    5,
    10,
    11,
    6,
    3,
    12,
    13,
    14,
    13,
    15,
    1,
    16,
    10,
  ];

  TextStyle heading = const TextStyle(
    fontWeight: FontWeight.bold,
  );
  TextStyle subHeading = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
  );
  TextEditingController amountController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController aliasController = TextEditingController();

  T getRandomElement<T>(List<T> list) {
    final random = Random();
    var i = random.nextInt(list.length);
    return list[i];
  }

  bool checkWin(randPos) {
    if (randPos == 3 ||
        randPos == 5 ||
        randPos == 7 ||
        randPos == 9 ||
        randPos == 11 ||
        randPos == 12 ||
        randPos == 14 ||
        randPos == 15) {
      switch (randPos) {
        case 3:
          odd = 25;
        case 5:
          odd = 20;
        case 7:
          odd = 15;
        case 9:
          odd = 10;
        case 11:
          odd = 4;
        case 12:
          odd = 3;
        case 14:
          odd = 2;
        case 15:
          odd = 1;
      }
      winAmount = amount * odd;
      return true;
    } else {
      return false;
    }
  }

  Future<int> getWalletBalance() async {
    //getting wallet balance
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userDetails.uid).get();
    if(snapshot.exists){
      walletBalance = snapshot.get('walletBalance');
      if(mounted){
        setState(() {});
      }
    }else {
      if(kDebugMode){
        print('snapshot ${userDetails.uid} does not exist');
      }
    }
    return walletBalance;
  }

  creditBalance(int winAmount) async{
    //getting initial wallet balance
    int initialBalance = await getWalletBalance();
    //adding win amount
    int newBalance =  initialBalance + winAmount;
    //updating new balance
    await FirebaseFirestore.instance.collection('users').doc(userDetails.uid).update(
        {'walletBalance': newBalance});
    getWalletBalance();
  }

  debitBalance(int amount) async{
    //getting initial wallet balance
    int initialBalance = await getWalletBalance();
    //adding win amount
    int newBalance =  initialBalance - amount;
    //updating new balance
    await FirebaseFirestore.instance.collection('users').doc(userDetails.uid).update(
        {'walletBalance': newBalance});
    getWalletBalance();
  }

  @override
  void initState() {
    super.initState();
    getWalletBalance();
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Spin Wheel",
              style: heading,
            ),
            Text(
              "Spin and win huge prizes without limits",
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                Center(
                    child: AnimatedRotation(
                        curve: Curves.easeOutCirc,
                        turns: turns,
                        duration: Duration(seconds: duration),
                        child: Image.asset(
                          'assets/backgrounds/spinWheelNumbers.png',
                          scale: 1,
                        ))),
                Positioned(
                  top: -20,
                  child: Center(
                      child: Image.asset(
                    'assets/backgrounds/wheelPointer.png',
                    scale: 2,
                  )),
                ),
              ]),
              const SizedBox(
                height: 16,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: sw * 0.4,
                  width: sw,
                  child: Column(
                    children: [
                      Text('Wallet Balance: ${f.format(walletBalance)} NGN'),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: sw * 0.7,
                        child: TextField(
                          onChanged: (value) {
                            if (value.isEmpty) {
                              amount = 0;
                              if (mounted) {
                                setState(() {});
                              }
                              return;
                            }
                            amount = int.tryParse(value)!;
                            if (mounted) {
                              setState(() {});
                            }
                          },
                          controller: amountController,
                          maxLength: 5,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            filled: true,
                            counterText: "",
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red, width: 1.0),
                                borderRadius: BorderRadius.circular(20)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                borderRadius: BorderRadius.circular(20)),
                            hintText: 'Stake Amount',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: sw * 0.7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //50
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GestureDetector(
                                onTap: () {
                                  amount = 50;
                                  amountController.text = amount.toString();
                                  setState(() {});
                                },
                                child: Container(
                                  color: Colors.grey.withOpacity(0.2),
                                  height: sw * 0.1,
                                  width: sw * 0.1,
                                  child: const Center(child: Text('50')),
                                ),
                              ),
                            ),
                            //100
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GestureDetector(
                                onTap: () {
                                  amount = 100;
                                  amountController.text = amount.toString();
                                  setState(() {});
                                },
                                child: Container(
                                  color: Colors.grey.withOpacity(0.2),
                                  height: sw * 0.1,
                                  width: sw * 0.1,
                                  child: const Center(child: Text('100')),
                                ),
                              ),
                            ),
                            //200
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GestureDetector(
                                onTap: () {
                                  amount = 200;
                                  amountController.text = amount.toString();
                                  setState(() {});
                                },
                                child: Container(
                                  color: Colors.grey.withOpacity(0.2),
                                  height: sw * 0.1,
                                  width: sw * 0.1,
                                  child: const Center(child: Text('200')),
                                ),
                              ),
                            ),
                            //500
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GestureDetector(
                                onTap: () {
                                  amount = 500;
                                  amountController.text = amount.toString();
                                  setState(() {});
                                },
                                child: Container(
                                  color: Colors.grey.withOpacity(0.2),
                                  height: sw * 0.1,
                                  width: sw * 0.1,
                                  child: const Center(child: Text('500')),
                                ),
                              ),
                            ),
                            //1000
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GestureDetector(
                                onTap: () {
                                  amount = 1000;
                                  amountController.text = amount.toString();
                                  setState(() {});
                                },
                                child: Container(
                                  color: Colors.grey.withOpacity(0.2),
                                  height: sw * 0.1,
                                  width: sw * 0.1,
                                  child: const Center(child: Text('1000')),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: amount == 0 || spinning
                      ? null
                      : () async {
                          spinning = true;
                          if (mounted) {
                            setState(() {});
                          }
                          turns = 0;
                          duration = 0;
                          setState(() {});
                          await Future.delayed(const Duration(milliseconds: 10));

                          var randPos = getRandomElement(positions);
                          if(kDebugMode){
                            print(randPos);
                          }
                          turns = 30 + (step * randPos);
                          duration = 10;
                          setState(() {});
                          await Future.delayed(const Duration(seconds: 10), () {
                            bool win = checkWin(randPos);
                            if (win) {
                              if(kDebugMode){
                                print('win');
                              }
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'You Won',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            f.format(winAmount),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 40),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            'amount ($amount) x odd ($odd)',
                                            style: const TextStyle(
                                                fontStyle: FontStyle.italic, fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                              creditBalance(winAmount);
                            } else {
                              if(kDebugMode){
                                print('lose');
                              }
                              debitBalance(amount);
                            }
                          });
                          spinning = false;
                          if (mounted) {
                            setState(() {});
                          }
                        },
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          amount == 0 || spinning ? Colors.grey : Colors.red)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Spin',
                      style:
                          TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
