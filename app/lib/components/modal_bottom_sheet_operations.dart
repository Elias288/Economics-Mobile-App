import 'package:flutter/material.dart';

import 'add_new_operation_box.dart';

class ModalBottonSheetOperations extends StatelessWidget {
  final Function onAddOperation;
  final _newOperationController = TextEditingController();

  ModalBottonSheetOperations({super.key, required this.onAddOperation});

  // CREATE A NEW OPERATION DIALOG
  _addNewWithdraw(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AddNewOperation(
          operationTitle: "a Withdraw",
          controller: _newOperationController,
          onSave: () => saveNewOperation(context, "Withdraw"),
          onCancel: () => cancelNewOperation(context),
        );
      },
    );
  }

  _addNewInsert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AddNewOperation(
          operationTitle: "an Insert",
          controller: _newOperationController,
          onSave: () => saveNewOperation(context, "Insert"),
          onCancel: () => cancelNewOperation(context),
        );
      },
    );
  }

  // SAVE NEW OPERATION
  void saveNewOperation(BuildContext context, String type) {
    // CALLBACK TO UPDATE LIST
    onAddOperation(
      double.parse(_newOperationController.text),
      type,
      "06/24/2023",
    );
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
            _addNewInsert(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.arrow_downward),
          title: const Text("Add new Withdraw"),
          onTap: () {
            Navigator.pop(context);
            _addNewWithdraw(context);
          },
        ),
      ],
    );
  }
}
