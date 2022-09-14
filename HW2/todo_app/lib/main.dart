import 'package:flutter/material.dart';

void main() => runApp(const TodoDemoListApp());

// Every component in Flutter is a widget, even the whole app itself
class TodoDemoListApp extends StatelessWidget {
  const TodoDemoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To-do List Demo',
        home: TodoList());
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  createState() => TodoDemoListState();
}

class TodoDemoListState extends State<TodoList> {
  List<String> todoItemsArrayList = [];

  void addTodoItemList(String task) {
    // Only add the task if the user actually entered something
    if (task.isNotEmpty) {
      // Putting our code inside "setState" tells the app that our state has changed, and
      // it will automatically re-render the list
      setState(() => todoItemsArrayList.add(task));
    }
  }

  void deleteTodoListItem(int index) {
    setState(() => todoItemsArrayList.removeAt(index));
  }

  void onTapDeleteTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                  'List item "${todoItemsArrayList[index]}" is completed?'),
              actions: <Widget>[
                OutlinedButton(
                    child: const Text('CANCEL'),
                    // The alert is actually part of the navigation stack, so to close it, we
                    // need to pop it.
                    onPressed: () => Navigator.of(context).pop()),
                OutlinedButton(
                    child: const Text('COMPLETED'),
                    onPressed: () {
                      deleteTodoListItem(index);
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  // Build the whole list of todo items
  Widget appBarBuildTodoList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index < todoItemsArrayList.length) {
          return buildSingleTodoItem(todoItemsArrayList[index], index);
        } else {
          // return empty todo item as placeholder
          return buildEmptyTodoItem("");
        }
      },
    );
  }

  // Build an empty todo item to get around error of appBarBuildTodoList()
  // returning null when if condition isn't met
  Widget buildEmptyTodoItem(String todoText) {
    return ListTile(title: Text(todoText));
  }

  // Build a single todo item
  Widget buildSingleTodoItem(String todoText, int index) {
    return ListTile(
        title: Text(todoText), onTap: () => onTapDeleteTodoItem(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: appBarBuildTodoList(),
      floatingActionButton: FloatingActionButton(
          onPressed: newAddTodoScreen,
          tooltip: 'Do Add task',
          child: const Icon(Icons.add)),
    );
  }

  void newAddTodoScreen() {
    // Push this page onto the stack
    Navigator.of(context).push(
        // MaterialPageRoute will automatically animate the screen entry, as well as adding
        // a back button to close it
        MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(title: const Text('Add a new task')),
          body: TextField(
            autofocus: true,
            onSubmitted: (val) {
              addTodoItemList(val);
              Navigator.pop(context); // Close the add todo screen
            },
            decoration: const InputDecoration(
                hintText: 'Enter list to do...',
                contentPadding: EdgeInsets.all(16.0)),
          ));
    }));
  }
}
