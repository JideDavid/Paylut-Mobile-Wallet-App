import 'package:flutter/material.dart';
import 'package:paylut/models/user_model.dart';

class Airtime extends StatefulWidget {
  final UserDetails userDetails;
  const Airtime({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<Airtime> createState() => _AirtimeState(userDetails: userDetails);
}

class _AirtimeState extends State<Airtime> {
  UserDetails userDetails;
  _AirtimeState({required this.userDetails});

  @override
  Widget build(BuildContext context) {

    TextStyle heading = const TextStyle( fontWeight: FontWeight.bold,);
    TextStyle subHeading = const TextStyle( fontWeight: FontWeight.normal, fontSize: 12,);
    //TextStyle sectionHeading = const TextStyle( fontWeight: FontWeight.normal, fontSize: 14, color: Colors.deepPurple);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Airtime", style: heading,),
            Text("Load airtime to your preferred network", style: subHeading,)
          ],
        ),
        actions: [
          IconButton(
              onPressed: (){},
              icon: const Icon(Icons.history,))
        ],
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0),
      ),
    );
  }
}
