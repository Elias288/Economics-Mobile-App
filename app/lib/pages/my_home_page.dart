import 'package:app/components/modal_add_operations.dart';
import 'package:app/components/info_card.dart';
import 'package:app/pages/create_operation_page.dart';
import 'package:app/utils/operations.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double totalAmount = 10000;
  List operationList = <Operation>[
    Operation(
      amount: 50.0,
      type: OperationType.withdraw,
      operationDate: "07/24/2023",
      cause: "Retiro para netflix",
    ),
    Operation(
      amount: 10.0,
      type: OperationType.insert,
      operationDate: "06/24/2023",
      cause: "Salario",
    ),
  ];

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

  void _addOperation(Operation operation) {
    setState(() {
      operationList.add(operation);
      // print([amount, type, operationDate]);
    });

    if (operation.type == OperationType.withdraw) {
      // WITHDRAW MONEY FROM THE TOTAL AMOUNT
      setState(() {
        totalAmount = totalAmount - operation.amount;
      });
    } else if (operation.type == OperationType.insert) {
      // INSERT MONEY FROM THE TOTAL AMOUNT
      setState(() {
        totalAmount = totalAmount + operation.amount;
      });
    }
  }

  void _removeOperation(int index) {
    setState(() {
      Operation operation = operationList[index];
      operationList.removeAt(index);

      if (operation.type == OperationType.withdraw) {
        // insert the extracted amount to the total amount
        setState(() {
          totalAmount = totalAmount + operation.amount;
        });
      } else if (operation.type == OperationType.insert) {
        // withdraws the amount withdrawn in the total amount
        setState(() {
          totalAmount = totalAmount - operation.amount;
        });
      }
    });
  }

  void _updateOperation(
    int index,
    Operation updatedOperation,
    Operation previusOperation,
  ) {
    /* Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateOperationPage(
            operationTitle: previusOperation.type == OperationType.insert
                ? "Edit the insert"
                : "Edit the Withdraw",
            operation: previusOperation),
      ),
    ); */

    setState(() {
      operationList[index] = updatedOperation;
    });

    if (previusOperation.type == OperationType.withdraw) {
      // the previous amount is added and the new amount is subtracted.
      setState(() {
        totalAmount =
            totalAmount + previusOperation.amount - updatedOperation.amount;
      });
    } else if (previusOperation.type == OperationType.insert) {
      // the previous amount is subtracted and the new amount is added.
      setState(() {
        totalAmount =
            totalAmount - previusOperation.amount + updatedOperation.amount;
      });
    }
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
            operationList.isEmpty
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
          ],
        ),
      ),

      // BOTON FLOTANTE
      floatingActionButton: FloatingActionButton(
        // MODAL PARA ELEGIR OPERACIÓN
        onPressed: () => _openSelectionModal(context),
        tooltip: "Add an Operation",
        child: const Icon(Icons.add),
      ),
    );
  }
}
