import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_to_dos/todoitem.dart';
import 'package:flutter_to_dos/todolist.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';

// import 'package:sqflite/sqflite.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.name});

  final String name;

  Future<http.Response> fetchMyToDoList() {
    return http.get(Uri.parse("https://jsonplaceholder.typicode.com/todos"));
  }

  @override
  State<StatefulWidget> createState() {
    return DashboardState();
  }
}

class DashboardState extends State<Dashboard> {

  List<ToDoItem> todolist = List.empty();
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
        ),
        body: Stack(children: [Center(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text("This is a dashboard page for user ${widget.name}")),
                Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const ToDoList()));
                        },
                        child: const Text('Show My ToDo List'))),
              ],

            )),
          Center(
              child: Visibility(
                  visible: isLoading,
                  child: const CircularProgressIndicator()))],
        ));
  }

  @override
  void initState() {
    super.initState();
    getAndSaveToDoList();
  }

  getAndSaveToDoList() async {
    // WidgetsFlutterBinding.ensureInitialized();
    // final database = openDatabase(
    //     join(await getDatabasesPath(), "todo_database.db"),
    //     onCreate: (db, version) {
    //       return db.execute(
    //           'CREATE TABLE todos(id TEXT PRIMARY KEY, title TEXT NOT NULL, completed INTEGER NOT NULL');
    //     },
    //     version: 1
    // );

    var response =
    await http.get(Uri.parse("https://jsonplaceholder.typicode.com/todos"));

    List<ToDoItem> data = response.statusCode == 200
        ? (jsonDecode(response.body) as List)
        .map((e) => ToDoItem.fromJson(e))
        .toList()
        : List.empty();

    for (ToDoItem todo in data) {

    }


    setState(() {
      todolist = data;
      isLoading = false;
    });

    // Future<void> insertToDoItem(ToDoItem todo) async {
    //   final db = await database;
    //
    //   await db.insert("todos", values)
    // }
  }
}
