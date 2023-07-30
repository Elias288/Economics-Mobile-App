import 'package:app/pages/update_operation_page.dart';
import 'package:app/utils/operation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class InfoCard extends StatelessWidget {
  // get the operation info
  final Operation operation;
  final int index;
  final Function onUpdateOperation;

  // function to remove operation
  final Function onRemoveOperation;

  final ValueNotifier<OperationType> _selectedType =
      ValueNotifier(OperationType.insert);

  InfoCard({
    super.key,
    required this.operation,
    required this.onRemoveOperation,
    required this.onUpdateOperation,
    required this.index,
  });

  void _updateOperation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateOperationPage(
          operationTitle: "Update the operation",
          operation: operation,
        ),
      ),
    ).then((value) {
      if (value != null) {
        onUpdateOperation(index, value, operation);
      }
    });
  }

  void _deleteOperation(context) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Alert!!'),
        content: const Text('Are you sure you want to remove the operation?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onRemoveOperation(index);
              Navigator.pop(context);
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _selectedType.value = operation.type;

    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          // edit operation
          SlidableAction(
            onPressed: (context) => _updateOperation(context),
            icon: Icons.edit,
            backgroundColor: Colors.blue.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          // delete operation
          SlidableAction(
            onPressed: _deleteOperation,
            icon: Icons.delete,
            backgroundColor: Colors.red.shade400,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    operation.cause,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(operation.operationDate),
                ],
              ),
              Text(
                operation.type == OperationType.withdraw
                    ? "-\$${operation.amount.toString()}"
                    : "\$${operation.amount.toString()}",
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
