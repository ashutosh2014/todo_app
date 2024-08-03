import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/app_database.dart';

class TodoProvider with ChangeNotifier {
  final AppDatabase _database;

  TodoProvider(this._database);

  Stream<List<TodoItem>> get allTodoItems => _database.watchAllTodoItems();
  Stream<List<TodoItem>> get pendingTodoItems => _database
      .watchAllTodoItems()
      .map((todos) => todos.where((todo) => !todo.isCompleted).toList());
  Stream<List<TodoItem>> get completedTodoItems => _database
      .watchAllTodoItems()
      .map((todos) => todos.where((todo) => todo.isCompleted).toList());

  Stream<int> get allTodoCountStream async* {
    yield* _database.watchAllTodoItems().map((todos) => todos.length);
  }

  Stream<int> get pendingTodoCountStream async* {
    yield* _database
        .watchAllTodoItems()
        .map((todos) => todos.where((todo) => !todo.isCompleted).length);
  }

  Stream<int> get completedTodoCountStream async* {
    yield* _database
        .watchAllTodoItems()
        .map((todos) => todos.where((todo) => todo.isCompleted).length);
  }

  Future<void> addTodoItem(String title, String? description) async {
    final todoItem = TodoItemsCompanion(
      title: Value(title),
      description: Value(description),
    );
    await _database.insertTodoItem(todoItem);
    notifyListeners();
  }

  Future<void> updateTodoItem(TodoItem todoItem) async {
    await _database.updateTodoItem(todoItem);
    notifyListeners();
  }

  Future<void> deleteTodoItem(TodoItem todoItem) async {
    await _database.deleteTodoItem(todoItem);
    notifyListeners();
  }

  Future<void> toggleTodoCompletion(TodoItem todoItem) async {
    final updatedTodoItem =
        todoItem.copyWith(isCompleted: !todoItem.isCompleted);
    await _database.updateTodoItem(updatedTodoItem);
    notifyListeners();
  }
}
