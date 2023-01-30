import 'package:flutter/material.dart';
import 'to_do_item.dart';

class ToDoList extends StatefulWidget {
  List<ToDoItem> todoList = List.empty();

  ToDoList({super.key, required this.todoList});

  @override
  State<StatefulWidget> createState() {
    return ToDoState();
  }
}

class ToDoState extends State<ToDoList> {
  List<ToDoItem> todolist = List.empty();
  bool isLoading = false;

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

  Future<bool?> showCompleteConfirmDialog(String title) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text("Complete the item?"),
            content: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(children: [
                const TextSpan(text: "Are you sure this item "),
                TextSpan(
                    text: title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
                const TextSpan(text: "has completed?")
              ]),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
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
