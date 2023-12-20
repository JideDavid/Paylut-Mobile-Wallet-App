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

  void setAppIsFresh(bool value) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFresh', value);
  }

  Future<bool?> getAppIsFresh() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('isFresh') == null ){
      return true;
    }else{
      return prefs.getBool('isFresh');
    }

  }

  void setAppThemeMode(bool value) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('themeMode', value);
  }

  Future<bool?> getAppThemeMode() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('themeMode') == null ){
      return true;
    }else{
      return prefs.getBool('themeMode');
    }
  }

}