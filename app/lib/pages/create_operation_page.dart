import 'package:app/utils/operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateOperationPage extends StatefulWidget {
  final String operationTitle;
  final OperationType operationType;

  const CreateOperationPage({
    Key? key,
    required this.operationTitle,
    required this.operationType,
  }) : super(key: key);

  @override
  State<CreateOperationPage> createState() => _CreateOperationPageState();
}

class _CreateOperationPageState extends State<CreateOperationPage> {
  final _amountController = TextEditingController();
  final _causeController = TextEditingController();

  void _createNewOperation() {
    final newOperation = Operation(
      amount: double.parse(_amountController.text),
      type: widget.operationType,
      operationDate: "07/26/2023",
      cause: _causeController.text,
    );

    if (_amountController.text.isNotEmpty && _causeController.text.isNotEmpty) {
      Navigator.pop(context, newOperation);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _causeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.operationTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // cause input
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: TextField(
              autofocus: true,
              controller: _causeController,
              decoration:
                  const InputDecoration(labelText: "Cause for operation"),
            ),
          ),
          // amount input
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: TextField(
              autofocus: true,
              controller: _amountController,
              decoration: const InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          // action buttons
          Padding(
            padding: const EdgeInsets.all(30),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                MaterialButton(
                  onPressed: () {
                    _createNewOperation();
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
