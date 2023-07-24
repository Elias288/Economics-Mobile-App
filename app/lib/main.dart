import 'package:app/components/modal_bottom_sheet_operations.dart';
import 'package:app/pages/my_home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double totalAmount = 10000;
  List operationList = [
    // AMOUNT, TYPE, OPERATION DATE
    [50.0, "Withdraw", "07/24/2023"],
    [10.0, "Insert", "06/24/2023"],
  ];

  void addOperation(double amount, String type, String operationDate) {
    setState(() {
      operationList.add([amount, type, operationDate]);
      // print([amount, type, operationDate]);

      if (type == "Withdraw") {
        // WITHDRAW MONEY FROM THE TOTAL AMOUNT
        setState(() {
          totalAmount = totalAmount - amount;
        });
      } else if (type == "Insert") {
        // INSERT MONEY FROM THE TOTAL AMOUNT
        setState(() {
          totalAmount = totalAmount + amount;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Economics Mobile App'),
        ),
        body: MyHomePage(
          operationList: operationList,
          totalAmount: totalAmount,
        ),
        // BOTON FLOTANTE
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // MODAL PARA ELEGIR OPERACIÓN
            showModalBottomSheet<void>(
              context: context,
              builder: (context) {
                return ModalBottonSheetOperations(onAddOperation: addOperation);
              },
            );
          },
          tooltip: "Add an Operation",
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
