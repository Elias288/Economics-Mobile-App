import 'package:app/utils/operations.dart';
import 'package:flutter/material.dart';

import 'add_new_operation_box.dart';

class ModalBottonSheetOperations extends StatelessWidget {
  final Function onAddOperation;
  final _newOperationController = TextEditingController();

  ModalBottonSheetOperations({super.key, required this.onAddOperation});

  // CREATE A NEW OPERATION DIALOG
  _addNewOperation(BuildContext context, String type) {
    String msg = type == "Insert" ? "an Insert" : "a Withdraw";

    showDialog(
      context: context,
      builder: (context) {
        return AddNewOperation(
          operationTitle: msg,
          controller: _newOperationController,
          onSave: () => saveNewOperation(context, type),
          onCancel: () => cancelNewOperation(context),
        );
      },
    );
  }

  // SAVE NEW OPERATION
  void saveNewOperation(BuildContext context, String type) {
    Operations op = Operations(
      amount: double.parse(_newOperationController.text),
      type: type,
      operationDate: "06/24/2023",
    );

    // CALLBACK TO UPDATE LIST
    onAddOperation(op);

    _newOperationController.clear();
    Navigator.of(context).pop();
  }

  // CANCEL NEW OPERATION
  void cancelNewOperation(BuildContext context) {
    _newOperationController.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.arrow_upward),
          title: const Text("Add new Insert"),
          onTap: () {
            Navigator.pop(context);
            _addNewOperation(context, "Insert");
          },
        ),
        ListTile(
          leading: const Icon(Icons.arrow_downward),
          title: const Text("Add new Withdraw"),
          onTap: () {
            Navigator.pop(context);
            _addNewOperation(context, "Withdraw");
          },
        ),
      ],
    );
  }
}
