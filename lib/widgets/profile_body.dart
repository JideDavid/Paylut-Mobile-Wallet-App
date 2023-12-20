import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:paylut/models/user_model.dart';
import 'package:paylut/widgets/setting_card.dart';

class ProfileBody extends StatefulWidget {
  final UserDetails userDetails;
  const ProfileBody({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<ProfileBody> createState() => _ProfileBodyState(userDetails: userDetails);
}

class _ProfileBodyState extends State<ProfileBody> {

  final UserDetails userDetails;
  _ProfileBodyState({required this.userDetails});

  String createdAgo = '';
  bool pressed = false;

  getDate(){
    createdAgo = GetTimeAgo.parse((userDetails.date).toDate());
  }

  @override
  void initState() {
    super.initState();
    getDate();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              CircleAvatar(
              radius: 125,
              backgroundColor: Colors.grey.withOpacity(0.5),
              child: CircleAvatar(
                radius: 115,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(userDetails.image),
              ),
            ),
              Positioned(
                bottom: 20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    color: Colors.red.withOpacity(0.3),
                      width: 40, height: 40,
                      child: IconButton(onPressed: (){},
                          iconSize:20,
                          icon: const Icon(Icons.edit, color: Colors.white,))),
                ),
              )
            ],
          ),
          //information list
          const SizedBox(height: 32,),
          SettingCard(title: 'Username', value: userDetails.name),
          SettingCard(title: 'Email', value: userDetails.email),
          SettingCard(title: 'WalletTag', value: userDetails.walletTag),
          SettingCard(title: 'Joined since', value: createdAgo),
          //logout button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: GestureDetector(
              onTapDown: (tapDetails){
                setState(() {
                  pressed = true;
                });
              },
                onTapUp: (tapDetails){

                  setState(() {
                    pressed = false;
                  });
                  //GoogleSignIn googleSignIn = GoogleSignIn();
                  GoogleSignIn().signOut();
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/authScreen');
                },
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(20),
                      color: pressed ? Colors.red.withOpacity(0.2) : null,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 36, vertical: 8),
                      child: Text('Log out'),
                    ))),
          ),
        ],
      ),
    );
  }
}
