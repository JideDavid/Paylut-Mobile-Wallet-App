import 'package:flutter/material.dart';
import 'package:paylut/models/user_model.dart';

class Electricity extends StatefulWidget {
  final UserDetails userDetails;
  const Electricity({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<Electricity> createState() => _ElectricityState(userDetails: userDetails);
}

class _ElectricityState extends State<Electricity> {
  UserDetails userDetails;
  _ElectricityState({required this.userDetails});

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
            Text("Electricity", style: heading,),
            Text("Pay your electricity bills with no stress", style: subHeading,)
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
