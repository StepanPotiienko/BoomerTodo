import "package:flutter/material.dart";
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_flutter/pages/todo.dart';

void main() async {
  await Hive.initFlutter();

  // !: For some reason, Flutter marks this variable as "unused" yet still without it.
  // !: application would not work properly.
  // ignore: unused_local_variable
  Box box = await Hive.openBox('tasks');

  runApp(const TodoApplication());
}

class TodoApplication extends StatelessWidget {
  const TodoApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const TodoPage(),
        theme: ThemeData(primarySwatch: Colors.purple));
  }
}
