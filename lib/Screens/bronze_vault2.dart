import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paylut/models/user_model.dart';
import 'package:paylut/widgets/bronze_entry_body.dart';
import 'package:paylut/widgets/bronze_vault_result.dart';

class BronzeVault2 extends StatefulWidget {
  final UserDetails userDetails;
  const BronzeVault2({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<BronzeVault2> createState() => _BronzeVault2State(userDetails: userDetails);
}

class _BronzeVault2State extends State<BronzeVault2> with TickerProviderStateMixin {
  UserDetails userDetails;
  _BronzeVault2State({required this.userDetails});


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
        .doc('bronze')
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
              "Bronze Vault",
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
                return BronzeVaultResult(userDetails: userDetails);
              }
            }
          }

          return BronzeVaultEntry(userDetails: userDetails);
        },
      ),
    );
  }
}
