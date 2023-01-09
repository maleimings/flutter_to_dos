class ToDoItem {
  final int id;
  final String title;
  final bool completed;

  const ToDoItem( {required this.id, required this.title, required this.completed} );

  factory ToDoItem.fromJson(Map<String, dynamic> json) {
    return ToDoItem(id: json['id'], title: json['title'], completed: json['completed']);
  }

  @override
  String toString() {
    return "id: $id, title:$title, completed:$completed";
  }
}