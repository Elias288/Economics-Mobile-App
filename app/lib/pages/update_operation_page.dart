import 'package:app/utils/operation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/components/change_date_component.dart';

class UpdateOperationPage extends StatefulWidget {
  final String operationTitle;
  final Operation operation;

  const UpdateOperationPage({
    Key? key,
    required this.operationTitle,
    required this.operation,
  }) : super(key: key);

  @override
  State<UpdateOperationPage> createState() => _UpdateOperationPageState();
}

class _UpdateOperationPageState extends State<UpdateOperationPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _causeController = TextEditingController();
  late DateTime updatedDate;

  @override
  void initState() {
    _amountController.text = widget.operation.amount.toString();
    _causeController.text = widget.operation.cause;
    updatedDate = widget.operation.operationDate;

    super.initState();
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      updatedDate = newDate;
    });
  }

  void _updateNewOperation() {
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
      // reset the initial value
      _amountController.text = widget.operation.amount.toString();
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
      // reset the initial value
      _causeController.text = widget.operation.cause;
      return;
    }

    // validates that the user wants to modify the operation
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Alert!!'),
        content: const Text('Are you sure you want to modify the operation?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, "Ok");
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    ).then((value) {
      // if the result of the dialog is ok
      if (value == "Ok") {
        // creates the new modified operation
        final newOperation = Operation(
          amount: double.parse(_amountController.text),
          type: widget.operation.type,
          operationDate: updatedDate,
          cause: _causeController.text.trim(),
        );

        Navigator.pop(context, newOperation);
      }
    });
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
          // date
          ChangeDateComponent(
            initialDate: updatedDate,
            onDateChanged: _onDateChanged,
          ),
          // action buttons
          Padding(
            padding: const EdgeInsets.all(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton(
                  onPressed: () {
                    _updateNewOperation();
                  },
                  child: const Text("Save"),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
