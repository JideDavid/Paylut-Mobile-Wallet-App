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
              radius: 120,
              backgroundColor: Colors.grey.withOpacity(0.5),
              child: CircleAvatar(
                radius: 115,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(userDetails.image),
              ),
            ),
              Positioned(
                bottom: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    color: Colors.red.withOpacity(0.3),
                      child: IconButton(onPressed: (){},
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
                onTap: (){
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  googleSignIn.signOut();
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/authScreen');
                },
                child: const Text('Log out')),
          ),
        ],
      ),
    );
  }
}
