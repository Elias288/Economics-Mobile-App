import 'package:hive_flutter/hive_flutter.dart';

// generate OperationAdapter: `flutter packages pub run build_runner build`
part 'operation.g.dart';

@HiveType(typeId: 1)
class Operation {
  @HiveField(0)
  final double amount;

  @HiveField(1)
  final OperationType type;

  @HiveField(2)
  final DateTime operationDate;

  @HiveField(3)
  final String cause;

  Operation({
    required this.amount,
    required this.type,
    required this.operationDate,
    required this.cause,
  });
}

@HiveType(typeId: 2)
enum OperationType {
  @HiveField(0)
  withdraw,

  @HiveField(1)
  insert,
}
