import 'package:cloud_firestore/cloud_firestore.dart';

class Winners {
  final int amountClaimed;
  final String name;
  final Timestamp date;
  final String vault;
  final int winningEntryCount;

  Winners({
    required this.amountClaimed,
    required this.name,
    required this.date,
    required this.vault,
    required this.winningEntryCount
  });

  factory Winners.fromJson(DocumentSnapshot snapshot) {

    return Winners(
        amountClaimed: snapshot['amountClaimed'],
        name: snapshot['name'],
        date: snapshot['date'],
      vault: snapshot['vault'],
      winningEntryCount: snapshot['winningEntryCount'],
    );
  }

}
