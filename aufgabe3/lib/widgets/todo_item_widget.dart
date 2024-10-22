import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_item.dart';
import '../models/todo_list_model.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoItem item;
  final int index;

  TodoItemWidget({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        item.task,
        style: TextStyle(
          decoration: item.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description: ${item.description}'),
          Text('Deadline: ${item.deadline.toLocal()}'.split(' ')[0]),
          Text('Priority: ${item.priority}'),
          Text('Status: ${item.status}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              item.isDone ? Icons.check_box : Icons.check_box_outline_blank,
            ),
            onPressed: () {
              Provider.of<TodoListModel>(context, listen: false)
                  .toggleTodoItem(index);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Provider.of<TodoListModel>(context, listen: false)
                  .removeTodoItem(index);
            },
          ),
        ],
      ),
    );
  }
}
