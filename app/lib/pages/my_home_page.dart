// import 'package:app/components/dropdown_months.dart';
import 'package:app/components/modal_bottom_sheet_operations.dart';
import 'package:app/components/info_card.dart';
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
  List operationList = <Operations>[
    // AMOUNT, TYPE, OPERATION DATE
    // Operations(amount: 50.0, type: "Withdraw", operationDate: "07/24/2023"),
    // Operations(amount: 10.0, type: "Insert", operationDate: "06/24/2023"),
  ];

  void addOperation(Operations operation) {
    setState(() {
      operationList.add(operation);
      // print([amount, type, operationDate]);

      if (operation.type == "Withdraw") {
        // WITHDRAW MONEY FROM THE TOTAL AMOUNT
        setState(() {
          totalAmount = totalAmount - operation.amount;
        });
      } else if (operation.type == "Insert") {
        // INSERT MONEY FROM THE TOTAL AMOUNT
        setState(() {
          totalAmount = totalAmount + operation.amount;
        });
      }
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
                        Operations op = operationList[index];

                        return InfoCard(
                          amount: op.amount,
                          type: op.type,
                          operationDate: op.operationDate,
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),

      // BOTON FLOTANTE
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // MODAL PARA ELEGIR OPERACIÓN
          showModalBottomSheet<void>(
            context: context,
            builder: (context) =>
                ModalBottonSheetOperations(onAddOperation: addOperation),
          );
        },
        tooltip: "Add an Operation",
        child: const Icon(Icons.add),
      ),
    );
  }
}
