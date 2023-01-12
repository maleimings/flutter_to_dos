import 'package:flutter/material.dart';
import 'todo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<StatefulWidget> createState() {
    return ToDoState();
  }
}

class ToDoState extends State<ToDoList> {
  List<ToDoItem> todolist = List.empty();
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My ToDo List"),
        ),
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Center(
              child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: todolist.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = todolist[index];
                    return GestureDetector(
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
                        onTap: () async {
                          bool? completed = await showCompleteConfirmDialog(item.title);
                              if (completed == true) {

                              }
                        });
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(color: Colors.grey);
                  }),
            ),
            Center(
                child: Visibility(
                    visible: isLoading,
                    child: const CircularProgressIndicator()))
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    getToDoList();
  }

  getToDoList() async {
    var response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/todos"));

    List<ToDoItem> data = response.statusCode == 200
        ? (jsonDecode(response.body) as List)
            .map((e) => ToDoItem.fromJson(e))
            .toList()
        : List.empty();

    setState(() {
      todolist = data;
      isLoading = false;
    });
  }

  Future<bool?> showCompleteConfirmDialog(String title) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Complete the item?"),
            content: Text("Are you sure this item $title is completed?"),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop();
        }, child: const Text("Cancel")),
        TextButton(onPressed: () {
          Navigator.of(context).pop(true);
        }, child: const Text("Sure"))
        ]
        );},
    );
  }
}
