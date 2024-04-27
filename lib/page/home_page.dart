import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/firebase_api.dart';
import '../main.dart';
import '../model/todo.dart';
import '../provider/todos.dart';
import '../utils/shared_preference_helper.dart';
import '../widget/completed_list_widget.dart';
import '../widget/todo_list_widget.dart';
import 'edit_todo_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
        setState(() {});
        break;
      case AppLifecycleState.inactive:
      // widget is inactive
        break;
      case AppLifecycleState.paused:
      // widget is paused
        break;
      case AppLifecycleState.detached:
      // widget is detached
        break;
      case AppLifecycleState.hidden:
      // widget is hidden
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [TodoListWidget(), CompletedListWidget(),
    ];

    return Scaffold(appBar: AppBar(centerTitle: true,
      backgroundColor: Theme
          .of(context)
          .primaryColor,
      title: Text(MyApp.title, style: TextStyle(color: Colors.white)),),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        selectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: (index) =>
            setState(() {
              selectedIndex = index;
            }),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check_outlined), label: 'Todos',),
          BottomNavigationBarItem(
            icon: Icon(Icons.done, size: 28), label: 'Completed',),
        ],),
      body: FutureBuilder<List<Todo>>(
        future: FirebaseApi().readTodos(SharedPreferenceHelper().userId), builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return buildText('Something Went Wrong Try later');
            } else {
              final todos = snapshot.data;
              if (todos != null) {
                final provider = Provider.of<TodosProvider>(context);
                provider.setTodos(todos);
              }

              return tabs[selectedIndex];
            }
        }
      },),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
        backgroundColor: Colors.black,
        onPressed: () =>
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EditTodoPage())).then((
                value) =>
                setState(() {
                })),
        child: Icon(Icons.add, color: Colors.white),),);
  }
}

Widget buildText(String text) =>
    Center(
      child: Text(text, style: TextStyle(fontSize: 24, color: Colors.white),),);
