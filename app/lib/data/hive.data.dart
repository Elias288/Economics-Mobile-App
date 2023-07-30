import 'package:hive_flutter/hive_flutter.dart';
import 'package:app/utils/operation.dart';

class HiveData {
  double totalAmount = 0;
  List<Operation> operationList = [];

  final _myBox = Hive.box('operationsBox');

  void loadData() {
    // load the operations list
    if (_myBox.get("operations") != null) {
      operationList = _myBox.get("operations")?.cast<Operation>() ?? [];
    }

    // load the amount
    if (_myBox.get("totalAmount") != null) {
      totalAmount = _myBox.get("totalAmount") ?? 0;
    }
  }

  void updateDataBase() {
    _myBox.put("operations", operationList);
    _myBox.put("totalAmount", totalAmount);
  }
}
