import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:intl/intl.dart';
import 'package:paylut/models/winners_model.dart';
import 'package:paylut/widgets/number_preview_card.dart';

class VaultWinners extends StatefulWidget {
  final DateTime date;
  const VaultWinners({super.key, required this.date});

  @override
  // ignore: no_logic_in_create_state
  State<VaultWinners> createState() => _VaultWinnersState(date: date);
}

class _VaultWinnersState extends State<VaultWinners> {
  DateTime date;
  _VaultWinnersState({required this.date});

  var f = NumberFormat("##,###,###", "en_US");
  List<Winners> winners = [];
  bool loading = false;
  bool loadResults = false;
  List<int> bronzeResults = [];
  List<int> silverResults = [];
  List<int> goldenResults = [];

  Future<void> getResults() async{

    setState(() {
      loadResults = false;
    });

    bronzeResults = [];
    silverResults = [];
    goldenResults = [];


    //getting bronze results
    DocumentSnapshot bronzeSnapshot = await FirebaseFirestore.instance.collection('vaults').doc('bronze')
        .collection('dailyEntries').doc(DateFormat('yyyy-MM-dd').format(date)).get();
    if(bronzeSnapshot.exists){
      bronzeResults.add(bronzeSnapshot.get('result1'));
      bronzeResults.add(bronzeSnapshot.get('result2'));
      bronzeResults.add(bronzeSnapshot.get('result3'));
      bronzeResults.add(bronzeSnapshot.get('result4'));
      bronzeResults.add(bronzeSnapshot.get('result5'));
      bronzeResults.add(bronzeSnapshot.get('result6'));
      bronzeResults.add(bronzeSnapshot.get('result7'));
    }else{
      if(kDebugMode){
        print('Bronze vault does not have result yet');
      }
    }

    //getting silver results
    DocumentSnapshot silverSnapshot = await FirebaseFirestore.instance.collection('vaults').doc('silver')
        .collection('dailyEntries').doc(DateFormat('yyyy-MM-dd').format(date)).get();
    if(silverSnapshot.exists){
      silverResults.add(silverSnapshot.get('result1'));
      silverResults.add(silverSnapshot.get('result2'));
      silverResults.add(silverSnapshot.get('result3'));
      silverResults.add(silverSnapshot.get('result4'));
      silverResults.add(silverSnapshot.get('result5'));
    }else{
      if(kDebugMode){
        print('Silver vault does not have result yet');
      }
    }

    //getting golden results
    DocumentSnapshot goldenSnapshot = await FirebaseFirestore.instance.collection('vaults').doc('golden')
        .collection('dailyEntries').doc(DateFormat('yyyy-MM-dd').format(date)).get();
    if(goldenSnapshot.exists){
      goldenResults.add(goldenSnapshot.get('result1'));
      goldenResults.add(goldenSnapshot.get('result2'));
      goldenResults.add(goldenSnapshot.get('result3'));
    }else{
      if(kDebugMode){
        print('Golden vault does not have result yet');
      }
    }

    setState(() {
      loadResults = true;
    });
  }

  Future<void> getWinners() async{

    winners = [];

    if(mounted){
      setState(() {
        loading = true;
      });
    }
    //getting winning claims

    //bronze
    QuerySnapshot bronzeSnapshot = await FirebaseFirestore.instance
        .collection('vaults')
        .doc('bronze')
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(date))
        .collection('claims')
        .get();

    if(bronzeSnapshot.docs.isEmpty){
      if(kDebugMode){
        print('no bronze winning claims yet');
      }
    }else{
      var winningClaims = bronzeSnapshot.docs;
      for (var winningClaim in winningClaims){
        winners.add(Winners.fromJson(winningClaim));
      }
      if(kDebugMode){
        print('gotten all bronze winners');
      }
    }

    //silver
    QuerySnapshot silverSnapshot = await FirebaseFirestore.instance
        .collection('vaults')
        .doc('silver')
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(date))
        .collection('claims')
        .get();

    if(silverSnapshot.docs.isEmpty){
      if(kDebugMode){
        print('no silver winning claims yet');
      }
    }else{
      var winningClaims = silverSnapshot.docs;
      for (var winningClaim in winningClaims){
        winners.add(Winners.fromJson(winningClaim));
      }
      if(kDebugMode){
        print('gotten all silver winners');
      }
    }

    //golden
    QuerySnapshot goldenSnapshot = await FirebaseFirestore.instance
        .collection('vaults')
        .doc('golden')
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(date))
        .collection('claims')
        .get();

    if(goldenSnapshot.docs.isEmpty){
      if(kDebugMode){
        print('no golden winning claims yet');
      }
    }else{
      var winningClaims = goldenSnapshot.docs;
      for (var winningClaim in winningClaims){
        winners.add(Winners.fromJson(winningClaim));
      }
      if(kDebugMode){
        print('gotten all golden winners');
      }
    }

    winners.sort((a, b) => a.date.compareTo(b.date));


    if(mounted){
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getResults();
    getWinners();
  }


  @override
  Widget build(BuildContext context) {


    TextStyle heading = const TextStyle( fontWeight: FontWeight.bold,);
    //TextStyle subHeading = const TextStyle( fontWeight: FontWeight.normal, fontSize: 12,);

    Widget bronzeVault = Container(
        height: 100, width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('bronze results', style: TextStyle(fontSize: 10, color: Colors.white),),
            const SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NumPrev(vaultResults: bronzeResults, index: 0),
                const SizedBox(width: 4,),
                NumPrev(vaultResults: bronzeResults, index: 1),
                const SizedBox(width: 4,),
                NumPrev(vaultResults: bronzeResults, index: 2),
                const SizedBox(width: 4,),
                NumPrev(vaultResults: bronzeResults, index: 3),
                const SizedBox(width: 4,),
                NumPrev(vaultResults: bronzeResults, index: 4),
                const SizedBox(width: 4,),
                NumPrev(vaultResults: bronzeResults, index: 5),
                const SizedBox(width: 4,),
                NumPrev(vaultResults: bronzeResults, index: 6),
              ],
            )
          ],
        ));
    Widget silverVault = Container(
        height: 100, width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('silver results', style: TextStyle(fontSize: 10, color: Colors.white),),
            const SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NumPrev(vaultResults: silverResults, index: 0),
                const SizedBox(width: 4,),
                NumPrev(vaultResults: silverResults, index: 1),
                const SizedBox(width: 4,),
                NumPrev(vaultResults: silverResults, index: 2),
                const SizedBox(width: 4,),
                NumPrev(vaultResults: silverResults, index: 3),
                const SizedBox(width: 4,),
                NumPrev(vaultResults: silverResults, index: 4),
              ],
            )
          ],
        ));
    Widget goldenVault = Container(
        height: 100, width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('golden results', style: TextStyle(fontSize: 10, color: Colors.white),),
            const SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NumPrev(vaultResults: goldenResults, index: 0),
                const SizedBox(width: 4,),
                NumPrev(vaultResults: goldenResults, index: 1),
                const SizedBox(width: 4,),
                NumPrev(vaultResults: goldenResults, index: 2),
              ],
            )
          ],
        ));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Vault Break Winners", style: heading,),
            //Text("Result details ", style: subHeading,)
          ],
        ),
        actions: [
          IconButton(
              onPressed: (){},
              icon: const Icon(Icons.history,))
        ],
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0),
      ),
      body: loading ? const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 15, width: 15,
              child: CircularProgressIndicator(
                strokeWidth: 2, color: Colors.red,
              ),
            ),
            SizedBox(width: 8,),
            Text('Loading...')
          ],
        ),
      )
      : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            //vault results preview
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 150, width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.9),
                    // image: const DecorationImage(
                    //     image: AssetImage('assets/backgrounds/gold_coins2.png'),
                    // fit: BoxFit.cover)
                  ),
                  child: Swiper(
                    itemCount: 3,
                      pagination: const SwiperPagination(
                      ),
                      autoplay: true,
                      itemBuilder: (BuildContext context, int index){
                        return index == 1 ? bronzeVault
                        : index == 2 ? silverVault
                        : goldenVault;
                      }
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8,),
            //date
            Text(DateFormat('EEE, yyyy-MM-dd').format(date),
              style: const TextStyle(color: Colors.grey, fontSize: 12),),
            const Icon(Icons.arrow_drop_down_sharp, color: Colors.red,),
            //winners
            Expanded(
              child: winners.isEmpty ?  const Center(
                      child: Text('No claims yet')
              )

              : ListView.builder(
                  itemCount: winners.length,
                  itemBuilder: (context, index){
                return Padding(
                  padding: EdgeInsets.fromLTRB(0, 12, 0, index == winners.length - 1 ? 12 : 0),
                  child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: winners[index].vault == 'bronze' ?
                    (Colors.red.withOpacity(0.5))
                      : winners[index].vault == 'silver' ?
                    (Colors.grey.withOpacity(0.5))
                      : (Colors.orange.withOpacity(0.5)),
                    image: const DecorationImage(image: AssetImage('assets/backgrounds/wave_pattern.png'),
                    fit: BoxFit.cover, opacity: 0.6)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.black.withOpacity(0.8),
                          child: Image.asset(
                            winners[index].vault == 'bronze' ? 'lib/icons/bronze_star.png'
                            : winners[index].vault == 'silver' ? 'lib/icons/silver_star.png'
                            : 'lib/icons/golden_star.png', width: 50,),
                        ),
                        const Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Image.asset('lib/icons/naira.png', color: Colors.grey, height: 20, ),
                                Text(f.format(winners[index].amountClaimed), style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold,),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Text('NGN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,),)
                              ],
                            ),
                            const Text('Claimed by:', style: TextStyle(fontSize: 10),),
                            Text(winners[index].name, style:  const TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 15),),
                            Text(GetTimeAgo.parse(winners[index].date.toDate()).toString(),
                              style: const TextStyle(fontSize: 10),),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            const Text('WINNING\nENTRY\nCOUNT', overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900),),
                            const SizedBox(height: 8,),
                            Container(
                              height: 50, width: 40,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black.withOpacity(0.6)
                              ),
                              child: Center(
                                child: Text(winners[index].winningEntryCount.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white
                                  ),),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                    ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
