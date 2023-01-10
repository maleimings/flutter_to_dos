import 'package:flutter/material.dart';
import 'package:flutter_to_dos/todo.dart';
import 'package:flutter_to_dos/todolist.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
        ),
        body: Center(
            child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text("This is a dashboard page for user $name")),
            Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                    onPressed: () async {
                      var response = await http.get(Uri.parse(
                          "https://jsonplaceholder.typicode.com/todos"));

                      if (response.statusCode == 200) {
                        var data = (jsonDecode(response.body) as List)
                            .map((e) => ToDoItem.fromJson(e))
                            .toList();

                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ToDoList(todolist: data)));
                      } else {}
                    },
                    child: const Text('Show My ToDo List'))),
          ],
        )));
  }

  Future<http.Response> fetchMyToDoList() {
    return http.get(Uri.parse("https://jsonplaceholder.typicode.com/todos"));
  }
}
