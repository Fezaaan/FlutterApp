class TodoItem {
  String task;
  String description;
  DateTime deadline;
  int priority;
  String status;
  bool isDone;

  TodoItem({
    required this.task,
    required this.description,
    required this.deadline,
    required this.priority,
    required this.status,
    required this.isDone,
  });

  Map<String, dynamic> toJson() => {
    'task': task,
    'description': description,
    'deadline': deadline.toIso8601String(),
    'priority': priority,
    'status': status,
    'isDone': isDone,
  };

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      task: json['task'],
      description: json['description'],
      deadline: DateTime.parse(json['deadline']),
      priority: json['priority'],
      status: json['status'],
      isDone: json['isDone'],
    );
  }
}
