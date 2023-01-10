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
              return SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Icon(item.completed ? Icons.check : Icons.clear), Flexible(child: Text("${item.title} ${item.completed}"))],
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
