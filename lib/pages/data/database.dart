import 'package:hive_flutter/hive_flutter.dart';

class TodoDatabase {
  List todoList = [];

  final tasksBox = Hive.box('tasks');

  void fillUpDataUponFirstEverLaunch() {
    todoList = [
      ["Add new tasks", false]
    ];
  }

  void loadDataFromDatabase() {
    todoList = tasksBox.get("TODOLIST");
  }

  void updateDatabase() {
    tasksBox.put("TODOLIST", todoList);
  }
}
