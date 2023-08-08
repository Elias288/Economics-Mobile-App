import 'package:app/components/account_card.dart';
import 'package:app/data/hive.data.dart';
import 'package:app/pages/create_account_page.dart';
import 'package:app/utils/account.dart';
import 'package:app/utils/operation.dart';
import 'package:flutter/material.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  HiveData hd = HiveData();

  @override
  void initState() {
    super.initState();

    hd.loadAccounts();
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

  void _createNewAccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateAccountPage(),
      ),
    ).then((value) {
      if (value != null) _addNewAccount(value);
    });
  }

  void _addNewAccount(Account newAccount) {
    setState(() {
      hd.accountList.add(newAccount);
      hd.updateDataBase();
    });

    _openSnackbar(context, "Account Created");
  }

  void _updateAccount(
    int index,
    String accountName,
    List<Operation> newOperationlist,
    double newTotalAmount,
  ) {
    setState(() {
      Account updatedAccount = Account(
        name: hd.accountList[index].name,
        totalAmount: newTotalAmount,
      );

      updatedAccount.operations = newOperationlist;
      hd.accountList[index] = updatedAccount;

      hd.updateDataBase();
    });
    _openSnackbar(context, "Account Updated");
  }

  void _deleteAccount(int index) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Alert!!'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This action will also eliminate all operations'),
            Text("Are you sure you want to continue?"),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, "OK");
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    ).then(
      (value) {
        if (value == "OK") {
          setState(() {
            hd.accountList.removeAt(index);
            hd.updateDataBase();
          });

          _openSnackbar(context, "Account Removed");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Economics Mobile App'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: hd.accountList.isEmpty
                  ? const Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Text("Empty account list"),
                        ),
                      ],
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: hd.accountList.length,
                        itemBuilder: (context, index) {
                          return AccountCard(
                            accountInfo: hd.accountList[index],
                            onAddNewAccount: _updateAccount,
                            index: index,
                            onDeleteAccount: _deleteAccount,
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewAccount(context),
        tooltip: "Add an Account",
        child: const Icon(Icons.add),
      ),
    );
  }
}
