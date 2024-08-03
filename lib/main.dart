import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/app_database.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/todo_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Provider.debugCheckInvalidValueType = null;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => TodoProvider(AppDatabase()),
      child: MaterialApp(
        title: 'Todo App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
