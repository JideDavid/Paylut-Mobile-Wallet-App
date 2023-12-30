import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paylut/models/user_model.dart';

class GameReceipt extends StatefulWidget {
  final UserDetails userDetails;
  final String transactionRef;
  final bool newTransaction;
  const GameReceipt({super.key, required this.userDetails, required this.transactionRef, required this.newTransaction});

  @override
  State<GameReceipt> createState() =>
      // ignore: no_logic_in_create_state
      _GameReceiptState(userDetails: userDetails, transactionRef: transactionRef, newTransaction: newTransaction);
}

class _GameReceiptState extends State<GameReceipt> {
  UserDetails userDetails;
  String transactionRef;
  bool newTransaction;
  _GameReceiptState({required this.userDetails, required this.transactionRef, required this.newTransaction});

  var f = NumberFormat("##,###,###", "en_US");

  int amount = 0;
  Timestamp date = Timestamp.now();
  String gameCategory = '';
  int initialBalance = 0;
  bool isCredit = false;
  int newBalance = 0;
  String ref = '';
  String type = '';
  bool isLoading = false;

  TextStyle heading = const TextStyle(
    fontWeight: FontWeight.bold,
  );
  TextStyle subHeading = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
  );

  Future<void> getReceipt() async {
    isLoading = true;
    if (mounted) {
      setState(() {});
    }

    DocumentSnapshot rSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userDetails.uid)
        .collection('transactions')
        .doc(transactionRef)
        .get();

    amount = rSnapshot.get('amount');
    date = rSnapshot.get('date');
    gameCategory = rSnapshot.get('gameCategory');
    initialBalance = rSnapshot.get('initialBalance');
    isCredit = rSnapshot.get('isCredit');
    newBalance = rSnapshot.get('newBalance');
    ref = rSnapshot.get('transactionRef');
    type = rSnapshot.get('type');

    if (kDebugMode) {
      print(
          '$amount, $date, $gameCategory, $initialBalance, $newBalance, $ref, $type, $isCredit');
    }

    isLoading = false;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getReceipt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Receipt",
              style: heading,
            ),
            Text(
              "Transaction details",
              style: subHeading,
            )
          ],
        ),
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
                  color: isLoading ? Colors.grey : (isCredit ? Colors.green : Colors.red)),
              borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  const Text('Amount'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: const AssetImage(
                          'lib/icons/naira.png',
                        ),
                        height: 30,
                        color: isLoading ? Colors.grey : (isCredit ? Colors.green : Colors.red),
                      ),
                      Text(
                        f.format(amount),
                        style: TextStyle(
                            fontSize: 30,
                            color:
                                isLoading ? Colors.grey : (isCredit ? Colors.green : Colors.red)),
                      )
                    ],
                  ),
                  const Divider(
                    height: 80,
                    thickness: 1,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'SUCCESS',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Game Category',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          gameCategory,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Date',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(DateFormat('yy-MM-dd - kk:mm')
                            .format(DateTime.parse(date.toDate().toString()))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Reference',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(ref),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transaction type',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text('Games'),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 80,
                    thickness: 1,
                  ),
                  Visibility(
                    visible: newTransaction,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.grey.withOpacity(0.2),
                        width: double.infinity,
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(
                                Icons.info,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'The recipient account is expected to be credited within 2 minutes.',
                                style: TextStyle(),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.share,
                          color: Colors.red,
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
