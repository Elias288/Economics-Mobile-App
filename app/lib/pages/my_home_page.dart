import 'dart:developer';
import 'package:app/components/modal_add_operations.dart';
import 'package:app/components/info_card.dart';
import 'package:app/data/hive.data.dart';
import 'package:app/pages/create_operation_page.dart';
import 'package:app/utils/operation.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HiveData hd = HiveData();

  @override
  void initState() {
    hd.loadData();
    inspect(hd.operationList);

    super.initState();
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
      hd.operationList.add(operation);
      inspect(hd.operationList);
      if (operation.type == OperationType.withdraw) {
        // WITHDRAW MONEY FROM THE TOTAL AMOUNT
        hd.totalAmount = hd.totalAmount - operation.amount;
      } else if (operation.type == OperationType.insert) {
        // INSERT MONEY FROM THE TOTAL AMOUNT
        hd.totalAmount = hd.totalAmount + operation.amount;
      }

      hd.updateDataBase();
      operation.type == OperationType.insert
          ? _openSnackbar(context, "Insertion Added")
          : _openSnackbar(context, "Withdrawal added");
    });
  }

  void _removeOperation(int index) {
    setState(() {
      Operation operation = hd.operationList[index];
      hd.operationList.removeAt(index);

      if (operation.type == OperationType.withdraw) {
        // insert the extracted amount to the total amount
        hd.totalAmount = hd.totalAmount + operation.amount;
      } else if (operation.type == OperationType.insert) {
        // withdraws the amount withdrawn in the total amount
        hd.totalAmount = hd.totalAmount - operation.amount;
      }

      hd.updateDataBase();
      _openSnackbar(context, "Operation Removed");
    });
  }

  void _updateOperation(
    int index,
    Operation updatedOperation,
    Operation previusOperation,
  ) {
    setState(() {
      hd.operationList[index] = updatedOperation;

      if (previusOperation.type == OperationType.withdraw) {
        // the previous amount is added and the new amount is subtracted.
        hd.totalAmount =
            hd.totalAmount + previusOperation.amount - updatedOperation.amount;
      } else if (previusOperation.type == OperationType.insert) {
        // the previous amount is subtracted and the new amount is added.
        hd.totalAmount =
            hd.totalAmount - previusOperation.amount + updatedOperation.amount;
      }

      hd.updateDataBase();
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
            const Divider(),

            // TOTAL AMOUNT
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Text(
                  "\$${hd.totalAmount.toString()}",
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
              child: hd.operationList.isEmpty
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
                        itemCount: hd.operationList.length,
                        itemBuilder: (context, index) {
                          Operation operation = hd.operationList[index];

                          return InfoCard(
                            index: index,
                            operation: operation,
                            onRemoveOperation: (context) =>
                                _removeOperation(index),
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
