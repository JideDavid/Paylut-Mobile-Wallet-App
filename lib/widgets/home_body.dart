import 'dart:async';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paylut/Screens/airtime.dart';
import 'package:paylut/Screens/bronze_winners.dart';
import 'package:paylut/Screens/cable_tv.dart';
import 'package:paylut/Screens/data.dart';
import 'package:paylut/Screens/fund_wallet.dart';
import 'package:paylut/Screens/gift_card.dart';
import 'package:paylut/Screens/wallet_history.dart';
import 'package:paylut/models/user_model.dart';
import 'package:paylut/services/pref_helper.dart';
import 'package:paylut/widgets/lottery_card.dart';
import 'package:paylut/widgets/service_card.dart';
import '../Screens/transfer.dart';
import '../Screens/withdraw.dart';

class HomeBody extends StatefulWidget {
  final UserDetails userDetails;
  const HomeBody({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<HomeBody> createState() => _HomeBodyState(userDetails: userDetails);
}

class _HomeBodyState extends State<HomeBody> {
  final UserDetails userDetails;
  _HomeBodyState({required this.userDetails});

  var f = NumberFormat("##,###,###", "en_US");

  bool showBalance = false;
  bool gotVisibility = false;
  List<int> bronzeCodes = [0, 0, 0, 0, 0, 0, 0];
  List<int> silverCodes = [0, 0, 0, 0, 0];
  List<int> goldenCodes = [0, 0, 0];
  int vaultPreviewIndex = 1;
  int bronzeVaultAmount = 1000000;
  int silverVaultAmount = 5000000;
  int goldenVaultAmount = 7000000;
  bool updatedBalance = false;
  int newBalance = 0;
  int walletAction = 1;
  bool todayResults = false;

  Future<void> switchVaultAmount() async {
    for (int i = 1; i < 1000; i++) {
      if (vaultPreviewIndex < 3) {
        vaultPreviewIndex++;
      } else {
        vaultPreviewIndex = 1;
      }
      await Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  Future<void> getPreferences() async {
    //getting balance visibility
    bool? value = await PrefHelper().getBalanceVisibility();
    showBalance = value!;
    gotVisibility = true;

    //getting last wallet action
    walletAction = (await PrefHelper().getLastWalletAction())!;
    setState(() {});
  }

  Future<void> updateBalance() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userDetails.uid).get();
    int balance = snapshot.get('walletBalance');
    newBalance = balance;
    updatedBalance = true;
    setState(() {});
  }

  Future<void> updateVaultResults() async {
    //formatting days
    DateTime now = DateTime.now();
    var todayNum = int.tryParse(DateFormat('dd').format(now));
    var todayHour = int.tryParse(DateFormat('kk').format(now));
    var today = DateFormat('yyyy-MM-dd').format(now);
    var yesterday = DateFormat('yyyy-MM-${todayNum! - 1}').format(now);

    if (todayHour! < 18) {
      todayResults = false;
    } else {
      todayResults = true;
    }

    //bronze section
    //fetching yesterday results
    if (todayHour < 18) {
      DocumentSnapshot bSnapshot = await FirebaseFirestore.instance
          .collection('vaults')
          .doc('bronze')
          .collection('dailyEntries')
          .doc(yesterday)
          .get();
      if (bSnapshot.exists) {
        if (bSnapshot["hasResult"]) {
          bronzeCodes[0] = bSnapshot.get('result1');
          bronzeCodes[1] = bSnapshot.get('result2');
          bronzeCodes[2] = bSnapshot.get('result3');
          bronzeCodes[3] = bSnapshot.get('result4');
          bronzeCodes[4] = bSnapshot.get('result5');
          bronzeCodes[5] = bSnapshot.get('result6');
          bronzeCodes[6] = bSnapshot.get('result7');
          if (kDebugMode) {
            print('got $yesterday bronze result');
          }
        } else {
          if (kDebugMode) {
            print('$yesterday bronze result is not out yet');
          }
        }
      } else {
        if (kDebugMode) {
          print('$yesterday bronze does not exist on database');
        }
      }
    }

    //fetching today result
    else {
      DocumentSnapshot bSnapshot = await FirebaseFirestore.instance
          .collection('vaults')
          .doc('bronze')
          .collection('dailyEntries')
          .doc(today)
          .get();
      if (bSnapshot.exists) {
        if (bSnapshot["hasResult"]) {
          bronzeCodes[0] = bSnapshot.get('result1');
          bronzeCodes[1] = bSnapshot.get('result2');
          bronzeCodes[2] = bSnapshot.get('result3');
          bronzeCodes[3] = bSnapshot.get('result4');
          bronzeCodes[4] = bSnapshot.get('result5');
          bronzeCodes[5] = bSnapshot.get('result6');
          bronzeCodes[6] = bSnapshot.get('result7');
          if (kDebugMode) {
            print('got $today bronze result');
          }
        } else {
          if (kDebugMode) {
            print('$today result is not out yet');
          }
        }
      } else {
        if (kDebugMode) {
          print('$today does not exist on database');
        }
      }
    }

    //silver section
    //fetching yesterday results
    if (todayHour < 18) {
      DocumentSnapshot bSnapshot = await FirebaseFirestore.instance
          .collection('vaults')
          .doc('silver')
          .collection('dailyEntries')
          .doc(yesterday)
          .get();
      if (bSnapshot.exists) {
        if (bSnapshot["hasResult"]) {
          silverCodes[0] = bSnapshot.get('result1');
          silverCodes[1] = bSnapshot.get('result2');
          silverCodes[2] = bSnapshot.get('result3');
          silverCodes[3] = bSnapshot.get('result4');
          silverCodes[4] = bSnapshot.get('result5');
          if (kDebugMode) {
            print('got $yesterday silver result');
          }
        } else {
          if (kDebugMode) {
            print('$yesterday silver result is not out yet');
          }
        }
      } else {
        if (kDebugMode) {
          print('$yesterday silver does not exist on database');
        }
      }
    }

    //fetching today result
    else {
      DocumentSnapshot bSnapshot = await FirebaseFirestore.instance
          .collection('vaults')
          .doc('silver')
          .collection('dailyEntries')
          .doc(today)
          .get();
      if (bSnapshot.exists) {
        if (bSnapshot["hasResult"]) {
          silverCodes[0] = bSnapshot.get('result1');
          silverCodes[1] = bSnapshot.get('result2');
          silverCodes[2] = bSnapshot.get('result3');
          silverCodes[3] = bSnapshot.get('result4');
          silverCodes[4] = bSnapshot.get('result5');
          if (kDebugMode) {
            print('got $today bronze result');
          }
        } else {
          if (kDebugMode) {
            print('$today silver result is not out yet');
          }
        }
      } else {
        if (kDebugMode) {
          print('$today silver does not exist on database');
        }
      }
    }

    //golden section
    //fetching yesterday results
    if (todayHour < 18) {
      DocumentSnapshot bSnapshot = await FirebaseFirestore.instance
          .collection('vaults')
          .doc('golden')
          .collection('dailyEntries')
          .doc(yesterday)
          .get();
      if (bSnapshot.exists) {
        if (bSnapshot["hasResult"]) {
          goldenCodes[0] = bSnapshot.get('result1');
          goldenCodes[1] = bSnapshot.get('result2');
          goldenCodes[2] = bSnapshot.get('result3');
          if (kDebugMode) {
            print('got $yesterday golden result');
          }
        } else {
          if (kDebugMode) {
            print('$yesterday golden result is not out yet');
          }
        }
      } else {
        if (kDebugMode) {
          print('$yesterday golden does not exist on database');
        }
      }
    }

    //fetching today result
    else {
      DocumentSnapshot bSnapshot = await FirebaseFirestore.instance
          .collection('vaults')
          .doc('golden')
          .collection('dailyEntries')
          .doc(today)
          .get();
      if (bSnapshot.exists) {
        if (bSnapshot["hasResult"]) {
          goldenCodes[0] = bSnapshot.get('result1');
          goldenCodes[1] = bSnapshot.get('result2');
          goldenCodes[2] = bSnapshot.get('result3');
          if (kDebugMode) {
            print('got $today golden result');
          }
        } else {
          if (kDebugMode) {
            print('$today golden result is not out yet');
          }
        }
      } else {
        if (kDebugMode) {
          print('$today golden does not exist on database');
        }
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPreferences();
    //switchVaultAmount();
    updateBalance();
    updateVaultResults();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Wallet section
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            height: 140,
            decoration: const BoxDecoration(
              color: Color(0xff861bf2),
              image: DecorationImage(
                  image: AssetImage(
                    "assets/banners/walletBg.png",
                  ),
                  fit: BoxFit.cover),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Wallet Balance",
                            style: TextStyle(color: Colors.white),
                          ),
                          IconButton(
                              onPressed: () {
                                //toggle balance visibility
                                setState(() {
                                  if (showBalance) {
                                    PrefHelper().setBalanceVisibility(false);
                                    getPreferences();
                                  } else {
                                    PrefHelper().setBalanceVisibility(true);
                                    getPreferences();
                                  }
                                });
                              },
                              icon: Icon(
                                showBalance ? Icons.visibility : Icons.visibility_off,
                                color: Colors.white,
                              )),
                        ],
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WalletFundHistory(
                                          userDetails: userDetails,
                                        )));
                          },
                          child: const Row(
                            children: [
                              Text(
                                "Transaction history",
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                              )
                            ],
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      gotVisibility
                          ? Row(
                              children: [
                                Image.asset(
                                  "lib/icons/naira.png",
                                  scale: 16,
                                  color: Colors.white,
                                ),

                                StreamBuilder<QuerySnapshot>(
                                    stream:
                                        FirebaseFirestore.instance.collection('users').snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Text('Loading..');
                                      }

                                      if (snapshot.hasData) {
                                        var col = snapshot.data!;
                                        for (var doc in col.docs) {
                                          if (doc.id == userDetails.uid) {
                                            return Text(
                                              showBalance
                                                  ? f.format(doc['walletBalance'])
                                                  : "*****",
                                              style: const TextStyle(
                                                  fontSize: 30, color: Colors.white),
                                            );
                                          }
                                        }
                                      }
                                      return Text(
                                        showBalance ? '00' : "*****",
                                        style: const TextStyle(fontSize: 30, color: Colors.white),
                                      );
                                    }),
                              ],
                            )
                          : const CircularProgressIndicator(),
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (walletAction < 3) {
                                    walletAction++;
                                    PrefHelper().setLastWalletAction(walletAction);
                                  } else {
                                    walletAction = 1;
                                    PrefHelper().setLastWalletAction(walletAction);
                                  }
                                });
                              },
                              child: const Icon(
                                Icons.swap_horizontal_circle,
                                color: Colors.white,
                                size: 40,
                              )),
                          const SizedBox(
                            width: 4,
                          ),
                          ElevatedButton(
                            onPressed: walletAction == 1
                                ? () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FundWallet(userDetails: userDetails)));
                                  }
                                : walletAction == 2
                                    ? () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Transfer(userDetails: userDetails)));
                                      }
                                    : () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Withdraw(userDetails: userDetails)));
                                      },
                            style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll(Colors.white),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                )),
                            child: Text(walletAction == 1
                                ? "Add Fund"
                                : walletAction == 2
                                    ? "Transfer"
                                    : "Withdraw", style: const TextStyle(color: Colors.red),),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onLongPress: () {
                            Timer(const Duration(seconds: 1), () {
                              FlutterClipboard.copy(userDetails.walletTag);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text(
                                  'Wallet tag copied to clipboard',
                                  style: TextStyle(color: Colors.white),
                                ),
                                duration: Duration(seconds: 1),
                                backgroundColor: Colors.red,
                              ));
                            });
                          },
                          child: Text("Tag: ${userDetails.walletTag}",
                              style: const TextStyle(color: Colors.white))),
                      GestureDetector(
                        onTap: () {
                          if (vaultPreviewIndex < 3) {
                            vaultPreviewIndex++;
                          } else {
                            vaultPreviewIndex = 1;
                          }
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Text(
                                vaultPreviewIndex == 1
                                    ? "bronze vault"
                                    : vaultPreviewIndex == 2
                                        ? "silver vault"
                                        : "golden vault",
                                style: const TextStyle(color: Colors.white, fontSize: 10)),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                                vaultPreviewIndex == 1
                                    ? bronzeVaultAmount.toString()
                                    : vaultPreviewIndex == 2
                                        ? silverVaultAmount.toString()
                                        : goldenVaultAmount.toString(),
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        //Diving space
        const SizedBox(
          height: 24,
        ),

        //Quick action section
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Quick Actions",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: SCard(
                        cardIcon: Icons.phone,
                        title: "Airtime",
                        route: Airtime(userDetails: userDetails),
                      )),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: SCard(
                        cardIcon: Icons.wifi,
                        title: "Data",
                        route: Data(userDetails: userDetails),
                      )),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: SCard(
                        cardIcon: Icons.live_tv_outlined,
                        title: "CableTV",
                        route: CableTv(userDetails: userDetails),
                      )),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: SCard(
                          cardIcon: Icons.diamond_outlined,
                          title: "Gift Card",
                          route: GiftCard(userDetails: userDetails),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        //Diving space
        const SizedBox(
          height: 24,
        ),

        //Lottery winning numbers Section
        Expanded(
          flex: 5,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Vault Codes",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(todayResults ? "(Today)" : "(Yesterday)",
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              //bronze card
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => const BronzeWinners()));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey.withOpacity(0.2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //number cards
                          LotteryCard(
                              number: bronzeCodes[0], cardColor: Colors.red.withOpacity(0.2)),
                          const SizedBox(
                            width: 8,
                          ),
                          LotteryCard(
                              number: bronzeCodes[1], cardColor: Colors.red.withOpacity(0.2)),
                          const SizedBox(
                            width: 8,
                          ),
                          LotteryCard(
                              number: bronzeCodes[2], cardColor: Colors.red.withOpacity(0.2)),
                          const SizedBox(
                            width: 8,
                          ),
                          LotteryCard(
                              number: bronzeCodes[3], cardColor: Colors.red.withOpacity(0.2)),
                          const SizedBox(
                            width: 8,
                          ),
                          LotteryCard(
                              number: bronzeCodes[4], cardColor: Colors.red.withOpacity(0.2)),
                          const SizedBox(
                            width: 8,
                          ),
                          LotteryCard(
                              number: bronzeCodes[5], cardColor: Colors.red.withOpacity(0.2)),
                          const SizedBox(
                            width: 8,
                          ),
                          LotteryCard(
                              number: bronzeCodes[6], cardColor: Colors.red.withOpacity(0.2)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              //ocean card
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //number cards
                        LotteryCard(
                            number: silverCodes[0], cardColor: Colors.yellow.withOpacity(0.3)),
                        const SizedBox(
                          width: 8,
                        ),
                        LotteryCard(
                            number: silverCodes[1], cardColor: Colors.yellow.withOpacity(0.3)),
                        const SizedBox(
                          width: 8,
                        ),
                        LotteryCard(
                            number: silverCodes[2], cardColor: Colors.yellow.withOpacity(0.3)),
                        const SizedBox(
                          width: 8,
                        ),
                        LotteryCard(
                            number: silverCodes[3], cardColor: Colors.yellow.withOpacity(0.3)),
                        const SizedBox(
                          width: 8,
                        ),
                        LotteryCard(
                            number: silverCodes[4], cardColor: Colors.yellow.withOpacity(0.3)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              //classic card
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //number cards
                        LotteryCard(
                            number: goldenCodes[0], cardColor: Colors.green.withOpacity(0.2)),
                        const SizedBox(
                          width: 8,
                        ),
                        LotteryCard(
                            number: goldenCodes[1], cardColor: Colors.green.withOpacity(0.2)),
                        const SizedBox(
                          width: 8,
                        ),
                        LotteryCard(
                            number: goldenCodes[2], cardColor: Colors.green.withOpacity(0.2)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
        //SizedBox(height: 80,)
      ],
    );
  }
}
