import 'package:app/components/change_date_component.dart';
import 'package:app/utils/operation.dart';
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

  /// ****************************** current date ******************************
  late DateTime currentDate;

  @override
  void initState() {
    super.initState();

    currentDate = DateTime.now();
  }

  void _createNewOperation() {
    /* 
    * Create a new operation, after checking that the amount is not empty or 0. 
    */

    /// ***************** checks that the cause is not empty *****************
    if (_causeController.text.trim().isEmpty) {
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

    /// ******************* checks that the amount is not empty or 0 *******************
    if (_amountController.text.isEmpty || _amountController.text == "0") {
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

    /// ************************* create new operation *************************
    final newOperation = Operation(
      amount: double.parse(_amountController.text),
      type: widget.operationType,
      operationDate: currentDate,
      cause: _causeController.text.trim(),
    );

    /// ************ returns the new operation to the my_home page ************
    Navigator.pop(context, newOperation);
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      currentDate = newDate;
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
        mainAxisSize: MainAxisSize.max,
        children: [
          /// ************************** cause input **************************
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: TextField(
              autofocus: true,
              controller: _causeController,
              decoration:
                  const InputDecoration(labelText: "Cause for operation"),
            ),
          ),

          /// ************************** amount input **************************
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),

          /// ************************** date picker **************************
          ChangeDateComponent(
            initialDate: currentDate,
            onDateChanged: _onDateChanged,
          ),

          /// ************************* action buttons *************************
          Padding(
            padding: const EdgeInsets.all(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /// *********************** save button ***********************
                FilledButton(
                  onPressed: () {
                    _createNewOperation();
                  },
                  child: const Text("Save"),
                ),
                const SizedBox(width: 8),

                /// ********************** cancel button **********************
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
