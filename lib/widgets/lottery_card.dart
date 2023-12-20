import 'package:flutter/material.dart';

class LotteryCard extends StatelessWidget {

  final int number;
  final Color cardColor;
  const LotteryCard({super.key,  required this.number, required this.cardColor});

  @override
  Widget build(BuildContext context) {

    double sw = MediaQuery.of(context).size.width;
    //double sh = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: sw/6,
          width: sw/10,
          decoration: BoxDecoration( border: Border.all( color: Colors.grey.withOpacity(0.4)), borderRadius: BorderRadius.circular(10) ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, size: 15, color: Colors.red,),
              Text(number.toString(), style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16,),)
            ],
          ),
        ),
      ),
    );
  }
}