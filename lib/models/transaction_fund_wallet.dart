import 'package:cloud_firestore/cloud_firestore.dart';

class FundWalletTrans{
  final String type;
  final bool isCredit;
  final int amount;
  final String method;
  final Timestamp date;
  final String transactionRef;
  final int initialBalance;
  final int newBalance;

  FundWalletTrans({
    required this.type,
    required this.isCredit,
    required this.amount,
    required this.method,
    required this.date,
    required this.transactionRef,
    required this.initialBalance,
    required this.newBalance
  });

  factory FundWalletTrans.fromJson(DocumentSnapshot snapshot){
    return FundWalletTrans(
        type: snapshot['type'],
        isCredit: snapshot['isCredit'],
        amount: snapshot['amount'],
        method: snapshot['method'],
        date: snapshot['date'],
        transactionRef: snapshot['transactionRef'],
        initialBalance: snapshot['initialBalance'],
        newBalance: snapshot['newBalance']);
  }

}