import 'package:flutter/material.dart';
import 'package:paylut/Screens/home_screen.dart';
import 'package:paylut/Screens/silver_vault.dart';
import 'package:paylut/models/user_model.dart';
import '../Screens/bronze_vault2.dart';
import '../Screens/golden_vault.dart';
import 'game_card.dart';

class LotteryBody extends StatefulWidget {
  final UserDetails userDetails;
  const LotteryBody({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<LotteryBody> createState() => _LotteryBodyState(userDetails: userDetails);
}

class _LotteryBodyState extends State<LotteryBody> {
  UserDetails userDetails;
  _LotteryBodyState({required this.userDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //lottery section
        Expanded(
          flex: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: Colors.grey.withOpacity(0.2),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage("assets/banners/golden_vault.jpg"),
                        fit: BoxFit.cover,
                      )),
                      child: Image.asset(
                        "assets/patterns/dotPattern.png",
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Lottery Categories",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  //lottery cards
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 16),
                            child: Row(
                              children: [
                                Expanded(
                                    child: GCard(
                                  cardIcon: Icons.currency_bitcoin,
                                  title: "Bronze",
                                  route: BronzeVault2(userDetails: userDetails),
                                  cardColor: Colors.purple,
                                )),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                    child: GCard(
                                        cardIcon: Icons.phone,
                                        title: "Silver",
                                        route: SilverVault(userDetails: userDetails),
                                        cardColor: Colors.blue)),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                    child: GCard(
                                        cardIcon: Icons.phone,
                                        title: "Golden",
                                        route: GoldenVault(
                                          userDetails: userDetails,
                                        ),
                                        cardColor: Colors.red)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(
          height: 32,
        ),

        //games section
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: Colors.grey.withOpacity(0.2),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/banners/game_banner.jpg"),
                              fit: BoxFit.cover)),
                      child: Image.asset(
                        "assets/patterns/dotPattern.png",
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Game Categories",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  //lottery cards
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 16),
                            child: Row(
                              children: [
                                Expanded(
                                    child: GCard(
                                  cardIcon: Icons.electric_meter,
                                  title: "Electricity",
                                  route: Home(userDetails: userDetails),
                                  cardColor: Colors.green,
                                )),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                    child: GCard(
                                        cardIcon: Icons.phone,
                                        title: "Airtime",
                                        route: Home(userDetails: userDetails),
                                        cardColor: Colors.yellow)),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                    child: GCard(
                                        cardIcon: Icons.phone,
                                        title: "Airtime",
                                        route: Home(userDetails: userDetails),
                                        cardColor: Colors.pink)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
