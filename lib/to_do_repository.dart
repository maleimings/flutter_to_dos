import 'package:flutter_to_dos/database_manager.dart';
import 'package:flutter_to_dos/to_do_item.dart';
import 'package:flutter_to_dos/to_do_interface.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';

class ToDoRepository implements IToDoRepository {
  @override
  Future<List<ToDoItem>> getAll() async {

    Database currentDatabase = await DataBaseManager.instance.database;

    List<Map<String, Object?>> todos = await currentDatabase.query('todos');
    List<ToDoItem> data;

    if (todos.isEmpty) {
      var response = await http
          .get(Uri.parse("https://jsonplaceholder.typicode.com/todos"));

      data = response.statusCode == 200
          ? (jsonDecode(response.body) as List)
          .map((e) => ToDoItem.fromJson(e))
          .toList()
          : List.empty();

      if (data.isNotEmpty) {
        for (var element in data) {
          var value = element.toMap();
          currentDatabase.insert('todos', value);
        }
      }
    } else {
      data = List.generate(todos.length, (index) {
        return ToDoItem(
            id: todos[index]['id'] as int,
            title: todos[index]['title'] as String,
            completed: todos[index]['completed'] as int == 1);
      });
    }

    return data;
  }

  @override
  Future update(ToDoItem item) async {
    final Database db = await DataBaseManager.instance.database;
    var row = item.toMap();
    row["completed"] = 1; //1 means true
    return await db.update("todos", row, where: "id = ?", whereArgs: [item.id]);
  }

}