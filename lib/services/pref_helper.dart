import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper{

  void setBalanceVisibility(bool value) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('balanceVisibility', value);
  }

  Future<bool?> getBalanceVisibility() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('balanceVisibility') == null ){
      return true;
    }else{
      return prefs.getBool('balanceVisibility');
    }
  }

}