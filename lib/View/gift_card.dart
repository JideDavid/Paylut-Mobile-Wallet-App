import 'package:flutter/material.dart';

import '../models/user_model.dart';

class GiftCard extends StatefulWidget {
  final UserDetails userDetails;
  const GiftCard({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<GiftCard> createState() => _GiftCardState(userDetails: userDetails);
}

class _GiftCardState extends State<GiftCard> {
  UserDetails userDetails;
  _GiftCardState({required this.userDetails});

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
            Text("GiftCard", style: heading,),
            Text("Buy, sell and exchange gift cards with ease", style: subHeading,)
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
