import 'package:flutter/material.dart';
import 'todo.dart';

class ToDoList extends StatelessWidget {
  final List<ToDoItem> todolist;

  const ToDoList({super.key, required this.todolist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My ToDo List"),
      ),
      body: Center(
        child: ListView.separated(
          shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            itemCount: todolist.length,
            itemBuilder: (BuildContext context, int index) {
              var item = todolist[index];
              return Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Icon(item.completed ? Icons.check_circle_outline : Icons.radio_button_off),
                   Flexible(child: Container(padding: const EdgeInsets.only(left: 20.0), child: Text(item.title)))],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(color: Colors.grey);
            }),
      ),
    );
  }
}
