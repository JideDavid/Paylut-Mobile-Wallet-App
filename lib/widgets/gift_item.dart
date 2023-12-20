import 'package:flutter/material.dart';

class GiftItem extends StatelessWidget {
  final String type;
  final String senderName;
  const GiftItem({super.key, required this.type, required this.senderName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Icon and gift type
        Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(12)),
              child: const Icon(
                Icons.wifi,
                color: Colors.green,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const Text(
              "Data",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 16),
            ),
          ],
        ),
        //Sender
        const Text(
          "@JideDavid001",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
              fontSize: 16),
        ),
        //Redeem Button
        ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor:
              const MaterialStatePropertyAll(Colors.green),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  )),
            ),
            child: const Text("Redeem", style: TextStyle(color: Colors.white),))
      ],
    );
  }
}
