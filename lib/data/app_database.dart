import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'app_database.g.dart';

// Define the table
class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()(); // Add description field
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}

// Create the database
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'temp.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [TodoItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<TodoItem>> getAllTodoItems() => select(todoItems).get();
  Stream<List<TodoItem>> watchAllTodoItems() => select(todoItems).watch();
  Future<int> insertTodoItem(TodoItemsCompanion todoItem) =>
      into(todoItems).insert(todoItem);
  Future<bool> updateTodoItem(TodoItem todoItem) =>
      update(todoItems).replace(todoItem);
  Future<int> deleteTodoItem(TodoItem todoItem) =>
      delete(todoItems).delete(todoItem);
}
