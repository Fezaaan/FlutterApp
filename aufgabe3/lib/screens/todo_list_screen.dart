import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_list_model.dart';
import '../models/todo_item.dart';
import '../widgets/todo_item_widget.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDeadline;
  int _selectedPriority = 1;
  String _selectedStatus = 'Pending';

  @override
  void initState() {
    super.initState();
    Provider.of<TodoListModel>(context, listen: false).loadTodos();
  }

  void _addTodoItem() {
    if (_taskController.text.isNotEmpty) {
      TodoItem newItem = TodoItem(
        task: _taskController.text,
        description: _descriptionController.text,
        deadline: _selectedDeadline ?? DateTime.now(),
        priority: _selectedPriority,
        status: _selectedStatus,
        isDone: false,
      );
      Provider.of<TodoListModel>(context, listen: false).addTodoItem(newItem);
      _clearForm();
    }
  }

  void _clearForm() {
    _taskController.clear();
    _descriptionController.clear();
    _selectedDeadline = null;
    _selectedPriority = 1;
    _selectedStatus = 'Pending';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do Liste'),
        actions: [
          PopupMenuButton<SortBy>(
            onSelected: (sortBy) {
              Provider.of<TodoListModel>(context, listen: false)
                  .sortTodos(sortBy);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortBy>>[
              const PopupMenuItem<SortBy>(
                value: SortBy.urgency,
                child: Text('Sort by Urgency'),
              ),
              const PopupMenuItem<SortBy>(
                value: SortBy.priority,
                child: Text('Sort by Priority'),
              ),
              const PopupMenuItem<SortBy>(
                value: SortBy.status,
                child: Text('Sort by Status'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                    labelText: 'Task',
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          ).then((date) {
                            setState(() {
                              _selectedDeadline = date;
                            });
                          });
                        },
                        child: Text(_selectedDeadline == null
                            ? 'Pick Deadline'
                            : _selectedDeadline!.toLocal().toString().split(' ')[0]),
                      ),
                    ),
                  ],
                ),
                DropdownButton<int>(
                  value: _selectedPriority,
                  items: [
                    DropdownMenuItem(child: Text('Low Priority'), value: 1),
                    DropdownMenuItem(child: Text('Medium Priority'), value: 2),
                    DropdownMenuItem(child: Text('High Priority'), value: 3),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedPriority = value!;
                    });
                  },
                ),
                DropdownButton<String>(
                  value: _selectedStatus,
                  items: [
                    DropdownMenuItem(child: Text('Pending'), value: 'Pending'),
                    DropdownMenuItem(child: Text('In Progress'), value: 'In Progress'),
                    DropdownMenuItem(child: Text('Completed'), value: 'Completed'),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: _addTodoItem,
                  child: Text('Add Task'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<TodoListModel>(
              builder: (context, todoList, child) {
                return ListView.builder(
                  itemCount: todoList.todoItems.length,
                  itemBuilder: (context, index) {
                    return TodoItemWidget(
                      item: todoList.todoItems[index],
                      index: index,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
