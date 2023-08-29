import 'package:flutter/material.dart';

class GCard extends StatelessWidget {


  final IconData cardIcon;
  final String title;
  final Widget route;
  final Color cardColor;

  const GCard({super.key, required this.cardIcon, required this.title, required this.route, required this.cardColor});



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => route));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.grey.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Icon(cardIcon, color: Colors.red,)),
                const SizedBox(height: 12,),
                Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold,),))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
