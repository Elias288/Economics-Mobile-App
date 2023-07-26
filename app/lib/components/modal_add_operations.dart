import 'package:app/utils/operations.dart';
import 'package:flutter/material.dart';

class ModalAddOperations extends StatelessWidget {
  const ModalAddOperations({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.arrow_upward),
          title: const Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: Text("Add new Insert"),
          ),
          onTap: () => Navigator.pop(context, OperationType.insert),
        ),
        ListTile(
          leading: const Icon(Icons.arrow_downward),
          title: const Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: Text("Add new Withdraw"),
          ),
          onTap: () => Navigator.pop(context, OperationType.withdraw),
        ),
      ],
    );
  }
}
