import 'package:app/components/modal_add_operations.dart';
import 'package:app/components/operation_card.dart';
import 'package:app/pages/create_operation_page.dart';
import 'package:app/utils/account.dart';
import 'package:app/utils/operation.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  /// **************************** selected Account ****************************
  final Account selectedAccount;
  final int index;

  /// ******************** inherited function to update DB ********************
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

    /// ********************** list of account operations **********************
    operationList = widget.selectedAccount.operations;

    /// ********************* total amount of the account *********************
    totalAmount = widget.selectedAccount.totalAmount;
  }

  void _openSelectionModal(context) async {
    /* 
    * opens modal that allows to select which type of operation to create 
    */

    final selectionResult = await showModalBottomSheet(
      context: context,
      builder: (context) => const ModalAddOperations(),
    );

    if (selectionResult != null) {
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
        /// ************** withdraw money from the total amount **************
        totalAmount - operation.amount;
        _openSnackbar(context, "Withdrawal added");
      } else {
        /// *************** insert money from the total amount ***************
        totalAmount + operation.amount;
        _openSnackbar(context, "Insertion Added");
      }

      /// ************************ update the database ************************
      widget.onUpdateAccountData(
        widget.index,
        widget.selectedAccount.name,
        operationList,
        totalAmount,
      );
    });
  }

  void _removeOperation(int index) async {
    /* 
    * if the user confirms that he/she wants to delete the transaction, it 
    * returns an 'Ok' and removes the transaction from the account. 
    */

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Alert!!'),
        content: const Text('Are you sure you want to remove the operation?'),
        actions: <Widget>[
          /// ************************* cancel button *************************
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),

          /// *************************** ok button ***************************
          TextButton(
            onPressed: () {
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
              ///******* insert the extracted amount to the total amount*******
              totalAmount = totalAmount + operation.amount;
            } else {
              /// ***** withdraws the amount withdrawn in the total amount *****
              totalAmount = totalAmount - operation.amount;
            }

            /// *********************** update database ***********************
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
        /// ** the previous amount is added and the new amount is subtracted **
        totalAmount =
            totalAmount + previusOperation.amount - updatedOperation.amount;
      } else {
        /// ** the previous amount is subtracted and the new amount is added **
        totalAmount =
            totalAmount - previusOperation.amount + updatedOperation.amount;
      }

      /// ************************** update database **************************
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
            /// *********************  total amount viewer *********************
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

            /// ****************** viewer and month selector ******************
            /* 
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: DropdownMonths(),
              ),
            const Divider(), 
            */

            /// ****************** list of account operations ******************
            Container(
              child: operationList.isEmpty

                  /// ************************ if empty ************************
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

                  /// **************** if there are operations ****************
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

      /// ************************** floating button **************************
      floatingActionButton: FloatingActionButton(
        /// *************** open modal to select operation type ***************
        onPressed: () => _openSelectionModal(context),
        tooltip: "Add an Operation",
        child: const Icon(Icons.add),
      ),
    );
  }
}
