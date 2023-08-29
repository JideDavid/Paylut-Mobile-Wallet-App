import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nonce/nonce.dart';
import 'package:paylut/Screens/home_screen.dart';
import 'package:paylut/models/user_model.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

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
      var walletTag = "$username${Nonce.generate(7, Random.secure())}";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: signInWithGoogle, child: const Text("Sign in with google")),
          ]
        ),
      )),
    );
  }
}
