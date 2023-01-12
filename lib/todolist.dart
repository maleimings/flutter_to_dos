import 'package:flutter/material.dart';
import 'todo.dart';

class ToDoList extends StatefulWidget {
  final List<ToDoItem> todolist;

  const ToDoList({super.key, required this.todolist});

  @override
  State<StatefulWidget> createState() {
    return ToDoState();
  }
}

class ToDoState extends State<ToDoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My ToDo List"),
      ),
      body: Center(
        child: ListView.separated(
            shrinkWrap: true,
            itemCount: widget.todolist.length,
            itemBuilder: (BuildContext context, int index) {
              var item = widget.todolist[index];
              return Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Icon(item.completed
                            ? Icons.check_circle_outline
                            : Icons.radio_button_off)),
                    Flexible(
                        child: Container(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(item.title,
                                style: TextStyle(
                                    decoration: item.completed
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none))))
                  ],
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
