import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/app_database.dart';
import 'package:todo_app/screens/todo_item_widget.dart';
import 'package:todo_app/todo_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo\'s Manager',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StreamBuilder<int>(
                    stream: context.read<TodoProvider>().allTodoCountStream,
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;
                      return FilterChip(
                        label: Text('All ($count)'),
                        selected: _filter == 'all',
                        onSelected: (bool selected) {
                          setState(() {
                            _filter = 'all';
                          });
                        },
                      );
                    },
                  ),
                  StreamBuilder<int>(
                    stream: context.read<TodoProvider>().pendingTodoCountStream,
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;
                      return FilterChip(
                        label: Text('Pending ($count)'),
                        selected: _filter == 'pending',
                        onSelected: (bool selected) {
                          setState(() {
                            _filter = 'pending';
                          });
                        },
                      );
                    },
                  ),
                  StreamBuilder<int>(
                    stream:
                        context.read<TodoProvider>().completedTodoCountStream,
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;
                      return FilterChip(
                        label: Text('Completed ($count)'),
                        selected: _filter == 'completed',
                        onSelected: (bool selected) {
                          setState(() {
                            _filter = 'completed';
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<TodoItem>>(
                stream: _getFilteredStream(context),
                builder: (context, snapshot) {
                  final todos = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return TodoItemWidget(todo: todo);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }

  Stream<List<TodoItem>> _getFilteredStream(BuildContext context) {
    switch (_filter) {
      case 'pending':
        return context.read<TodoProvider>().pendingTodoItems;
      case 'completed':
        return context.read<TodoProvider>().completedTodoItems;
      default:
        return context.read<TodoProvider>().allTodoItems;
    }
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Add New Task',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: 18,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter title',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black26,
                    fontSize: 14,
                  ),
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Enter description',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black26,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  context.read<TodoProvider>().addTodoItem(
                        _titleController.text,
                        _descriptionController.text.isNotEmpty
                            ? _descriptionController.text
                            : null,
                      );
                  _titleController.clear();
                  _descriptionController.clear();
                  setState(() {}); // Trigger UI update after adding a task
                }
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xfFEADEFF) // Set the background color here
                  ),
              child: const Text(
                'Add',
                style: TextStyle(color: Color(0xFF260460)),
              ),
            ),
          ],
        );
      },
    );
  }
}
