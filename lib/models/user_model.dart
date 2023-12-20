import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  final String uid;
  final String name;
  final String email;
  final String walletTag;
  late final int walletBalance;
  final String image;
  final Timestamp date;
  final String fCMToken;

  UserDetails({
    required this.uid,
    required this.name,
    required this.email,
    required this.walletTag,
    required this.walletBalance,
    required this.image,
    required this.date,
    required this.fCMToken,
  });

  factory UserDetails.fromJson(DocumentSnapshot snapshot) {
    return UserDetails(
        uid: snapshot['uid'],
        name: snapshot['name'],
        email: snapshot['email'],
        walletTag: snapshot['walletTag'],
        walletBalance: snapshot['walletBalance'],
        image: snapshot['image'],
        date: snapshot['date'],
        fCMToken: snapshot['fCMToken']
    );
  }

}
