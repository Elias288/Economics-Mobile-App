import 'package:app/pages/my_home_page.dart';
import 'package:app/utils/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AccountCard extends StatelessWidget {
  final Account accountInfo;
  final Function onAddNewAccount;
  final Function onDeleteAccount;
  final int index;

  const AccountCard({
    super.key,
    required this.accountInfo,
    required this.onAddNewAccount,
    required this.index,
    required this.onDeleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          // delete operation
          SlidableAction(
            onPressed: (_) => onDeleteAccount(index),
            icon: Icons.delete,
            backgroundColor: Colors.red.shade400,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: ListTile(
        title: Text(accountInfo.name),
        subtitle:
            Text("Amount in account: \$${accountInfo.totalAmount.toString()}"),
        leading: const Icon(Icons.list),
        // trailing:,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(
                selectedAccount: accountInfo,
                onUpdateAccountData: onAddNewAccount,
                index: index,
              ),
            ),
          );
        },
      ),
    );
  }
}
