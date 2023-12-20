import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paylut/models/user_model.dart';
import '../Screens/claim_vault_win.dart';

class GoldenVaultResult extends StatefulWidget {
  final UserDetails userDetails;
  const GoldenVaultResult({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<GoldenVaultResult> createState() => _GoldenVaultResultState(userDetails: userDetails);
}

class _GoldenVaultResultState extends State<GoldenVaultResult> {
  UserDetails userDetails;
  _GoldenVaultResultState({required this.userDetails});

  var f = NumberFormat("##,###,###.00", "en_US");

  bool hasResult = false;
  List<int> playedNumbers = [];
  int amountPlayed = 0;
  bool entry1Win = false;
  bool entry2Win = false;
  bool entry3Win = false;
  List<int> results = [];
  int winEntryCount = 0;
  int vaultAmount = 1000000;
  bool loading = true;
  int multiplier = 1;

  //function to check if player has made any entry
  Future<void> checkPlayed() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('vaults')
        .doc('golden')
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .collection('entries')
        .doc(userDetails.uid)
        .get();

    playedNumbers.add(snapshot.get('entry1'));
    playedNumbers.add(snapshot.get('entry2'));
    playedNumbers.add(snapshot.get('entry3'));
    amountPlayed = snapshot.get('amount');
    multiplier = snapshot.get('multiplier');

    DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('vaults')
        .doc('golden')
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .get();

    if (result.get('hasResult')) {
      results.add(result.get('result1'));
      results.add(result.get('result2'));
      results.add(result.get('result3'));
      hasResult = true;

      await checkWin();

    } else {
      hasResult = false;
      if (kDebugMode) {
        print('result is not out yet');
      }
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> checkWin() async {
    winEntryCount = 0;

    //check entry1
    if (playedNumbers[0] == results[0] ||
        playedNumbers[0] == results[1] ||
        playedNumbers[0] == results[2]) {
      entry1Win = true;
      winEntryCount++;
    } else {
      entry1Win = false;
    }
    //check entry2
    if (playedNumbers[1] == results[0] ||
        playedNumbers[1] == results[1] ||
        playedNumbers[1] == results[2]) {
      entry2Win = true;
      winEntryCount++;
    } else {
      entry2Win = false;
    }
    //check entry3
    if (playedNumbers[2] == results[0] ||
        playedNumbers[2] == results[1] ||
        playedNumbers[2] == results[2]) {
      entry3Win = true;
      winEntryCount++;
    } else {
      entry3Win = false;
    }

    if (kDebugMode) {
      print("winEntryCount: $winEntryCount");
    }
  }

  @override
  void initState() {
    super.initState();
    checkPlayed();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Object?>> result = FirebaseFirestore.instance
        .collection('vaults')
        .doc('golden')
        .collection('dailyEntries')
        .snapshots();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      child: loading
          //loading indicator
          ? const Center(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red)),
                SizedBox(
                  width: 8,
                ),
                Text('loading...'),
              ],
            ))
          //vault entries and results
          : AnimatedOpacity(
              opacity: 1,
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.grey.withOpacity(0.2),
                        child: Column(children: [
                          //amount in vault and results
                          Expanded(
                            flex: 5,
                            child: Stack(children: [
                              Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/banners/golden_vault.jpg'),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Container(color: Colors.black.withOpacity(0.2)),
                              hasResult
                                  ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      //top space
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Expanded(child: Container()),
                                            //amount in vault
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Image.asset(
                                                        "lib/icons/naira.png",
                                                        color: Colors.white,
                                                        scale: 20,
                                                      ),
                                                      StreamBuilder<QuerySnapshot>(
                                                          stream: result,
                                                          builder: (BuildContext context,
                                                              AsyncSnapshot<QuerySnapshot>
                                                                  snapshot) {
                                                            if (snapshot.connectionState ==
                                                                ConnectionState.waiting) {
                                                              return const Text('Loading..');
                                                            }

                                                            if (snapshot.hasData) {
                                                              var col = snapshot.data!;
                                                              for (var doc in col.docs) {
                                                                if (doc.id ==
                                                                    DateFormat('yyyy-MM-dd')
                                                                        .format(DateTime.now())) {
                                                                  return Text(
                                                                    f
                                                                        .format(doc['vaultAmount'])
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 35),
                                                                  );
                                                                }
                                                              }
                                                            }
                                                            return const Text(
                                                              "0.00",
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 20),
                                                            );
                                                          }),
                                                    ],
                                                  ),
                                                  const Expanded(
                                                    child: Text(
                                                      "amount in vault",
                                                      style: TextStyle(
                                                          color: Colors.white, fontSize: 15),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            //middle space
                                            Expanded(child: Container()),
                                            //results
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      //numbers
                                                      Expanded(
                                                          flex: 4,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            children: [
                                                              //number cards
                                                              //number 1
                                                              Container(
                                                                height: 50,
                                                                width: 35,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        width: 2,
                                                                        color: Colors.white),
                                                                    borderRadius:
                                                                        BorderRadius.circular(10)),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.center,
                                                                  children: [
                                                                    const Icon(Icons.star,
                                                                        size: 10,
                                                                        color: Colors.red),
                                                                    Text(
                                                                      results[0].toString(),
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                          fontSize: 16,
                                                                          color: Colors.white),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              //number2
                                                              Container(
                                                                height: 50,
                                                                width: 35,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        width: 2,
                                                                        color: Colors.white),
                                                                    borderRadius:
                                                                        BorderRadius.circular(10)),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.center,
                                                                  children: [
                                                                    const Icon(Icons.star,
                                                                        size: 10,
                                                                        color: Colors.red),
                                                                    Text(
                                                                      results[1].toString(),
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                          fontSize: 16,
                                                                          color: Colors.white),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              //number3
                                                              Container(
                                                                height: 50,
                                                                width: 35,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        width: 2,
                                                                        color: Colors.white),
                                                                    borderRadius:
                                                                        BorderRadius.circular(10)),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.center,
                                                                  children: [
                                                                    const Icon(Icons.star,
                                                                        size: 10,
                                                                        color: Colors.red),
                                                                    Text(
                                                                      results[2].toString(),
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                          fontSize: 16,
                                                                          color: Colors.white),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ))
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  const Expanded(
                                                    child: Text(
                                                      "vault result codes",
                                                      style: TextStyle(
                                                          color: Colors.white, fontSize: 15),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            //down space
                                            Expanded(child: Container()),
                                          ],
                                        ),
                                      ),
                                    ])
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "lib/icons/naira.png",
                                              color: Colors.white,
                                              scale: 20,
                                            ),
                                            StreamBuilder<QuerySnapshot>(
                                                stream: result,
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                                  if (snapshot.connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Text('Loading..');
                                                  }

                                                  if (snapshot.hasData) {
                                                    var col = snapshot.data!;
                                                    for (var doc in col.docs) {
                                                      if (doc.id ==
                                                          DateFormat('yyyy-MM-dd')
                                                              .format(DateTime.now())) {
                                                        return Text(
                                                          f.format(doc['vaultAmount']).toString(),
                                                          style: const TextStyle(
                                                              color: Colors.white, fontSize: 35),
                                                        );
                                                      }
                                                    }
                                                  }
                                                  return const Text(
                                                    "00",
                                                    style: TextStyle(
                                                        color: Colors.white, fontSize: 20),
                                                  );
                                                }),
                                          ],
                                        ),
                                        const Text(
                                          "amount in vault",
                                          style: TextStyle(color: Colors.white, fontSize: 15),
                                        ),
                                      ],
                                    )
                            ]),
                          ),
                          //selected numbers preview
                          Expanded(
                            flex: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: winEntryCount == 0
                                      ? null
                                      : const DecorationImage(
                                          image: AssetImage(
                                            'assets/backgrounds/corner_confetti.png',
                                          ),
                                          fit: BoxFit.cover,
                                        )),
                              child: Column(
                                children: [
                                  //selected numbers
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "your crack codes entries",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Row(
                                          children: [
                                            //numbers
                                            Expanded(
                                                flex: 4,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    //number cards
                                                    //number 1
                                                    Container(
                                                      height: 50,
                                                      width: 35,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 2, color: Colors.grey),
                                                          color: entry1Win
                                                              ? Colors.red.withOpacity(0.2)
                                                              : null,
                                                          borderRadius: BorderRadius.circular(10)),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            playedNumbers[0].toString(),
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight.normal,
                                                                fontSize: 16,
                                                                color: Colors.red),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    //number2
                                                    Container(
                                                      height: 50,
                                                      width: 35,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 2, color: Colors.grey),
                                                          color: entry2Win
                                                              ? Colors.red.withOpacity(0.2)
                                                              : null,
                                                          borderRadius: BorderRadius.circular(10)),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            playedNumbers[1].toString(),
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight.normal,
                                                                fontSize: 16,
                                                                color: Colors.red),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    //number3
                                                    Container(
                                                      height: 50,
                                                      width: 35,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 2, color: Colors.grey),
                                                          color: entry3Win
                                                              ? Colors.red.withOpacity(0.2)
                                                              : null,
                                                          borderRadius: BorderRadius.circular(10)),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            playedNumbers[2].toString(),
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight.normal,
                                                                fontSize: 16,
                                                                color: Colors.red),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      "lib/icons/naira.png",
                                                      color: Colors.grey,
                                                      scale: 30,
                                                    ),
                                                    Text(
                                                      amountPlayed.toString(),
                                                      style: const TextStyle(
                                                          color: Colors.grey, fontSize: 25),
                                                    ),
                                                  ],
                                                ),
                                                const Text(
                                                  "vault break token",
                                                  style:
                                                      TextStyle(color: Colors.grey, fontSize: 10),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                              children: [
                                                Text(
                                                  'x$multiplier',
                                                  style: const TextStyle(
                                                      color: Colors.grey, fontSize: 25),
                                                ),
                                                const Text(
                                                  "multiplier",
                                                  style:
                                                      TextStyle(color: Colors.grey, fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        ElevatedButton(
                                          onPressed: winEntryCount == 0
                                              ? null
                                              : () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => ClaimVaultWin(
                                                                userDetails: userDetails,
                                                                vault: 'golden',
                                                              )));
                                                },
                                          style: ButtonStyle(
                                              backgroundColor: winEntryCount == 0
                                                  ? const MaterialStatePropertyAll(Colors.grey)
                                                  : const MaterialStatePropertyAll(Colors.red),
                                              shape:
                                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                ),
                                              )),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 12),
                                            child: Text("View Winnings"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //info text
                          Expanded(
                            flex: 2,
                            child: hasResult
                                ? Container(
                                    width: double.infinity,
                                    color: Colors.grey.withOpacity(0.2),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.info, size: 25, color: Colors.grey),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: winEntryCount == 0
                                              ? const Text(
                                                  'results are out, you have 0 winning entries',
                                                  textAlign: TextAlign.center)
                                              : Text(
                                                  'results are out, you have $winEntryCount winning entries',
                                                  textAlign: TextAlign.center),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                            winEntryCount == 0
                                                ? 'don\'t give up, try again tomorrow'
                                                : 'claim your winnings',
                                            style:
                                                const TextStyle(color: Colors.grey, fontSize: 12)),
                                      ],
                                    ),
                                  )
                                : Container(
                                    width: double.infinity,
                                    color: Colors.grey.withOpacity(0.2),
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('results are shown by 6:00pm daily'),
                                        Text('happy cracking',
                                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                                      ],
                                    ),
                                  ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
