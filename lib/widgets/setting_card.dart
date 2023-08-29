import 'package:flutter/material.dart';

class SettingCard extends StatelessWidget {
  final String title;
  final String value;
  const SettingCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.grey.withOpacity(0.1),
            width: double.infinity,
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(color: Colors.grey),),
                  Text(value),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 4,),
      ],
    );
  }
}
