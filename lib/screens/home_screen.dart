import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController _taskController = TextEditingController();

  List<String> _tasks = [];

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _refreshTasks();
  }

  void _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _tasks = prefs.getStringList('tasks') ?? [];
    });
  }

  void _updatePrefs() async {
    await prefs.remove('tasks');
    setState(() {
      prefs.setStringList('tasks', _tasks);
    });
  }

  void _refreshTasks() async {
    setState(() {
      _tasks;
      _updatePrefs();
      print(_tasks);
    });
  }

   void _addItem() async {
    if (_taskController.text.isNotEmpty) {
      String data = _taskController.text;
      _tasks.add(data);
      _taskController.clear();
      _refreshTasks();
    }
  }

  void _updateItem(String task) async {
    if (_taskController.text.isNotEmpty) {
      String data = _taskController.text;
      _tasks[_tasks.indexOf(task)] = data;
      print("Index Of: ${_tasks.indexOf(task)}");
      _taskController.clear();
      _refreshTasks();
    }
  }

  void _deleteItem(String task) async {
    _tasks.remove(task);
    print("After Deleted: $_tasks");
    _refreshTasks();
  }

  void _showForm({String? task}) {
    if (task != null) {
      final existingItem = _tasks[_tasks.indexOf(task)];
      _taskController.text = existingItem;
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
              title: Text(item),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showForm(task: item),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteItem(item),
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
