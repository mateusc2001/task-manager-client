import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager/main.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/screen/util/dialog_box.dart';
import 'package:task_manager/screen/util/todo_tiles.dart';

class DesktopBody extends StatefulWidget {
  const DesktopBody({Key? key}) : super(key: key);

  @override
  State<DesktopBody> createState() => _DesktopBodyState();
}

class _DesktopBodyState extends State<DesktopBody> {
  final newTaskController = TextEditingController();

  List tasks = [];

  @override
  void initState() {
    super.initState();
    getAllTasks();
  }

  getAllTasks() async {
    final response = await http.get(Uri.parse('$SERVER_IP/task'));
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

  deleteTask(taskId) async {
    http
        .delete(Uri.parse('$SERVER_IP/task/' + taskId))
        .then((value) => getAllTasks());
  }

  Future<http.Response> updateTaskAsDone(taskId, bool? status) {
    final url = '$SERVER_IP/task/' + taskId;
    return http.put(Uri.parse(url), body: {"done": status.toString()});
  }

  updateTask(TaskModel task) async {
    task.title = newTaskController.text;
    final url = '$SERVER_IP/task/' + task.id;
    final res = await http.put(Uri.parse(url), body: {
      "title": task.title,
      "done": task.done.toString()
    });
    getAllTasks();
    Navigator.of(context).pop();
  }

  createNewTaskRestClient() async {
    final url = '$SERVER_IP/task';
    final result = await http
        .post(Uri.parse(url), body: {"title": newTaskController.text});
    final responseJson = json.decode(result.body);
    setState(() {
      this.tasks.add(new TaskModel(responseJson['_id'], responseJson['title']));
    });
    Navigator.of(context).pop();
  }

  void createNewTask({taskModel = null}) {
    final isEditMode = taskModel != null;
    if (isEditMode) {
      newTaskController.text = taskModel.title;
    }
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
              controller: newTaskController,
              onSave: () {
                if (isEditMode) {
                  updateTask(taskModel);
                } else {
                  createNewTaskRestClient();
                }
              },
              onCancel: () {
                Navigator.of(context).pop();
              },
              taskModel: taskModel);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        elevation: 0,
        title: Text('DESKTOP - ' +
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
              action: (status) => setAsDone(status, task.id),
              deleteAction: (context) => deleteTask(task.id),
              updateAction: (context) => createNewTask(taskModel: task));
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
    );
  }
}
