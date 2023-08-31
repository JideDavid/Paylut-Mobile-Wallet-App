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

  void setLastWalletAction(int value) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('walletAction', value);
  }

  Future<int?> getLastWalletAction() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getInt('walletAction') == null ){
      return 1;
    }else{
      return prefs.getInt('walletAction');
    }
  }

}