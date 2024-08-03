import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/app_database.dart';
import 'package:todo_app/todo_provider.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoItem todo;

  const TodoItemWidget({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        title: Text(
          todo.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            decoration: todo.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: todo.isCompleted ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: todo.description != null && todo.description!.isNotEmpty
            ? Text(
                todo.description!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  decoration: todo.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              icon: todo.isCompleted
                  ? Container(
                      decoration: BoxDecoration(
                          color: todo.isCompleted
                              ? Colors.green
                              : const Color(0xFF260460),
                          borderRadius: BorderRadius.circular(32)),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        // color: todo.isCompleted ? Colors.green : Color(0xFF260460),
                        size: 16,
                      ),
                    )
                  : Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                          // color: todo.isCompleted ? Colors.green : Color(0xFF260460),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: Colors.black54)),
                    ),
              onPressed: () {
                context.read<TodoProvider>().toggleTodoCompletion(todo);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
              onPressed: () {
                _showDeleteDialog(context, todo);
                // context.read<TodoProvider>().deleteTodoItem(todo);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, TodoItem todo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<TodoProvider>().deleteTodoItem(todo);
                // setState(() {}); // Trigger UI update after deleting a task
                Navigator.of(context).pop();
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child:
                  const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
