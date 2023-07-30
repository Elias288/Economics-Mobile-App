import 'package:app/utils/operation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;

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

  String formattedDate = intl.DateFormat('MM/dd/yyyy').format(DateTime.now());

  void _createNewOperation() {
    // if the amount is empty or equal to zero
    if (_amountController.text.isEmpty || _amountController.text == "0") {
      // shows the error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Amount cannot be empty or 0"),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
        padding: const EdgeInsets.fromLTRB(15, 4, 0, 4),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ));
      return;
    }

    // If the cause is empty
    if (_causeController.text.trim().isEmpty) {
      // shows the error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("The cause cannot be empty"),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
        padding: const EdgeInsets.fromLTRB(15, 4, 0, 4),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ));
      return;
    }

    final newOperation = Operation(
      amount: double.parse(_amountController.text),
      type: widget.operationType,
      operationDate: formattedDate,
      cause: _causeController.text.trim(),
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
        mainAxisSize: MainAxisSize.max,
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
              controller: _amountController,
              decoration: const InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          // date
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Row(
              children: [
                const Text("Date: "),
                Text(formattedDate),
              ],
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
