import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:paylut/models/user_model.dart';
import 'package:paylut/widgets/home_body.dart';
import 'package:paylut/widgets/lut_body.dart';
import 'package:paylut/widgets/profile_body.dart';
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
              textSize: 10,
              style: GnavStyle.google,
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
