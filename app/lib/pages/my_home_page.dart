// import 'package:app/components/dropdown_months.dart';
import 'package:app/components/info_card.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  final List operationList;
  final double totalAmount;

  const MyHomePage(
      {super.key, required this.operationList, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          Expanded(
            child: ListView.builder(
              itemCount: operationList.length,
              itemBuilder: (context, index) {
                return InfoCard(
                  amount: operationList[index][0],
                  type: operationList[index][1],
                  operationDate: operationList[index][2],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
