import 'package:app/utils/account.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveData {
  final _myAccountBox = Hive.box('accountsBox');
  List<Account> accountList = [];

  void loadAccounts() {
    if (_myAccountBox.get("accounts") != null) {
      accountList = _myAccountBox.get("accounts")?.cast<Account>() ?? [];
    }
  }

  void updateDataBase() {
    _myAccountBox.put("accounts", accountList);
  }
}
