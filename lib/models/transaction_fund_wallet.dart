import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionHistoryModel{
  final String type;
  final bool isCredit;
  final int amount;
  final Timestamp date;
  final String transactionRef;
  final int initialBalance;
  final int newBalance;

  TransactionHistoryModel({
    required this.type,
    required this.isCredit,
    required this.amount,
    required this.date,
    required this.transactionRef,
    required this.initialBalance,
    required this.newBalance
  });

  factory TransactionHistoryModel.fromJson(DocumentSnapshot snapshot){
    return TransactionHistoryModel(
        type: snapshot['type'],
        isCredit: snapshot['isCredit'],
        amount: snapshot['amount'],
        date: snapshot['date'],
        transactionRef: snapshot['transactionRef'],
        initialBalance: snapshot['initialBalance'],
        newBalance: snapshot['newBalance']);
  }

}