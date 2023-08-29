import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);
  
  @override
  
  State<LoadingScreen> createState() => _LoadingScreenState();
  
}
class _LoadingScreenState extends State<LoadingScreen> {
  
  void delayTimer(int time) async{

    Future.delayed(Duration(seconds: time), (){
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override

  void initState() {
    super.initState();
    delayTimer(1);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            CircleAvatar(radius: 200, backgroundColor: Colors.grey, child: Text("Splash Screen"),)
          ],
        ),
      ),
    );
  }
}
