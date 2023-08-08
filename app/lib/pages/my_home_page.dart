import 'package:app/components/modal_add_operations.dart';
import 'package:app/components/operation_card.dart';
import 'package:app/pages/create_operation_page.dart';
import 'package:app/utils/account.dart';
import 'package:app/utils/operation.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  // selected Account
  final Account selectedAccount;
  final int index;
  final Function onUpdateAccountData;

  const MyHomePage({
    super.key,
    required this.selectedAccount,
    required this.onUpdateAccountData,
    required this.index,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Operation> operationList = [];
  double totalAmount = 0;

  @override
  void initState() {
    super.initState();

    operationList = widget.selectedAccount.operations;
    totalAmount = widget.selectedAccount.totalAmount;
  }

  void _openSelectionModal(context) async {
    final selectionResult = await showModalBottomSheet(
      context: context,
      builder: (context) => const ModalAddOperations(),
    );

    if (selectionResult == OperationType.insert ||
        selectionResult == OperationType.withdraw) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateOperationPage(
            operationType: selectionResult,
            operationTitle: selectionResult == OperationType.insert
                ? "Add an Insert"
                : "Add a Withdraw",
          ),
        ),
      ).then((newItem) {
        if (newItem != null) _addOperation(newItem);
      });
    }
  }

  void _openSnackbar(BuildContext context, title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
        padding: const EdgeInsets.fromLTRB(15, 4, 0, 4),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }

  void _addOperation(Operation operation) {
    setState(() {
      operationList.add(operation);

      if (operation.type == OperationType.withdraw) {
        // WITHDRAW MONEY FROM THE TOTAL AMOUNT
        totalAmount = totalAmount - operation.amount;
      } else if (operation.type == OperationType.insert) {
        // INSERT MONEY FROM THE TOTAL AMOUNT
        totalAmount = totalAmount + operation.amount;
      }

      // update the database
      widget.onUpdateAccountData(
        widget.index,
        widget.selectedAccount.name,
        operationList,
        totalAmount,
      );

      operation.type == OperationType.insert
          ? _openSnackbar(context, "Insertion Added")
          : _openSnackbar(context, "Withdrawal added");
    });
  }

  void _removeOperation(int index) async {
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
              // onRemoveOperation(index);
              Navigator.pop(context, 'OK');
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    ).then(
      (value) {
        if (value == "OK") {
          setState(() {
            Operation operation = operationList[index];
            operationList.removeAt(index);

            if (operation.type == OperationType.withdraw) {
              // insert the extracted amount to the total amount
              totalAmount = totalAmount + operation.amount;
            } else if (operation.type == OperationType.insert) {
              // withdraws the amount withdrawn in the total amount
              totalAmount = totalAmount - operation.amount;
            }

            // update database
            widget.onUpdateAccountData(
              widget.index,
              widget.selectedAccount.name,
              operationList,
              totalAmount,
            );

            _openSnackbar(context, "Operation Removed");
          });
        }
      },
    );
  }

  void _updateOperation(
    int index,
    Operation updatedOperation,
    Operation previusOperation,
  ) {
    setState(() {
      operationList[index] = updatedOperation;

      if (previusOperation.type == OperationType.withdraw) {
        // the previous amount is added and the new amount is subtracted.
        totalAmount =
            totalAmount + previusOperation.amount - updatedOperation.amount;
      } else if (previusOperation.type == OperationType.insert) {
        // the previous amount is subtracted and the new amount is added.
        totalAmount =
            totalAmount - previusOperation.amount + updatedOperation.amount;
      }

      // update database
      widget.onUpdateAccountData(
        widget.index,
        widget.selectedAccount.name,
        operationList,
        totalAmount,
      );

      _openSnackbar(context, "Operation Updated");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Economics Mobile App'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TOTAL AMOUNT
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Text(
                  "\$${totalAmount.toString()}",
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const Divider(),

            // MONTH SELECTOR
            // const Padding(
            //   padding: EdgeInsets.symmetric(vertical: 20),
            //   child: DropdownMonths(),
            // ),
            // const Divider(),

            // LIST OF OPERATIONS
            Container(
              child: operationList.isEmpty
                  // IF EMPTY SHOW A MESSAGE
                  ? const Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Text("Empty operation list"),
                        ),
                      ],
                    )
                  // ELSE SHOW A LIST
                  : Expanded(
                      child: ListView.builder(
                        itemCount: operationList.length,
                        itemBuilder: (context, index) {
                          Operation operation = operationList[index];
                          return OperationCard(
                            index: index,
                            operation: operation,
                            onRemoveOperation: (context) {
                              _removeOperation(index);
                            },
                            onUpdateOperation: _updateOperation,
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      // floating button
      floatingActionButton: FloatingActionButton(
        // open modal to select operation type
        onPressed: () => _openSelectionModal(context),
        tooltip: "Add an Operation",
        child: const Icon(Icons.add),
      ),
    );
  }
}
