import 'package:cloud_firestore/cloud_firestore.dart';

class Number {
  String number;
  int providerIndex;
  String alias;
  int useTime;

  Number(
      {required this.number,
      required this.providerIndex,
      required this.alias,
      required this.useTime});

  factory Number.fromJson(DocumentSnapshot snapshot) {
    return Number(
        number: snapshot['number'],
        providerIndex: snapshot['providerIndex'],
        alias: snapshot['alias'],
        useTime: snapshot['useTime']);
  }
}
