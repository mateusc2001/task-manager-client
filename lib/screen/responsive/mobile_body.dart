import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager/constants/api.env.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/screen/util/dialog_box.dart';
import 'package:task_manager/screen/util/todo_tiles.dart';

class MobileBody extends StatefulWidget {
  const MobileBody({Key? key}) : super(key: key);

  @override
  State<MobileBody> createState() => _MobileBodyState();
}

class _MobileBodyState extends State<MobileBody> {
  final newTaskController = TextEditingController();

  List tasks = [];

  @override
  void initState() {
    super.initState();
    getAllTasks();
  }

  getAllTasks() async {
    final response = await http.get(Uri.parse('${ApiEnvConstants.baseUrl}/task'));
    List jsonResponse = json.decode(response.body);
    setState(() {
      tasks = [];
    });
    for (var i = 0; i < jsonResponse.length; i++) {
      setState(() {
        final task = jsonResponse[i];
        tasks
            .add(new TaskModel(task['_id'], task['title'], done: task['done']));
      });
    }
  }

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  setAsDone(bool? status, String taskId) async {
    updateTaskAsDone(taskId, status).then((value) {
      setState(() {
        tasks.firstWhere((element) => element.id == taskId).done = status;
      });
    });
  }

  Future<http.Response> updateTaskAsDone(taskId, bool? status) {
    final url = '${ApiEnvConstants.baseUrl}/task/' + taskId;
    return http.put(Uri.parse(url), body: {"done": status.toString()});
  }

  createNewTaskRestClient() async {
    final url = '${ApiEnvConstants.baseUrl}/task';
    final result = await http
        .post(Uri.parse(url), body: {"title": newTaskController.text});
    final responseJson = json.decode(result.body);
    setState(() {
      this.tasks.add(new TaskModel(responseJson['_id'], responseJson['title']));
    });
    Navigator.of(context).pop();
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
              controller: newTaskController,
              onSave: createNewTaskRestClient,
              onCancel: () {
                Navigator.of(context).pop();
              });
        });
  }

  deleteTask(taskId) async {
    http
        .delete(Uri.parse('${ApiEnvConstants.baseUrl}/task/' + taskId))
        .then((value) => getAllTasks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        elevation: 0,
        title: Text('MOBILE - ' +
            (DateTime.now().hour - 12).toString() +
            'h' +
            DateTime.now().minute.toString() +
            (DateTime.now().hour > 12 ? 'PM' : 'AM')),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: ((context, index) {
          var task = tasks[index];
          return ToDoTile(
              taskModel: task,
              users: [],
              reloadTasks: (_) {},
              action: (status) => setAsDone(status, task.id),
              deleteAction: (context) => deleteTask(task.id),
              updateAction: (context) => createNewTask(),
              deleteAssignedAction: () {});
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
    );
  }
}
