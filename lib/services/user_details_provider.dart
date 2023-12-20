import 'package:flutter/material.dart';

class UserDetailsProvider extends ChangeNotifier{

  String user = 'joy';

  changeName(String newName){
    user = newName;
    notifyListeners();
  }
}