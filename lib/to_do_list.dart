import 'package:flutter/material.dart';
import 'package:flutter_to_dos/database_manager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';
import 'to_do_item.dart';
import 'to_do_type.dart';

class ToDoList extends StatefulWidget {
  List<ToDoItem> todoList = List.empty();
  var type = Type.all;

  ToDoList({super.key, required this.todoList, required this.type});

  @override
  State<StatefulWidget> createState() {
    return ToDoState();
  }
}

class ToDoState extends State<ToDoList> {
  bool isLoading = false;

  String getText(Type type) {
    switch (type) {
      case Type.all:
        return "My ToDo List";
      case Type.completed:
        return "My Completed List";
      case Type.incomplete:
        return "My In-Progress List";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getText(widget.type)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop(widget.todoList);
            },
          ),
        ),
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Center(
              child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: widget.todoList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = widget.todoList[index];
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
                          if (!item.completed) {
                            bool? completed = await showCompleteConfirmDialog(
                                item.title);
                            if (completed == true) {
                              setState(() {
                                isLoading = true;
                              });
                              update(item).then((value) => setState(() {
                                isLoading = false;
                                setState(() {
                                  widget.todoList = widget.todoList.where((element) => element.id != item.id).toList();
                                });
                              }));
                            }
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
  }

  Future update(ToDoItem item) async {
    final Database db = await DataBaseManager.instance.database;
    var row = item.toMap();
    row["completed"] = 1; //1 means true
    return await db.update("todos", row, where: "id = ?", whereArgs: [item.id]);
  }

  Future<bool?> showCompleteConfirmDialog(String title) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text("Complete the item?"),
            content: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                  style: const TextStyle(fontSize: 16.0, color: Colors.black),
                  children: [
                    const TextSpan(text: "Are you sure this item:\n"),
                    TextSpan(
                        text: "$title\n",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue)),
                    const TextSpan(text: "is completed?")
                  ]),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Not Yet")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Sure"))
            ]);
      },
    );
  }
}
