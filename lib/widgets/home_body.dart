import 'dart:async';

import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paylut/Screens/airtime.dart';
import 'package:paylut/Screens/bronze_winners.dart';
import 'package:paylut/Screens/cable_tv.dart';
import 'package:paylut/Screens/data.dart';
import 'package:paylut/Screens/fund_wallet.dart';
import 'package:paylut/Screens/gift_card.dart';
import 'package:paylut/Screens/wallet_fund_history.dart';
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

  bool showBalance = false;
  bool gotVisibility = false;
  List<int> eagleNum = [19, 23, 63, 74, 57, 62, 17];
  List<int> oceanNum = [84, 21, 63, 48, 45];
  List<int> classicNum = [11, 20, 36];
  int vaultPreviewIndex = 1;
  int bronzeVaultAmount = 1000000;
  int silverVaultAmount = 5000000;
  int goldenVaultAmount = 7000000;
  bool updatedBalance = false;
  int newBalance = 0;
  int walletAction = 1;

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

  Future<void> getBalanceVisibility() async {
    bool? value = await PrefHelper().getBalanceVisibility();
    showBalance = value!;
    gotVisibility = true;
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

  @override
  void initState() {
    super.initState();
    getBalanceVisibility();
    //switchVaultAmount();
    updateBalance();
  }

  @override
  void dispose() {
    super.dispose();
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
                    "assets/patterns/dotPattern.png",
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
                                    getBalanceVisibility();
                                  } else {
                                    PrefHelper().setBalanceVisibility(true);
                                    getBalanceVisibility();
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
                                "Funding History",
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

                                //Todo use stream builder to update wallet balance
                                StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                    .collection('users').snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {

                                      if(snapshot.connectionState == ConnectionState.waiting){
                                        return const Text('Loading..');
                                      }

                                      if(snapshot.hasData){
                                        var col = snapshot.data!;
                                        for(var doc in col.docs){
                                          if(doc.id == userDetails.uid){
                                            return Text(
                                              showBalance
                                                  ? ("${doc['walletBalance']}.00")
                                                  : "*****",
                                              style: const TextStyle(fontSize: 30, color: Colors.white),
                                            );
                                          }
                                        }
                                      }
                                      return Text(
                                        showBalance
                                            ? '00'
                                            : "*****",
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
                                  } else {
                                    walletAction = 1;
                                  }
                                });
                              },
                              child: const Icon(
                                Icons.swap_horizontal_circle,
                                color: Colors.white,
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
                                backgroundColor: const MaterialStatePropertyAll(Colors.red),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                )),
                            child: Text(walletAction == 1
                                ? "Add Fund"
                                : walletAction == 2
                                    ? "Transfer"
                                    : "Withdraw"),
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
                  const Text("(Today)", style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                          LotteryCard(number: eagleNum[0], cardColor: Colors.red.withOpacity(0.2)),
                          const SizedBox(
                            width: 8,
                          ),
                          LotteryCard(number: eagleNum[1], cardColor: Colors.red.withOpacity(0.2)),
                          const SizedBox(
                            width: 8,
                          ),
                          LotteryCard(number: eagleNum[2], cardColor: Colors.red.withOpacity(0.2)),
                          const SizedBox(
                            width: 8,
                          ),
                          LotteryCard(number: eagleNum[3], cardColor: Colors.red.withOpacity(0.2)),
                          const SizedBox(
                            width: 8,
                          ),
                          LotteryCard(number: eagleNum[4], cardColor: Colors.red.withOpacity(0.2)),
                          const SizedBox(
                            width: 8,
                          ),
                          LotteryCard(number: eagleNum[5], cardColor: Colors.red.withOpacity(0.2)),
                          const SizedBox(
                            width: 8,
                          ),
                          LotteryCard(number: eagleNum[6], cardColor: Colors.red.withOpacity(0.2)),
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
                        LotteryCard(number: oceanNum[0], cardColor: Colors.yellow.withOpacity(0.3)),
                        const SizedBox(
                          width: 8,
                        ),
                        LotteryCard(number: oceanNum[1], cardColor: Colors.yellow.withOpacity(0.3)),
                        const SizedBox(
                          width: 8,
                        ),
                        LotteryCard(number: oceanNum[2], cardColor: Colors.yellow.withOpacity(0.3)),
                        const SizedBox(
                          width: 8,
                        ),
                        LotteryCard(number: oceanNum[3], cardColor: Colors.yellow.withOpacity(0.3)),
                        const SizedBox(
                          width: 8,
                        ),
                        LotteryCard(number: oceanNum[4], cardColor: Colors.yellow.withOpacity(0.3)),
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
                            number: classicNum[0], cardColor: Colors.green.withOpacity(0.2)),
                        const SizedBox(
                          width: 8,
                        ),
                        LotteryCard(
                            number: classicNum[1], cardColor: Colors.green.withOpacity(0.2)),
                        const SizedBox(
                          width: 8,
                        ),
                        LotteryCard(
                            number: classicNum[2], cardColor: Colors.green.withOpacity(0.2)),
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
