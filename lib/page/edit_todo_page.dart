import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/todo.dart';
import '../provider/todos.dart';
import '../utils/shared_preference_helper.dart';
import '../utils/utils.dart';
import '../widget/todo_form_widget.dart';

class EditTodoPage extends StatefulWidget {
  Todo? todo;

  EditTodoPage({Key? key, this.todo}) : super(key: key);

  @override
  _EditTodoPageState createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  final _formKey = GlobalKey<FormState>();

  late String title;
  late String description;

  @override
  void initState() {
    super.initState();

    title = widget.todo?.title ?? "";
    description = widget.todo?.description ?? "";
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(widget.todo != null ? 'Edit Todo' : 'Add Todo', style: TextStyle(color: Colors.white)),
          actions: [
            widget.todo != null ? IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                final provider =
                    Provider.of<TodosProvider>(context, listen: false);
                provider.removeTodo(widget.todo!);

                Navigator.of(context).pop();
              },
            ) : SizedBox.shrink()
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: TodoFormWidget(
              title: title,
              description: description,
              onChangedTitle: (title) => setState(() => this.title = title),
              onChangedDescription: (description) =>
                  setState(() => this.description = description),
              onSavedTodo: widget.todo != null ? saveTodo : addTodo,
            ),
          ),
        ),
      );

  void saveTodo() {
    final isValid = _formKey.currentState?.validate();

    if (!isValid!) {
      return;
    } else {
      final provider = Provider.of<TodosProvider>(context, listen: false);

      provider.updateTodo(widget.todo!, title, description);

      Navigator.of(context).pop();
    }
  }

  void addTodo() {
    final isValid = _formKey.currentState?.validate();

    if (!isValid!) {
      return;
    } else {
      final todo = Todo(
        id: DateTime.now().toString(),
        userId: SharedPreferenceHelper().userId,
        title: title,
        description: description,
        createdTime: Utils.fromDateTimeToTimeStamp(DateTime.now()),
      );

      final provider = Provider.of<TodosProvider>(context, listen: false);
      provider.addTodo(todo);

      Navigator.of(context).pop();
    }
  }
}
