import 'package:flutter/material.dart';
import 'package:paylut/models/user_model.dart';

class Data extends StatefulWidget {
  final UserDetails userDetails;
  const Data({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<Data> createState() => _DataState(userDetails: userDetails);
}

class _DataState extends State<Data> {
  UserDetails userDetails;
  _DataState({required this.userDetails});

  TextStyle heading = const TextStyle( fontWeight: FontWeight.bold,);
  TextStyle subHeading = const TextStyle( fontWeight: FontWeight.normal, fontSize: 12,);
  //TextStyle sectionHeading = const TextStyle( fontWeight: FontWeight.normal, fontSize: 14, color: Colors.red);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Data", style: heading,),
            Text("Load data to your preferred network", style: subHeading,)
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
