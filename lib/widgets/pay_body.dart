import 'package:flutter/material.dart';
import 'package:paylut/Screens/cable_tv.dart';
import 'package:paylut/Screens/electricity.dart';
import 'package:paylut/models/user_model.dart';
import 'package:paylut/widgets/service_card.dart';

import '../Screens/airtime.dart';
import '../Screens/betting.dart';
import '../Screens/data.dart';
import '../Screens/education.dart';
import '../Screens/gift_card.dart';
import '../Screens/gift_friend.dart';
import '../Screens/internet.dart';

class PayBody extends StatefulWidget {
  final UserDetails userDetails;
  const PayBody({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<PayBody> createState() => _PayBodyState(userDetails: userDetails);
}

class _PayBodyState extends State<PayBody> {
  UserDetails userDetails;
  _PayBodyState({required this.userDetails});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //services section
        Expanded(
          flex: 6,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: SCard(
                      cardIcon: Icons.phone,
                      title: "Airtime",
                      route: Airtime(userDetails: userDetails),
                    )),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: SCard(
                            cardIcon: Icons.wifi,
                            title: "Data",
                            route: Data(
                              userDetails: userDetails,
                            ))),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: SCard(
                            cardIcon: Icons.live_tv,
                            title: "Cable TV",
                            route: CableTv(userDetails: userDetails))),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: SCard(
                            cardIcon: Icons.electric_meter,
                            title: "Electricity",
                            route: Electricity(userDetails: userDetails))),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: SCard(
                            cardIcon: Icons.sensors,
                            title: "Internet",
                            route: Internet(
                              userDetails: userDetails,
                            ))),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: SCard(
                            cardIcon: Icons.book_outlined,
                            title: "Education",
                            route: Education(
                              userDetails: userDetails,
                            ))),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: SCard(
                            cardIcon: Icons.sports_basketball,
                            title: "Betting",
                            route: Betting(userDetails: userDetails))),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: SCard(
                            cardIcon: Icons.card_giftcard,
                            title: "Gift Card",
                            route: GiftCard(userDetails: userDetails))),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: SCard(
                            cardIcon: Icons.diamond_outlined,
                            title: "Gift Friend",
                            route: GiftFriend(userDetails: userDetails))),
                  ],
                ),
              ),
            ],
          ),
        ),
        //Dividing space
        const SizedBox(
          height: 16,
        ),
        //received gifts section
        Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Received Gifts",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Icon(
                      Icons.card_giftcard,
                      color: Colors.red,
                      size: 16,
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                // Gifts container
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(24),
                      color: const Color(0xff2ee1d2).withOpacity(0.2),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //History data model
                          Column(
                            children: [
                              //contents
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Icon and gift type
                                    Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.green),
                                              borderRadius: BorderRadius.circular(12)),
                                          child: const Icon(
                                            Icons.wifi,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Text(
                                          "Data",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    //Sender
                                    const Text(
                                      "@JideDavid001",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 16),
                                    ),
                                    //Redeem Button
                                    ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              const MaterialStatePropertyAll(Colors.green),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                          )),
                                        ),
                                        child: const Text("Redeem"))
                                  ],
                                ),
                              ),
                              //divider
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.green,
                                  height: 0,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              //contents
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Icon and gift type
                                    Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.green),
                                              borderRadius: BorderRadius.circular(12)),
                                          child: const Icon(
                                            Icons.wifi,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Text(
                                          "Data",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    //Sender
                                    const Text(
                                      "@JideDavid001",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 16),
                                    ),
                                    //Redeem Button
                                    ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              const MaterialStatePropertyAll(Colors.green),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                          )),
                                        ),
                                        child: const Text("Redeem"))
                                  ],
                                ),
                              ),
                              //divider
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.green,
                                  height: 0,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              //contents
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Icon and gift type
                                    Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.green),
                                              borderRadius: BorderRadius.circular(12)),
                                          child: const Icon(
                                            Icons.wifi,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Text(
                                          "Data",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    //Sender
                                    const Text(
                                      "@JideDavid001",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 16),
                                    ),
                                    //Redeem Button
                                    ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              const MaterialStatePropertyAll(Colors.green),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                          )),
                                        ),
                                        child: const Text("Redeem"))
                                  ],
                                ),
                              ),
                              //divider
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.green,
                                  height: 0,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              //contents
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Icon and gift type
                                    Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.green),
                                              borderRadius: BorderRadius.circular(12)),
                                          child: const Icon(
                                            Icons.wifi,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Text(
                                          "Data",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    //Sender
                                    const Text(
                                      "@JideDavid001",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 16),
                                    ),
                                    //Redeem Button
                                    ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              const MaterialStatePropertyAll(Colors.green),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                          )),
                                        ),
                                        child: const Text("Redeem"))
                                  ],
                                ),
                              ),
                              //divider
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.green,
                                  height: 0,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              //contents
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Icon and gift type
                                    Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.green),
                                              borderRadius: BorderRadius.circular(12)),
                                          child: const Icon(
                                            Icons.wifi,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Text(
                                          "Data",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    //Sender
                                    const Text(
                                      "@JideDavid001",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 16),
                                    ),
                                    //Redeem Button
                                    ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              const MaterialStatePropertyAll(Colors.green),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                          )),
                                        ),
                                        child: const Text("Redeem"))
                                  ],
                                ),
                              ),
                              //divider
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.green,
                                  height: 0,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ))
      ],
    );
  }
}
