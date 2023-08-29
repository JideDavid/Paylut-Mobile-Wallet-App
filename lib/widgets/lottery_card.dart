import 'package:flutter/material.dart';

class LotteryCard extends StatelessWidget {

  final int number;
  final Color cardColor;
  const LotteryCard({super.key,  required this.number, required this.cardColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: double.infinity,
          width: 35,
          decoration: BoxDecoration( border: Border.all( color: Colors.grey), borderRadius: BorderRadius.circular(10) ),
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