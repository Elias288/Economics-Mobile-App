// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class AddNewOperation extends StatelessWidget {
  final controller;
  final String operationTitle;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const AddNewOperation({
    super.key,
    this.controller,
    required this.onSave,
    required this.onCancel,
    required this.operationTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add $operationTitle"),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: "Amount"),
      ),
      actions: [
        MaterialButton(
          onPressed: onSave,
          child: const Text("Save"),
        ),
        MaterialButton(
          onPressed: onCancel,
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
