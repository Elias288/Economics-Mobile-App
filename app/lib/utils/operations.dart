enum OperationType { withdraw, insert }

class Operation {
  final double amount;
  final OperationType type;
  final String operationDate;
  final String cause;

  Operation({
    required this.amount,
    required this.type,
    required this.operationDate,
    required this.cause,
  });
}
