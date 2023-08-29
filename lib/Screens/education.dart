import 'package:flutter/material.dart';

import '../models/user_model.dart';

class Education extends StatefulWidget {
  final UserDetails userDetails;
  const Education({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<Education> createState() => _EducationState(userDetails: userDetails);
}

class _EducationState extends State<Education> {
  UserDetails userDetails;
  _EducationState({required this.userDetails});
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
            Text("Education", style: heading,),
            Text("Pay for exams enrollment and results", style: subHeading,)
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
