import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:paylut/models/user_model.dart';
import 'package:http/http.dart' as http;

class FundWallet extends StatefulWidget {
  final UserDetails userDetails;
  const FundWallet({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<FundWallet> createState() => _FundWalletState(userDetails: userDetails);
}

class _FundWalletState extends State<FundWallet> {
  final UserDetails userDetails;
  _FundWalletState({required this.userDetails});

  TextStyle heading = const TextStyle(
    fontWeight: FontWeight.bold,
  );
  TextStyle subHeading = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
  );

  bool tapDown = false;
  String publicKey = "pk_test_e4a441b6b930e4ac06fd7ca1f90309e1fc73d7c6";
  String accessCode = "";
  final payStack = PaystackPlugin();
  int amount = 0;
  int initialBalance = 0;
  int newBalance = 0;
  bool hasInputAmount = false;
  String transactionRef = '';
  String paymentMethod = 'card';

  TextEditingController amountController = TextEditingController();

  Future<void> payWithPayStack() async {

    //formatting and setting transaction reference
    String ref = "ref_${DateTime.now()}";
    ref = ref.replaceAll(' ', '');
    ref = ref.replaceAll('-', '');
    ref = ref.replaceAll(':', '');
    ref = ref.replaceAll('.', '');
    transactionRef = ref;

    //getting user's initial balance
    DocumentSnapshot initBalance = (await FirebaseFirestore.instance
        .collection('users')
        .doc(userDetails.uid)
        .get());
    initialBalance = initBalance.get('walletBalance');

    // initialize transaction to get access code for bank and selectable methods
    Uri url = Uri.parse("https://api.paystack.co/transaction/initialize");
    var response = await http.post(url,
      headers: {'authorization' : "Bearer sk_test_c851dfbfc4513795a70eb46cac333f7f3d32f86c",},
      body: {
        "email": userDetails.email,
        "amount": (amount * 100).toString()
        }
    );
    Map data = jsonDecode(response.body);
    accessCode = data['data']['access_code'];
    ref = data['data']['reference'];


    //charging user
    Charge charge = Charge()
      ..amount = amount * 100
      ..email = userDetails.email
      ..reference = transactionRef
      ..accessCode = accessCode
      ..currency = "NGN";

    CheckoutResponse chkResponse =
        // ignore: use_build_context_synchronously
        await payStack.checkout(
            context, charge: charge,
            method: CheckoutMethod.selectable);

    if (chkResponse.status) {

      //wallet balance from database
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('users').doc(userDetails.uid).get();
      int walletBalance = userData.get('walletBalance') + amount;
      newBalance = walletBalance;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userDetails.uid)
          .update({'walletBalance': walletBalance});

      //recording transaction in history
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userDetails.uid)
          .collection('transactions')
          .doc(transactionRef)
          .set({
        'type': 'wallet funding',
        'isCredit': true,
        'amount': amount,
        'method': 'card',
        'date': DateTime.now(),
        'transactionRef': transactionRef,
        'initialBalance': initialBalance,
        'newBalance': newBalance
      });

      // ignore: use_build_context_synchronously
      //Navigator.of(context).pop();
    }
  }

  //constructing FCM notification payload
  String constructFCMPayload(String? token) {
    return jsonEncode({
      'token': token,
      'priority': 'high',
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'page': 'home',
      },
      'notification': {
        'title': 'Credit Alert',
        'body': '${userDetails.name} our Paylut account has just been funded $amount NGN',
      },
    });
  }

  @override
  void initState() {
    super.initState();
    payStack.initialize(publicKey: publicKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Fund Wallet",
              style: heading,
            ),
            Text(
              "Input requested details to fund your wallet",
              style: subHeading,
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.history,
              ))
        ],
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          //Amount text field
          TextField(
            controller: amountController,
            onChanged: (value) {
              amount = int.tryParse(amountController.text)!;
              if (amount < 1) {
                setState(() {
                  hasInputAmount = false;
                });
              } else {
                setState(() {
                  hasInputAmount = true;
                });
              }
            },
            maxLength: 9,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              counterText: "",
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(20)),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple, width: 1.0),
                  borderRadius: BorderRadius.circular(20)),
              hintText: 'Enter Amount',
            ),
          ),

          //fund wallet button
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: !hasInputAmount ? null : payWithPayStack,
                  style: ButtonStyle(
                      backgroundColor: !hasInputAmount
                          ? const MaterialStatePropertyAll(Colors.grey)
                          : const MaterialStatePropertyAll(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      )),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text("Fund Wallet"),
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
