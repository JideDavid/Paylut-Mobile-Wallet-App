import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  List<FundWalletTrans> fundWalletHistory = [];
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
        .where('type', isEqualTo: 'wallet funding')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (var historyData in value.docs) {
          FundWalletTrans fundHistory = FundWalletTrans.fromJson(historyData);
          fundWalletHistory.add(fundHistory);
        }
        hasData = true;
        isLoading = false;
        //sorting fund history list with date
        fundWalletHistory.sort((a, b) => b.date.compareTo(a.date));
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
              "Wallet History",
              style: heading,
            ),
            Text(
              "Your wallet funding history",
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
            itemCount: fundWalletHistory.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 35,
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                color: Colors.green,
                                size: 8,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              const Text(
                                'credit',
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                '${fundWalletHistory[index].amount}.00NGN',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                DateFormat('yyyy-MM-dd – kk:mm').format(
                                    DateTime.parse(
                                        (fundWalletHistory[index].date.toDate())
                                            .toString())),
                                style: const TextStyle(fontSize: 12),
                              )
                            ],
                          )
                        ],
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
