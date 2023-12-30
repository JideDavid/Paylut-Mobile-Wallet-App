import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paylut/models/user_model.dart';
import '../widgets/silver_entry_body.dart';
import '../widgets/silver_vault_result.dart';

class SilverVault extends StatefulWidget {
  final UserDetails userDetails;
  const SilverVault({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<SilverVault> createState() => _SilverVaultState(userDetails: userDetails);
}

class _SilverVaultState extends State<SilverVault> {
  UserDetails userDetails;
  _SilverVaultState({required this.userDetails});


  @override
  Widget build(BuildContext context) {

    TextStyle heading = const TextStyle(
      fontWeight: FontWeight.bold,
    );
    TextStyle subHeading = const TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );

    Stream<QuerySnapshot<Object?>>? hasPlayed = FirebaseFirestore
        .instance.collection('vaults')
        .doc('silver')
        .collection('dailyEntries')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .collection('entries').snapshots();
    

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Silver Vault",
              style: heading,
            ),
            Text(
              "crack the vault codes to share the treasure",
              style: subHeading,
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert_outlined,
              ))
        ],
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: hasPlayed,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: Text('Loading...'),);
          }

          if ( snapshot.data != null )
          {
            var col = snapshot.data!;
            for (var doc in col.docs) {
              //checking if user as played
              if(doc.id == userDetails.uid){
                if(doc['completeEntry']){
                  return SilverVaultResult(userDetails: userDetails);
                }else{
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 24, width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(width: 8,),
                            Text('Processing...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        SizedBox(height: 12,),
                        Text('Please stay on screen until successful', style: TextStyle(fontSize: 12),)
                      ],
                    ),
                  );
                }
              }
            }
          }

          return SilverVaultEntry(userDetails: userDetails);
        },
      ),
    );
  }
}
