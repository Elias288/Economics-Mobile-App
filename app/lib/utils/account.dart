import 'package:app/utils/operation.dart';
import 'package:hive_flutter/hive_flutter.dart';

// generate AccountAdapter: `flutter packages pub run build_runner build`
part 'account.g.dart';

@HiveType(typeId: 0)
class Account {
  @HiveField(0)
  final String name;

  @HiveField(1)
  List<Operation> operations = [];

  @HiveField(2)
  double totalAmount;

  Account({required this.name, required this.totalAmount});
}
