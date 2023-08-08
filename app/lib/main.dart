import 'package:app/pages/init_page.dart';
import 'package:app/utils/account.dart';
// import 'package:app/pages/my_home_page.dart';
import 'package:app/utils/operation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AccountAdapter());
  Hive.registerAdapter(OperationAdapter());
  Hive.registerAdapter(OperationTypeAdapter());
  await Hive.openBox("accountsBox");

  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const InitPage(),
    );
  }
}
