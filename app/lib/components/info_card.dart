import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  // {"amount": 50, "type": "substract", "date": "07/24/2023"},
  final double amount;
  final String type;
  final String operationDate;

  const InfoCard({
    super.key,
    required this.amount,
    required this.type,
    required this.operationDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(operationDate),
            Text(type == "Withdraw"
                ? "-\$${amount.toString()}"
                : "\$${amount.toString()}"),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.delete))
              ],
            )
          ],
        ),
      ),
    );
  }
}
