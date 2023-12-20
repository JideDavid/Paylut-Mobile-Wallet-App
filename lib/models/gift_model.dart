import 'package:cloud_firestore/cloud_firestore.dart';

class GiftDetails {
  final String type;
  final int amount;
  final String sender;
  final String senderName;
  final Timestamp date;
  final bool redeemed;

  GiftDetails({
    required this.type,
    required this.amount,
    required this.sender,
    required this.senderName,
    required this.date,
    required this.redeemed,
  });

  factory GiftDetails.fromJson(DocumentSnapshot snapshot) {
    return GiftDetails(
        type: snapshot['type'],
        amount: snapshot['amount'],
        sender: snapshot['sender'],
        senderName: snapshot['senderName'],
        date: snapshot['date'],
        redeemed: snapshot['redeemed'],
    );
  }

}
