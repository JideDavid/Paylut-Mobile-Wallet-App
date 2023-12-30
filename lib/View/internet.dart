import 'package:flutter/material.dart';
import 'package:paylut/models/user_model.dart';

class Internet extends StatefulWidget {
  final UserDetails userDetails;
  const Internet({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<Internet> createState() => _InternetState(userDetails: userDetails);
}

class _InternetState extends State<Internet> {
  UserDetails userDetails;
  _InternetState({required this.userDetails});

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
            Text("Internet", style: heading,),
            Text("Pay for subscription to your internet provider", style: subHeading,)
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
