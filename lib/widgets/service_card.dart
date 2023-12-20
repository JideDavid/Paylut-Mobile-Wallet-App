import 'package:flutter/material.dart';

class SCard extends StatelessWidget {


  final IconData cardIcon;
  final String title;
  final Widget route;

  const SCard({super.key, required this.cardIcon, required this.title, required this.route});



  @override
  Widget build(BuildContext context) {

    double sw = MediaQuery.of(context).size.width;
    //double sh = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: (){
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => route)
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: sw/5,
            width: sw/5,
          color: Colors.grey.withOpacity(0.2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(cardIcon, color: Colors.red,),
              const SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: const TextStyle(fontSize: 12,fontWeight: FontWeight.normal),
                  overflow: TextOverflow.ellipsis,),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
