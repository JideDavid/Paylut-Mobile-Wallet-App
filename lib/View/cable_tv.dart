import 'package:flutter/material.dart';
import 'package:paylut/models/user_model.dart';

class CableTv extends StatefulWidget {
  final UserDetails userDetails;
  const CableTv({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<CableTv> createState() => _CableTvState(userDetails: userDetails);
}

class _CableTvState extends State<CableTv> {
  UserDetails userDetails;
  _CableTvState({required this.userDetails});
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
            Text("Cable TV", style: heading,),
            Text("Subscribe for your cable Tv with ease", style: subHeading,)
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
