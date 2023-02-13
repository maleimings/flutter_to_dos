import 'package:flutter/material.dart';
import 'to_do_item.dart';

class MyToDoList with ChangeNotifier {
  final List<ToDoItem> myToDoList = <ToDoItem>[];
  final List<ToDoItem> completedItemList = <ToDoItem>[];
  final List<ToDoItem> incompletedItemList = <ToDoItem>[];


  void initMyToDoList(List<ToDoItem> myToDoItemList) {
    myToDoList.clear();
    completedItemList.clear();
    incompletedItemList.clear();

    myToDoList.addAll(myToDoItemList);
    completedItemList.addAll(myToDoList.where((element) => element.completed).toList());
    incompletedItemList.addAll(myToDoList.where((element) => !element.completed).toList());
    notifyListeners();
  }

  void update(int id, bool completed) {
    var toDoItem = myToDoList.firstWhere((element) => element.id == id);
    var index = myToDoList.indexWhere((element) => element.id == id);
    var newToDoItem = ToDoItem(id:id, title: toDoItem.title, completed: completed);
    myToDoList[index] = newToDoItem;

    notifyListeners();
  }
}