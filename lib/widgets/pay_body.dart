import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paylut/Screens/cable_tv.dart';
import 'package:paylut/Screens/electricity.dart';
import 'package:paylut/models/gift_model.dart';
import 'package:paylut/models/user_model.dart';
import 'package:paylut/widgets/gift_item.dart';
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
  bool gettingGift = false;

  List<GiftDetails> gifts = [];
  int transitionTime = 300;
  List<double> scales = [0.8,0.8,0.8,0.8];

  Future<void> getGifts() async{
    if(mounted){
      setState(() {
        gettingGift = true;
      });
    }

    QuerySnapshot snapshot = await FirebaseFirestore.instance
    .collection('users').doc(userDetails.uid).collection('gifts').get();

    if(snapshot.docs.isNotEmpty){
      if(kDebugMode){
        print('user has gifts');
      }

      var giftsSnap = snapshot.docs;
      for(var gift in giftsSnap){
        gifts.add(GiftDetails.fromJson(gift));
      }

    }else{
      if(kDebugMode){
        print('user has no gifts');
      }
    }


    gettingGift = false;
    if(mounted){
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getGifts();
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
      await Future.delayed(const Duration(milliseconds: 50), (){scales[3] = 1;});
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
          //services section
          SizedBox(
            height: sw * 0.98,
            child: Column(
              children: [
                Expanded(
                  child: AnimatedScale(
                    scale: scales[0],
                    duration: Duration(milliseconds: transitionTime),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: sw * 0.28,
                          width: sw * 0.28,
                          child: SCard(
                            cardIcon: Icons.phone,
                            title: "Airtime",
                            route: Airtime(userDetails: userDetails),
                          ),
                        ),
                        SizedBox(
                            height: sw * 0.28,
                            width: sw * 0.28,
                            child: SCard(
                                cardIcon: Icons.wifi,
                                title: "Data",
                                route: Data(
                                  userDetails: userDetails,
                                ))),
                        SizedBox(
                            height: sw * 0.28,
                            width: sw * 0.28,
                            child: SCard(
                                cardIcon: Icons.live_tv,
                                title: "Cable TV",
                                route: CableTv(userDetails: userDetails))),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedScale(
                    scale: scales[1],
                    duration: Duration(milliseconds: transitionTime),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            height: sw * 0.28,
                            width: sw * 0.28,
                            child: SCard(
                                cardIcon: Icons.electric_meter,
                                title: "Electricity",
                                route: Electricity(userDetails: userDetails))),
                        SizedBox(
                            height: sw * 0.28,
                            width: sw * 0.28,
                            child: SCard(
                                cardIcon: Icons.sensors,
                                title: "Internet",
                                route: Internet(
                                  userDetails: userDetails,
                                ))),
                        SizedBox(
                            height: sw * 0.28,
                            width: sw * 0.28,
                            child: SCard(
                                cardIcon: Icons.book_outlined,
                                title: "Edu",
                                route: Education(
                                  userDetails: userDetails,
                                ))),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedScale(
                    scale: scales[2],
                    duration: Duration(milliseconds: transitionTime),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            height: sw * 0.28,
                            width: sw * 0.28,
                            child: SCard(
                                cardIcon: Icons.sports_basketball,
                                title: "Betting",
                                route: Betting(userDetails: userDetails))),
                        SizedBox(
                            height: sw * 0.28,
                            width: sw * 0.28,
                            child: SCard(
                                cardIcon: Icons.card_giftcard,
                                title: "Gift Card",
                                route: GiftCard(userDetails: userDetails))),
                        SizedBox(
                            height: sw * 0.28,
                            width: sw * 0.28,
                            child: SCard(
                                cardIcon: Icons.diamond_outlined,
                                title: "Gift Friend",
                                route: GiftFriend(userDetails: userDetails))),
                      ],
                    ),
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
          AnimatedScale(
            scale: scales[3],
            duration: Duration(milliseconds: transitionTime),
            child: SizedBox(
                height: sw * 0.6,
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: gettingGift ? const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 15, width: 15,
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                  strokeWidth: 2,
                                ),),
                                SizedBox(width: 4,),
                                Text('Loading...', style: TextStyle(color: Colors.green),)
                              ],
                            ),
                          )
                          : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: ListView.builder(
                              itemCount: gifts.length,
                                itemBuilder: (context, index){
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: GiftItem(type: gifts[index].type, senderName: gifts[index].senderName),
                                );
                            }),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
