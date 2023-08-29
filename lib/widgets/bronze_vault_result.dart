import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paylut/models/user_model.dart';

class BronzeVaultResult extends StatefulWidget {
  final UserDetails userDetails;
  const BronzeVaultResult({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<BronzeVaultResult> createState() => _BronzeVaultResultState(userDetails: userDetails);
}

class _BronzeVaultResultState extends State<BronzeVaultResult> {
  UserDetails userDetails;
  _BronzeVaultResultState({required this.userDetails});

  bool hasResult = false;
  int playedNumber1 = 0;
  int playedNumber2 = 0;
  int playedNumber3 = 0;
  int playedNumber4 = 0;
  int playedNumber5 = 0;
  int playedNumber6 = 0;
  int playedNumber7 = 0;
  int amountPlayed = 0;
  bool entry1Win = false;
  bool entry2Win = false;
  bool entry3Win = false;
  bool entry4Win = false;
  bool entry5Win = false;
  bool entry6Win = false;
  bool entry7Win = false;
  int winEntryCount = 0;
  int vaultAmount = 1000000;
  bool loading = false;

  //function to check if player has made any entry
  Future<void> checkPlayed() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('vaults')
        .doc('bronze')
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .collection('entries')
        .doc(userDetails.uid)
        .get();

    playedNumber1 = snapshot.get('entry1');
    playedNumber2 = snapshot.get('entry2');
    playedNumber3 = snapshot.get('entry3');
    playedNumber4 = snapshot.get('entry4');
    playedNumber5 = snapshot.get('entry5');
    playedNumber6 = snapshot.get('entry6');
    playedNumber7 = snapshot.get('entry7');
    amountPlayed = snapshot.get('amount');

    DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('vaults')
        .doc('bronze')
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .get();

    if(result.get('hasResult')){
      await checkWin();
    }


    if (mounted) {
      setState(() {});
    }
  }

  Future<void> checkWin() async {
    String now = DateFormat('yyyy-MM-dd').format(DateTime.now());

    winEntryCount = 0;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('vaults')
        .doc('bronze')
        .collection('dailyEntries')
        .doc(now)
        .get();

    //check entry1
    if (playedNumber1 == snapshot['result1'] ||
        playedNumber1 == snapshot['result2'] ||
        playedNumber1 == snapshot['result3'] ||
        playedNumber1 == snapshot['result4'] ||
        playedNumber1 == snapshot['result5'] ||
        playedNumber1 == snapshot['result6'] ||
        playedNumber1 == snapshot['result7']) {
      entry1Win = true;
      winEntryCount++;
    } else {
      entry1Win = false;
    }
    //check entry2
    if (playedNumber2 == snapshot['result1'] ||
        playedNumber2 == snapshot['result2'] ||
        playedNumber2 == snapshot['result3'] ||
        playedNumber2 == snapshot['result4'] ||
        playedNumber2 == snapshot['result5'] ||
        playedNumber2 == snapshot['result6'] ||
        playedNumber2 == snapshot['result7']) {
      entry2Win = true;
      winEntryCount++;
    } else {
      entry2Win = false;
    }
    //check entry3
    if (playedNumber3 == snapshot['result1'] ||
        playedNumber3 == snapshot['result2'] ||
        playedNumber3 == snapshot['result3'] ||
        playedNumber3 == snapshot['result4'] ||
        playedNumber3 == snapshot['result5'] ||
        playedNumber3 == snapshot['result6'] ||
        playedNumber3 == snapshot['result7']) {
      entry3Win = true;
      winEntryCount++;
    } else {
      entry3Win = false;
    }
    //check entry4
    if (playedNumber4 == snapshot['result1'] ||
        playedNumber4 == snapshot['result2'] ||
        playedNumber4 == snapshot['result3'] ||
        playedNumber4 == snapshot['result4'] ||
        playedNumber4 == snapshot['result5'] ||
        playedNumber4 == snapshot['result6'] ||
        playedNumber4 == snapshot['result7']) {
      entry4Win = true;
      winEntryCount++;
    } else {
      entry4Win = false;
    }
    //check entry5
    if (playedNumber5 == snapshot['result1'] ||
        playedNumber5 == snapshot['result2'] ||
        playedNumber5 == snapshot['result3'] ||
        playedNumber5 == snapshot['result4'] ||
        playedNumber5 == snapshot['result5'] ||
        playedNumber5 == snapshot['result6'] ||
        playedNumber5 == snapshot['result7']) {
      entry5Win = true;
      winEntryCount++;
    } else {
      entry5Win = false;
    }
    //check entry6
    if (playedNumber6 == snapshot['result1'] ||
        playedNumber6 == snapshot['result2'] ||
        playedNumber6 == snapshot['result3'] ||
        playedNumber6 == snapshot['result4'] ||
        playedNumber6 == snapshot['result5'] ||
        playedNumber6 == snapshot['result6'] ||
        playedNumber6 == snapshot['result7']) {
      entry6Win = true;
      winEntryCount++;
    } else {
      entry6Win = false;
    }
    //check entry7
    if (playedNumber7 == snapshot['result1'] ||
        playedNumber7 == snapshot['result2'] ||
        playedNumber7 == snapshot['result3'] ||
        playedNumber7 == snapshot['result4'] ||
        playedNumber7 == snapshot['result5'] ||
        playedNumber7 == snapshot['result6'] ||
        playedNumber7 == snapshot['result7']) {
      entry7Win = true;
      winEntryCount++;
    } else {
      entry7Win = false;
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
        .doc('bronze')
        .collection('dailyEntries')
        .snapshots();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      child: loading
          ? const Center(child: Text('loading...'))
          : Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.grey.withOpacity(0.2),
                      child: Column(
                        children: [
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
                              Container(color: Colors.black.withOpacity(0.4)),
                              //amount in vault and result
                              StreamBuilder<QuerySnapshot>(
                                  stream: result,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(
                                          child: Text('Loading..',
                                              style: TextStyle(color: Colors.white)));
                                    }
                                    if (snapshot.data != null) {
                                      var col = snapshot.data!;
                                      for (var doc in col.docs) {
                                        String dateFormat =
                                            DateFormat('yyyy-MM-dd').format(DateTime.now());
                                        if (doc.id == dateFormat) {
                                          if (doc['hasResult']) {
                                            return Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  //top space
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Expanded(child: Container()),
                                                        //amount in vault
                                                        Expanded(
                                                          flex: 2,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment.center,
                                                                children: [
                                                                  Image.asset(
                                                                    "lib/icons/naira.png",
                                                                    color: Colors.white,
                                                                    scale: 20,
                                                                  ),
                                                                  StreamBuilder<QuerySnapshot>(
                                                                      stream: FirebaseFirestore.instance
                                                                          .collection('vaults')
                                                                          .doc('bronze')
                                                                          .collection('dailyEntries')
                                                                          .snapshots(),
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
                                                                                doc['vaultAmount'].toString(),
                                                                                style: const TextStyle(
                                                                                    color: Colors.white, fontSize: 35),
                                                                              );
                                                                            }
                                                                          }
                                                                        }
                                                                        return const Text(
                                                                          "00",
                                                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                                                        );
                                                                      }),
                                                                ],
                                                              ),
                                                              const Expanded(
                                                                child: Text(
                                                                  "amount in vault",
                                                                  style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 15),
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
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  //numbers
                                                                  Expanded(
                                                                      flex: 4,
                                                                      child: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .center,
                                                                        children: [
                                                                          //number cards
                                                                          //number 1
                                                                          Container(
                                                                            height: 50,
                                                                            width: 35,
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(
                                                                                    width: 2,
                                                                                    color: Colors
                                                                                        .white),
                                                                                borderRadius:
                                                                                    BorderRadius
                                                                                        .circular(
                                                                                            10)),
                                                                            child: Column(
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment
                                                                                      .center,
                                                                              children: [
                                                                                const Icon(
                                                                                    Icons.star,
                                                                                    size: 10,
                                                                                    color:
                                                                                        Colors.red),
                                                                                Text(
                                                                                  doc['result1']
                                                                                      .toString(),
                                                                                  style: const TextStyle(
                                                                                      fontWeight:
                                                                                          FontWeight
                                                                                              .normal,
                                                                                      fontSize: 16,
                                                                                      color: Colors
                                                                                          .white),
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
                                                                                    color: Colors
                                                                                        .white),
                                                                                borderRadius:
                                                                                    BorderRadius
                                                                                        .circular(
                                                                                            10)),
                                                                            child: Column(
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment
                                                                                      .center,
                                                                              children: [
                                                                                const Icon(
                                                                                    Icons.star,
                                                                                    size: 10,
                                                                                    color:
                                                                                        Colors.red),
                                                                                Text(
                                                                                  doc['result2']
                                                                                      .toString(),
                                                                                  style: const TextStyle(
                                                                                      fontWeight:
                                                                                          FontWeight
                                                                                              .normal,
                                                                                      fontSize: 16,
                                                                                      color: Colors
                                                                                          .white),
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
                                                                                    color: Colors
                                                                                        .white),
                                                                                borderRadius:
                                                                                    BorderRadius
                                                                                        .circular(
                                                                                            10)),
                                                                            child: Column(
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment
                                                                                      .center,
                                                                              children: [
                                                                                const Icon(
                                                                                    Icons.star,
                                                                                    size: 10,
                                                                                    color:
                                                                                        Colors.red),
                                                                                Text(
                                                                                  doc['result3']
                                                                                      .toString(),
                                                                                  style: const TextStyle(
                                                                                      fontWeight:
                                                                                          FontWeight
                                                                                              .normal,
                                                                                      fontSize: 16,
                                                                                      color: Colors
                                                                                          .white),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width: 8,
                                                                          ),
                                                                          //number4
                                                                          Container(
                                                                            height: 50,
                                                                            width: 35,
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(
                                                                                    width: 2,
                                                                                    color: Colors
                                                                                        .white),
                                                                                borderRadius:
                                                                                    BorderRadius
                                                                                        .circular(
                                                                                            10)),
                                                                            child: Column(
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment
                                                                                      .center,
                                                                              children: [
                                                                                const Icon(
                                                                                    Icons.star,
                                                                                    size: 10,
                                                                                    color:
                                                                                        Colors.red),
                                                                                Text(
                                                                                  doc['result4']
                                                                                      .toString(),
                                                                                  style: const TextStyle(
                                                                                      fontWeight:
                                                                                          FontWeight
                                                                                              .normal,
                                                                                      fontSize: 16,
                                                                                      color: Colors
                                                                                          .white),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width: 8,
                                                                          ),
                                                                          //number5
                                                                          Container(
                                                                            height: 50,
                                                                            width: 35,
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(
                                                                                    width: 2,
                                                                                    color: Colors
                                                                                        .white),
                                                                                borderRadius:
                                                                                    BorderRadius
                                                                                        .circular(
                                                                                            10)),
                                                                            child: Column(
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment
                                                                                      .center,
                                                                              children: [
                                                                                const Icon(
                                                                                    Icons.star,
                                                                                    size: 10,
                                                                                    color:
                                                                                        Colors.red),
                                                                                Text(
                                                                                  doc['result5']
                                                                                      .toString(),
                                                                                  style: const TextStyle(
                                                                                      fontWeight:
                                                                                          FontWeight
                                                                                              .normal,
                                                                                      fontSize: 16,
                                                                                      color: Colors
                                                                                          .white),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width: 8,
                                                                          ),
                                                                          //number6
                                                                          Container(
                                                                            height: 50,
                                                                            width: 35,
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(
                                                                                    width: 2,
                                                                                    color: Colors
                                                                                        .white),
                                                                                borderRadius:
                                                                                    BorderRadius
                                                                                        .circular(
                                                                                            10)),
                                                                            child: Column(
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment
                                                                                      .center,
                                                                              children: [
                                                                                const Icon(
                                                                                    Icons.star,
                                                                                    size: 10,
                                                                                    color:
                                                                                        Colors.red),
                                                                                Text(
                                                                                  doc['result6']
                                                                                      .toString(),
                                                                                  style: const TextStyle(
                                                                                      fontWeight:
                                                                                          FontWeight
                                                                                              .normal,
                                                                                      fontSize: 16,
                                                                                      color: Colors
                                                                                          .white),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width: 8,
                                                                          ),
                                                                          //number7
                                                                          Container(
                                                                            height: 50,
                                                                            width: 35,
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(
                                                                                    width: 2,
                                                                                    color: Colors
                                                                                        .white),
                                                                                borderRadius:
                                                                                    BorderRadius
                                                                                        .circular(
                                                                                            10)),
                                                                            child: Column(
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment
                                                                                      .center,
                                                                              children: [
                                                                                const Icon(
                                                                                    Icons.star,
                                                                                    size: 10,
                                                                                    color:
                                                                                        Colors.red),
                                                                                Text(
                                                                                  doc['result7']
                                                                                      .toString(),
                                                                                  style: const TextStyle(
                                                                                      fontWeight:
                                                                                          FontWeight
                                                                                              .normal,
                                                                                      fontSize: 16,
                                                                                      color: Colors
                                                                                          .white),
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
                                                                      color: Colors.white,
                                                                      fontSize: 15),
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
                                                ]);
                                          } else {
                                            return Column(
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
                                                        stream: FirebaseFirestore.instance
                                                            .collection('vaults')
                                                            .doc('bronze')
                                                            .collection('dailyEntries')
                                                            .snapshots(),
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
                                                                  doc['vaultAmount'].toString(),
                                                                  style: const TextStyle(
                                                                      color: Colors.white, fontSize: 35),
                                                                );
                                                              }
                                                            }
                                                          }
                                                          return const Text(
                                                            "00",
                                                            style: TextStyle(color: Colors.white, fontSize: 20),
                                                          );
                                                        }),
                                                  ],
                                                ),
                                                const Text(
                                                  "amount in vault",
                                                  style:
                                                      TextStyle(color: Colors.white, fontSize: 15),
                                                ),
                                              ],
                                            );
                                          }
                                        }
                                      }
                                    }

                                    //amount in vault only,
                                    return Column(
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
                                                stream: FirebaseFirestore.instance
                                                    .collection('vaults')
                                                    .doc('bronze')
                                                    .collection('dailyEntries')
                                                    .snapshots(),
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
                                                          doc['vaultAmount'].toString(),
                                                          style: const TextStyle(
                                                              color: Colors.white, fontSize: 35),
                                                        );
                                                      }
                                                    }
                                                  }
                                                  return const Text(
                                                    "00",
                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                  );
                                                }),
                                          ],
                                        ),
                                        const Text(
                                          "amount in vault",
                                          style: TextStyle(color: Colors.white, fontSize: 15),
                                        ),
                                      ],
                                    );
                                  }),
                            ]),
                          ),
                          //selected numbers preview
                          Expanded(
                            flex: 5,
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
                                        style: TextStyle(color: Colors.red),
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
                                                        color: entry1Win ? Colors.red.withOpacity(0.2) : null,
                                                        borderRadius: BorderRadius.circular(10)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          playedNumber1.toString(),
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
                                                        color: entry2Win ? Colors.red.withOpacity(0.2) : null,
                                                        borderRadius: BorderRadius.circular(10)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          playedNumber2.toString(),
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
                                                        color: entry3Win ? Colors.red.withOpacity(0.2) : null,
                                                        borderRadius: BorderRadius.circular(10)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          playedNumber3.toString(),
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
                                                  //number4
                                                  Container(
                                                    height: 50,
                                                    width: 35,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 2, color: Colors.grey),
                                                        color: entry4Win ? Colors.red.withOpacity(0.2) : null,
                                                        borderRadius: BorderRadius.circular(10)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          playedNumber4.toString(),
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
                                                  //number5
                                                  Container(
                                                    height: 50,
                                                    width: 35,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 2, color: Colors.grey),
                                                        color: entry5Win ? Colors.red.withOpacity(0.2) : null,
                                                        borderRadius: BorderRadius.circular(10)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          playedNumber5.toString(),
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
                                                  //number6
                                                  Container(
                                                    height: 50,
                                                    width: 35,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 2, color: Colors.grey),
                                                        color: entry6Win ? Colors.red.withOpacity(0.2) : null,
                                                        borderRadius: BorderRadius.circular(10)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          playedNumber6.toString(),
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
                                                  //number7
                                                  Container(
                                                    height: 50,
                                                    width: 35,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 2, color: Colors.grey),
                                                        color: entry7Win ? Colors.red.withOpacity(0.2) : null,
                                                        borderRadius: BorderRadius.circular(10)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          playedNumber7.toString(),
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
                                          Image.asset(
                                            "lib/icons/naira.png",
                                            color: Colors.grey,
                                            scale: 30,
                                          ),
                                          Text(
                                            amountPlayed.toString(),
                                            style:
                                                const TextStyle(color: Colors.grey, fontSize: 25),
                                          ),
                                        ],
                                      ),
                                      const Text(
                                        "vault break token",
                                        style: TextStyle(color: Colors.grey, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                                //claim button
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: winEntryCount == 0 ? null : () {},
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
                                          child: Text("Claim Wins"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //info text
                          Expanded(
                              flex: 2,
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: result,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {

                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(
                                          child: Text('Loading..',
                                              style: TextStyle(color: Colors.white)));
                                    }

                                    if (snapshot.hasData){
                                      var col = snapshot.data!;
                                      for(var doc in col.docs){
                                        if(doc.id == DateFormat('yyyy-MM-dd').format(DateTime.now())){
                                          if(doc['hasResult']){
                                            return Container(
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
                                                      style: const TextStyle(
                                                          color: Colors.grey, fontSize: 12)),
                                                ],
                                              ),
                                            );
                                          }else{
                                            return Container(
                                              width: double.infinity,
                                              color: Colors.grey.withOpacity(0.2),
                                              child: const Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('results are shown by 6:00pm daily'),
                                                  Text('happy cracking',
                                                      style:
                                                      TextStyle(color: Colors.grey, fontSize: 12)),
                                                ],
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    }

                                    return Container(
                                      width: double.infinity,
                                      color: Colors.grey.withOpacity(0.2),
                                      child: const Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('results are shown by 6:00pm daily'),
                                          Text('happy cracking',
                                              style:
                                              TextStyle(color: Colors.grey, fontSize: 12)),
                                        ],
                                      ),
                                    );

                                  }))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
