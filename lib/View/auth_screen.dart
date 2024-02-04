import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nonce/nonce.dart';
import 'package:paylut/models/user_model.dart';
import 'home_screen.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  bool showLogo = true;
  bool pressed = false;

  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //sign in with google
  Future signInWithGoogle() async{
    //getting a google user from selection
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    //return if no user is selected
    if (googleUser == null) {
      return;
    }
    //getting google sign in authentication for this account
    final googleAuth = await googleUser.authentication;
    //drawing credential from googleAuthProvider with firebase
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    //signing user in firebaseAuth with google credential
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    //checking if user previously exist on firebase
    DocumentSnapshot userExist =
    await firestore.collection('users').doc(userCredential.user!.uid).get();

    //login user in if user exists
    if (userExist.exists) {
      UserDetails userDetails = UserDetails.fromJson(userExist);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => Home(userDetails: userDetails)));
    }
    //else create an account for user on firebase
    else {
      //generating wallet tag using the combination of username and generated seven alphanumeric keys
      var username = (userCredential.user!.displayName)?.replaceAll(' ', '');
      var walletTag = "$username${Nonce.generate(7)}";
      //saving user credential in firestore
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
        'name': userCredential.user!.displayName,
        'image': userCredential.user!.photoURL,
        'uid': userCredential.user!.uid,
        'date': DateTime.now(),
        'walletTag': walletTag,
        'walletBalance': 0,
      });


      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/main');
    }

  }

  void showLogoTimer(){
    Future.delayed(const Duration(seconds: 5),(){
      if(mounted){
        setState(() {
          showLogo = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    showLogoTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(
        child: showLogo ? Center(
          child: Image.asset('lib/icons/paylut_logo_anim.gif', height: 120,),
        )
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset('lib/icons/paylut_logo.png', height: 100, ),
                    const Text("Paylut",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                      textAlign: TextAlign.center,),
                    const SizedBox(height: 4,),
                    const Text("your all-in-one mobile wallet solution.",
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,),
                  ],
                ),
              ),
             Expanded(
               flex: 1,
                child: Column(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTapDown: (tapDetails){
                        setState(() {
                          pressed = true;
                        });
                      },

                      onTapUp: (tapDetails){
                        setState(() {
                          pressed = false;
                        });
                        signInWithGoogle();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                          color: pressed ? Colors.grey.withOpacity(0.2) : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('lib/icons/google_logo.png', height: 50,),
                            const Text("Continue with Google"),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ]
          ),
        ),
      )),
    );
  }
}
