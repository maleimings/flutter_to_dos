import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_to_dos/database_manager.dart';
import 'package:flutter_to_dos/to_do_item.dart';
import 'package:flutter_to_dos/to_do_list.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';

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
        body: Stack(
          children: [
            Center(
                child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                        "This is a dashboard page for user ${widget.name}")),
                Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ToDoList()));
                        },
                        child: const Text('Show My ToDo List'))),
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
    super.initState();
    getAndSaveToDoList();
  }

  getAndSaveToDoList() async {
    DataBaseManager.instance.database.then((database) {
      database.query('todos_database').then((todos) async {
        List<ToDoItem> data;
        if (todos.isEmpty) {
          var response = await http
              .get(Uri.parse("https://jsonplaceholder.typicode.com/todos"));

          data = response.statusCode == 200
              ? (jsonDecode(response.body) as List)
                  .map((e) => ToDoItem.fromJson(e))
                  .toList()
              : List.empty();
        } else {
          data = List.generate(todos.length, (index) {
            return ToDoItem(
                id: todos[index]['id'] as int,
                title: todos[index]['title'] as String,
                completed: todos[index]['completed'] as int == 1);
          });
        }

        setState(() {
          todolist = data;
        });
      });
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }
}
