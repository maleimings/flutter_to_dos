import 'package:flutter/material.dart';
import 'package:flutter_to_dos/my_to_do_list.dart';
import 'package:flutter_to_dos/to_do_item.dart';
import 'package:flutter_to_dos/to_do_list.dart';
import 'package:flutter_to_dos/to_do_repository.dart';
import 'package:provider/provider.dart';
import 'to_do_type.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.name});

  final String name;

  @override
  State<StatefulWidget> createState() {
    return DashboardState();
  }
}

class DashboardState extends State<Dashboard> {
  bool isLoading = true;

  late final MyToDoList myToDoList;

  ToDoRepository toDoRepository = ToDoRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
        ),
        body: Stack(
          children: [
            Center(
                child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 18.0, color: Colors.black),
                          children: [
                            const TextSpan(text: "Dashboard page for user "),
                            TextSpan(
                                text: widget.name,
                                style: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline))
                          ]),
                    )),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ToDoList(
                                          type: Type.completed,
                                        )));
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline_outlined),
                              RichText(
                                  text: TextSpan(
                                      style: const TextStyle(
                                          fontSize: 14.0, color: Colors.white),
                                      children: [
                                    const TextSpan(text: "Completed: "),
                                    TextSpan(
                                        text: myToDoList.completedItemList.length.toString(),
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline))
                                  ]))
                            ],
                          )),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ToDoList(
                                          type: Type.incomplete,
                                        ))).then((value) => getAndSaveToDoList());
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.radio_button_off_outlined),
                              RichText(
                                  text: TextSpan(
                                      style: const TextStyle(
                                          fontSize: 14.0, color: Colors.white),
                                      children: [
                                    const TextSpan(text: "Incomplete: "),
                                    TextSpan(
                                        text:
                                            myToDoList.incompletedItemList.length.toString(),
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline)),
                                  ]))
                            ],
                          )),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ToDoList(
                                        type: Type.all,
                                      ))).then((value) => getAndSaveToDoList());
                        },
                        child: RichText(
                          text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.white),
                              children: [
                                const TextSpan(text: 'Show All My ToDo List: '),
                                TextSpan(
                                    text: myToDoList.myToDoList.length.toString(),
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline)),
                              ]),
                        ))),
              ],
            )),
            Center(
                child: Visibility(
                    visible: isLoading,
                    child: const CircularProgressIndicator()))
          ],
        ));
  }

  @override
  void initState() {
    myToDoList = Provider.of<MyToDoList>(context, listen: false);

    super.initState();

    getAndSaveToDoList();
  }

  @override
  void dispose() {
    super.dispose();
    myToDoList.dispose();
  }

  getAndSaveToDoList() async {
    List<ToDoItem> todos = await toDoRepository.getAll();

    myToDoList.initMyToDoList(todos);

    setState(() {
      isLoading = false;
    });
    return todos;
  }
}
