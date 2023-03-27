import 'package:flutter_to_dos/to_do_item.dart';

abstract class IToDoRepository {
  Future<List<ToDoItem>> getAll();
}