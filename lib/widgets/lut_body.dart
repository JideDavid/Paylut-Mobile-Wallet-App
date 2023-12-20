import 'package:flutter/material.dart';
import 'package:paylut/Screens/silver_vault.dart';
import 'package:paylut/Screens/spin_wheel.dart';
import 'package:paylut/models/user_model.dart';
import '../Screens/bronze_vault.dart';
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

  int transitionTime = 300;
  List<double> scales = [0.8,0.8,0.8];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      scales[0] = 1;
      if(mounted){
        setState(() {});
      }
      await Future.delayed(const Duration(milliseconds: 50), (){scales[1] = 1;});
      if(mounted){
        setState(() {});
      }
      await Future.delayed(const Duration(milliseconds: 50), (){scales[2] = 1;});
      if(mounted){
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //lottery section
          AnimatedScale(
            scale: scales[0],
            duration: Duration(milliseconds: transitionTime),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: sw * 0.6,
                color: Colors.grey.withOpacity(0.2),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: sw * 0.2,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage("assets/banners/golden_vault.jpg"),
                        fit: BoxFit.cover,
                      )),
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 16),
                        child: Row(
                          children: [
                            Expanded(
                                child: GCard(
                              cardIcon: Icons.payments,
                              title: "Bronze",
                              route: BronzeVault2(userDetails: userDetails),
                              cardColor: Colors.purple,
                            )),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                                child: GCard(
                                    cardIcon: Icons.payments,
                                    title: "Silver",
                                    route: SilverVault(userDetails: userDetails),
                                    cardColor: Colors.blue)),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                                child: GCard(
                                    cardIcon: Icons.payments,
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
            ),
          ),

          const SizedBox(
            height: 32,
          ),

          //games section
          AnimatedScale(
            scale: scales[1],
            duration: Duration(milliseconds: transitionTime),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: sw * 0.6,
                color: Colors.grey.withOpacity(0.2),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: sw * 0.2,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/banners/game_banner.jpg"),
                              fit: BoxFit.cover)),
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 16),
                        child: Row(
                          children: [
                            Expanded(
                                child: GCard(
                              cardIcon: Icons.gamepad,
                              title: "Spin1",
                              route: SpinWheel1(userDetails: userDetails),
                              cardColor: Colors.green,
                            )),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                                child: GCard(
                                    cardIcon: Icons.gamepad,
                                    title: "Spin2",
                                    route: SpinWheel1(userDetails: userDetails),
                                    cardColor: Colors.yellow)),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                                child: GCard(
                                    cardIcon: Icons.gamepad,
                                    title: "Spin3",
                                    route: SpinWheel1(userDetails: userDetails),
                                    cardColor: Colors.pink)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
