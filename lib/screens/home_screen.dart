import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController _taskController = TextEditingController();

  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  void _refreshTasks() async {
    setState(() {
      _tasks;
      print(_tasks);
    });
  }

   void _addItem() async {
    if (_taskController.text.isNotEmpty) {
      String data = _taskController.text;
      _tasks.add({'task': data});
      _taskController.clear();
      _refreshTasks();
    }
  }

  void _updateItem(String task) async {
    if (_taskController.text.isNotEmpty) {
      String data = _taskController.text;
      _tasks[_tasks.indexWhere((item) => item['task'] == task)] = {'task': data};
      _taskController.clear();
      _refreshTasks();
    }
  }

  void _deleteItem(String task) async {
    _tasks.removeWhere((item) => item['task'] == task);
    _refreshTasks();
  }

  void _showForm({String? task}) {
    if (task != null) {
      final existingItem = _tasks.firstWhere((item) => item['task'] == task);
      _taskController.text = existingItem['task'];
    } else {
      _taskController.clear();
    }

    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(labelText: 'Task'),
            ),
            ElevatedButton(
              onPressed: () {
                if (task == null) {
                  _addItem();
                } else {
                  _updateItem(task);
                }
                Navigator.of(context).pop();
              },
              child: Text(task == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo list')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            final item = _tasks[index];
            return ListTile(
              title: Text(item['task']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showForm(task: item['task']),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteItem(item['task']),
                  ),
                ],
              ),
            );
          }, separatorBuilder: (BuildContext context, int index) {  return Divider(); },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
