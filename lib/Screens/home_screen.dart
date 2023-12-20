import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:paylut/models/user_model.dart';
import 'package:paylut/services/settings_provider.dart';
import 'package:paylut/widgets/home_body.dart';
import 'package:paylut/widgets/lut_body.dart';
import 'package:paylut/widgets/profile_body.dart';
import 'package:provider/provider.dart';
import '../widgets/pay_body.dart';

class Home extends StatefulWidget {

  final UserDetails userDetails;
  const Home({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<Home> createState() => _HomeState(userDetails: userDetails);
}

class _HomeState extends State<Home> {
  final UserDetails userDetails;
  _HomeState({required this.userDetails});

  int navBarIndex = 0;

  /// save user fcm token
  Future<void> saveFCMToken() async{
    //getting current FCM token
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    //getting database fcmToken
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users')
    .doc(userDetails.uid).get();

    //checking FCMToken field exists
    if(snapshot.get('fCMToken') == null){
      if(kDebugMode){
        print('No token for user yet');
      }
      await FirebaseFirestore.instance.collection('users')
      .doc(userDetails.uid).update({'fCMToken': fcmToken});
    }
    //checking if FCMToken fields exists but still fresh
    else if(snapshot.get('fCMToken') == fcmToken){
      if(kDebugMode){
        print('database fcmToken is fresh');
      }
      return;
    }
    //checking if FCMToken fields exists but not fresh
    else{
      await FirebaseFirestore.instance.collection('users')
          .doc(userDetails.uid).update({'fCMToken': fcmToken});
    }
  }
  /// The API endpoint here accepts a raw FCM payload for demonstration purposes.
  String constructFCMPayload(String? token) {
    return jsonEncode({
      "message":{
        "token":token,
        "notification":{
          "body":"This is an FCM notification message!",
          "title":"FCM Message"
        },
        "data": {
          "story_id": "story_12345"
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    saveFCMToken();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(
          children: [
            Visibility(
              visible: navBarIndex == 0 ? true : false,
              child: CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.2),
                radius: 20,
                backgroundImage: NetworkImage(userDetails.image),
              ),
            ),
            const SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( navBarIndex == 0 ? "Hello, ${userDetails.name}"
                  : navBarIndex == 1 ? "Pay Bills"
                  : navBarIndex == 2 ? "Lottery & Games"
                  : "Profile & Settings", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                Text( navBarIndex == 0 ? "We are ready for your transactions"
                    : navBarIndex == 1 ? "Speed of light transactions ready"
                    : navBarIndex == 2 ?"Earn without limits"
                    : "Update your personal details and settings", style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12))
              ],
            )
          ],
        ),
        actions: [
          navBarIndex == 0 ? IconButton(
              onPressed: (){},
              icon: const Icon(Icons.notification_important_rounded,))
          : navBarIndex == 3 ? Switch(
            activeTrackColor: Colors.red,
              value: context.watch<SettingsProvider>().lightMode,
              onChanged: (val){ !val ? context.read<SettingsProvider>().changeToDarkTheme()
              : context.read<SettingsProvider>().changeToLightTheme();})
              : IconButton(
              onPressed: (){},
              icon: const Icon(Icons.history_toggle_off,))
        ],
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0),
      ),
      bottomNavigationBar: SizedBox(
        height: 90,
        child: FittedBox(
          fit: BoxFit.cover,
          child: GNav(
              onTabChange: (index) {
                setState(() {
                  navBarIndex = index;
                });
              },
              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              color: Colors.grey,
              activeColor: Colors.red,
              gap: 0,
              tabs: const [
                GButton(icon: Icons.home, text: 'Home'),
                GButton(icon: Icons.wallet, text: 'Pay'),
                GButton(icon: Icons.diamond_outlined, text: 'Lut'),
                GButton(icon: Icons.person_2_rounded, text: 'profile'),
              ]),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        //Home body
        child: navBarIndex == 0 ? HomeBody(userDetails: userDetails,)
        //Pay body
        : navBarIndex == 1 ? PayBody(userDetails: userDetails,)
        : navBarIndex == 2 ? LotteryBody(userDetails: userDetails,)
        : ProfileBody(userDetails: userDetails,)
      ),
    );
  }
}
