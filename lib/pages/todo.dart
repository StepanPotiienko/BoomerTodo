import "package:flutter/material.dart";
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_flutter/pages/components/dialog_control_button.dart';
import 'package:learning_flutter/pages/data/database.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final String appBarTitle = "Boomer Todo";

  final _controller = TextEditingController();

  final hiveBox = Hive.box('tasks');
  TodoDatabase db = TodoDatabase();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.todoList[index][1] = !db.todoList[index][1];
    });
    db.updateDatabase();
  }

  void deleteTask(int index) {
    setState(() {
      db.todoList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  void initState() {
    // Initiated upon first ever app launch.
    if (hiveBox.get("TODOLIST") == null) {
      db.fillUpDataUponFirstEverLaunch();
    } else {
      db.loadDataFromDatabase();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return NewTaskDialog(
                    controller: _controller,
                    onSave: createNewTask,
                    onCancel: () => Navigator.of(context).pop(),
                  );
                });
          },
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: db.todoList.length,
          itemBuilder: (context, index) {
            return TodoTile(
                taskName: db.todoList[index][0],
                isCompleted: db.todoList[index][1],
                deleteTask: (context) => deleteTask(index),
                onTick: ((value) => checkBoxChanged(value, index)));
          },
        ));
  }

  void createNewTask() {
    setState(() {
      db.todoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDatabase();
  }
}

class NewTaskDialog extends StatelessWidget {
  final TextEditingController controller;

  final VoidCallback onSave;
  final VoidCallback onCancel;

  const NewTaskDialog(
      {Key? key,
      required this.controller,
      required this.onCancel,
      required this.onSave})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: SizedBox(
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: "Add a new task."),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DialogControlButton(buttonValue: "Save", onPressed: onSave),
              const SizedBox(width: 8),
              DialogControlButton(buttonValue: "Cancel", onPressed: onCancel)
            ],
          )
        ],
      ),
    ));
  }
}

class TodoTile extends StatelessWidget {
  const TodoTile(
      {super.key,
      required this.taskName,
      required this.isCompleted,
      required this.onTick,
      required this.deleteTask});

  final String taskName;

  final bool isCompleted;

  final Function(bool?)? onTick;
  final Function(BuildContext)? deleteTask;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteTask,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: Container(
            padding: const EdgeInsets.all(25.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 3))
                ]),
            child: Row(
              children: [
                Checkbox(
                  value: isCompleted,
                  onChanged: onTick,
                  activeColor: Colors.green,
                ),
                Text(
                  taskName,
                  style: TextStyle(
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
              ],
            )),
      ),
    );
  }
}
