import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NotifyMessage{

  Future<void> notify(String userID, String title, String body) async{

    String userToken = '';

    await Future.delayed(const Duration(seconds: 5));

    //get target device token
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users')
    .doc(userID).get();
    if(snapshot.exists){
      if(snapshot.get('fCMToken') != null){
        userToken = snapshot.get('fCMToken');
        if(kDebugMode){
          print('got target user token: $userToken');
        }
      }else{
        if(kDebugMode){
          print('user doesn\'t have a token registered');
        }
      }
    }else{
      if (kDebugMode) {
        print('user does not exist on database');
      }
    }

    try {
      await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          "Host": "fcm.googleapis.com",
          "Authorization": "key=AAAA2wR25w8:APA91bF73ieRiMBueRQZ4aJuFUyFWCB22WXweAuTR88RcU5p62CBr5JxalChOQfmRNIyfvIeESc6eDTxQ2cTe3qvtzSKBdcidqBGBDQvPfi0tQxhuqW1RFuiuT4gV-sYskGlkmGHHLtj",
          "Content-Type": "application/json",
        },
        body: jsonEncode(
            <String, dynamic>{
              'priority': 'high',
              'notification': <String, dynamic>{
                'body': body,
                'title': title
              },
              'to': userToken,
            }
        ),
      );
      if (kDebugMode) {
        print('FCM request for device sent!');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

}