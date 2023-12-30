import 'package:flutter/material.dart';

class BronzeWinners extends StatefulWidget {
  const BronzeWinners({super.key});

  @override
  State<BronzeWinners> createState() => _BronzeWinnersState();
}

class _BronzeWinnersState extends State<BronzeWinners> {
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
            Text("Bronze Winners", style: heading,),
            Text("Details", style: subHeading,)
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
