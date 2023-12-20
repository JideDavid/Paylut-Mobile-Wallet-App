import 'package:flutter/material.dart';

class NumPrev extends StatelessWidget {
  final List<int> vaultResults;
  final int index;
  const NumPrev({super.key, required this.vaultResults, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40, width: 30,
      decoration: BoxDecoration(border: Border.all(color: Colors.deepOrange, width: 2,),
          borderRadius: BorderRadius.circular(10),
          color: Colors.black.withOpacity(0.3)
      ),
      child: Center(
          child: Text(vaultResults.isEmpty ? '0' : vaultResults[index].toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          )),
    );
  }
}
