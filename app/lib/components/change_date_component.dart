import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class ChangeDateComponent extends StatefulWidget {
  final ValueChanged<DateTime> onDateChanged;
  final DateTime initialDate;

  const ChangeDateComponent({
    super.key,
    required this.onDateChanged,
    required this.initialDate,
  });

  @override
  State<ChangeDateComponent> createState() => _ChangeDateComponentState();
}

class _ChangeDateComponentState extends State<ChangeDateComponent> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        widget.onDateChanged(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("Date: "),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Row(
              children: [
                const Icon(Icons.date_range),
                Text(intl.DateFormat('MM/dd/yyyy').format(widget.initialDate)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
