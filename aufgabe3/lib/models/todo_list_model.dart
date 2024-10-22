import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'todo_item.dart';

class TodoListModel extends ChangeNotifier {
  List<TodoItem> _todoItems = [];

  List<TodoItem> get todoItems => _todoItems;

  Future<void> loadTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedTodos = prefs.getString('todos');
    if (storedTodos != null) {
      _todoItems = (json.decode(storedTodos) as List)
          .map((item) => TodoItem.fromJson(item))
          .toList();
      notifyListeners();
    }
  }

  Future<void> saveTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('todos', json.encode(_todoItems));
  }

  void addTodoItem(TodoItem item) {
    _todoItems.add(item);
    saveTodos();
    notifyListeners();
  }

  void removeTodoItem(int index) {
    _todoItems.removeAt(index);
    saveTodos();
    notifyListeners();
  }

  void toggleTodoItem(int index) {
    _todoItems[index].isDone = !_todoItems[index].isDone;
    saveTodos();
    notifyListeners();
  }

  void sortTodos(SortBy sortBy) {
    _todoItems.sort((a, b) {
      if (sortBy == SortBy.urgency) {
        return a.deadline.compareTo(b.deadline);
      } else if (sortBy == SortBy.priority) {
        return b.priority.compareTo(a.priority);
      } else {
        return a.status.compareTo(b.status);
      }
    });
    notifyListeners();
  }
}

enum SortBy { urgency, priority, status }
