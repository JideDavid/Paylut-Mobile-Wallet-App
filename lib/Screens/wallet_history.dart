import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paylut/Screens/receipt.dart';
import 'package:paylut/models/transaction_fund_wallet.dart';
import 'package:paylut/models/user_model.dart';

class WalletFundHistory extends StatefulWidget {
  final UserDetails userDetails;
  const WalletFundHistory({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<WalletFundHistory> createState() => _WalletFundHistoryState(userDetails: userDetails);
}

class _WalletFundHistoryState extends State<WalletFundHistory> {
  UserDetails userDetails;
  _WalletFundHistoryState({required this.userDetails});

  List<TransactionHistoryModel> transactionHistory = [];
  bool isLoading = true;
  bool hasData = true;
  TextStyle heading = const TextStyle(
    fontWeight: FontWeight.bold,
  );
  TextStyle subHeading = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
  );
  TextStyle sectionHeading =
      const TextStyle(fontWeight: FontWeight.normal, fontSize: 14, color: Colors.deepPurple);

  Future<void> getFundHistory() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userDetails.uid)
        .collection('transactions')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (var historyData in value.docs) {
          TransactionHistoryModel fundHistory = TransactionHistoryModel.fromJson(historyData);
          transactionHistory.add(fundHistory);
        }
        hasData = true;
        isLoading = false;
        //sorting fund history list with date
        transactionHistory.sort((a, b) => b.date.compareTo(a.date));
        setState(() {});
      } else {
        if (kDebugMode) {
          print('no data');
        }
        hasData = false;
        isLoading = false;
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getFundHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Transaction History",
              style: heading,
            ),
            Text(
              "Tap on each card to view transaction details",
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.red,
            ))
          : hasData
              //list of wallet funding history
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                      itemCount: transactionHistory.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: transactionHistory[index].type == 'transfer'
                          ? (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)
                            {
                              return Receipt(userDetails: userDetails,
                                  transactionRef: transactionHistory[index].transactionRef);
                            }
                            ));
                          }
                          : (){print('type not transfer');},
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: double.infinity,
                                color: transactionHistory[index].isCredit ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Image(image: AssetImage('lib/icons/naira.png'),
                                                height: 12,
                                                color: Colors.grey,
                                              ),
                                              Text(
                                                '${transactionHistory[index].amount}.00',
                                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                transactionHistory[index].type,
                                                style: const TextStyle(fontSize: 20,),
                                              ),
                                            ],
                                          ),


                                        ],
                                      ),
                                      const SizedBox(height: 4,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.circle,
                                                color: transactionHistory[index].isCredit ? Colors.green
                                                : Colors.red,
                                                size: 8,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                transactionHistory[index].transactionRef,
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(
                                                    (transactionHistory[index].date.toDate()).toString())),
                                                style: const TextStyle(fontSize: 12),
                                                overflow: TextOverflow.clip,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                )

              //empty data feedback
              : const Center(
                  child: Text('It\'s empty here'),
                ),
    );
  }
}
