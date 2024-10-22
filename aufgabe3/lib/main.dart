import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/todo_list_model.dart';
import 'screens/todo_list_screen.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoListModel(),
      child: MaterialApp(
        title: 'Fezaans To-Do Liste',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: TodoListScreen(),
      ),
    );
  }
}
