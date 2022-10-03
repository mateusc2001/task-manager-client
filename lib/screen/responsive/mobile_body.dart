import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager/constants/api.env.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/model/user_model.ts.dart';
import 'package:task_manager/screen/CustomAppBar.dart';
import 'package:task_manager/screen/util/dialog_box.dart';
import 'package:task_manager/screen/util/todo_tiles.dart';
import 'package:task_manager/service/task_api.service.ts.dart';

class MobileBody extends StatefulWidget {
  const MobileBody({Key? key}) : super(key: key);

  @override
  State<MobileBody> createState() => _MobileBodyState();
}

class _MobileBodyState extends State<MobileBody> {
  final TaskApiService taskApiService = TaskApiService();
  final newTaskController = TextEditingController();

  List<TaskModel> tasks = [];
  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    getAllTasks();
    getAllUsers();
  }

  getAllUsers() async {
    users = await taskApiService.findAllUsers();
  }

  updateScreen(idUser, taskId) async {
    await taskApiService.assignUserInTask(taskId, idUser);
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
        final assigned = task['assigned'];
        if (assigned != null) {
          tasks.add(new TaskModel(task['_id'], task['title'],
              done: task['done'], assigned: new UserModel.fromJson(assigned)));
        } else {
          tasks.add(
              new TaskModel(task['_id'], task['title'], done: task['done']));
        }
      });
    }

    tasks.sort((a, b) => a.assigned != null ? 0 : 1);
  }

  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(title: Text(title), content: Text(text)),
  );

  setAsDone(bool? status, String taskId) async {
    updateTaskAsDone(taskId, status).then((value) {
      setState(() {
        if (status != null) {
          tasks.firstWhere((element) => element.id == taskId).done = status;
        }
      });
    });
  }

  deleteTask(taskId) async {
    http
        .delete(Uri.parse('${ApiEnvConstants.baseUrl}/task/' + taskId))
        .then((value) => getAllTasks());
  }

  Future<http.Response> updateTaskAsDone(taskId, bool? status) {
    final url = '${ApiEnvConstants.baseUrl}/task/' + taskId;
    return http.put(Uri.parse(url), body: {"done": status.toString()});
  }

  updateTask(TaskModel task, {backScree: true}) async {
    final url = '${ApiEnvConstants.baseUrl}/task/' + task.id;

    final body = {"title": task.title, "done": task.done.toString()};

    final res = await http.put(Uri.parse(url), body: body);
    getAllTasks();
    if (backScree) {
      Navigator.of(context).pop();
    }
  }

  updateTaskDeleteAssigned(TaskModel task) async {
    final url = '${ApiEnvConstants.baseUrl}/task/delete/assigned/' + task.id;
    final res = await http.delete(Uri.parse(url));
    getAllTasks();
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
                  taskModel.title = newTaskController.text;
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
      body: Column(
        children: [
          Flexible(child: Container(
            constraints: BoxConstraints(maxHeight: 200),
            color: Colors.red,
            child: CustomAppBar(),
          )),
          Expanded(child: mainBody())
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
    );
  }

  mainBody() {
    return Container(
      width: MediaQuery.of(context).size.width > 1500
          ? 1500
          : MediaQuery.of(context).size.width,
      child: RefreshIndicator(
        onRefresh: () => getAllTasks(),
        child: Column(
          children: [
            Expanded(child: getTodoList(false)),
            Expanded(child: getTodoList(true))
          ],
        ),
      ),
    );
  }

  Widget getTodoList(status) {
    List itens = tasks.where((element) => element.done == status).toList();
    return ListView.builder(
      itemCount: itens.length,
      itemBuilder: ((context, index) {
        var task = itens[index];
        return ToDoTile(
            taskModel: task,
            users: users,
            reloadTasks: (idUser) => updateScreen(idUser, task.id),
            action: (status) => setAsDone(status, task.id),
            deleteAction: (context) => deleteTask(task.id),
            updateAction: (context) => createNewTask(taskModel: task),
            deleteAssignedAction: () => updateTaskDeleteAssigned(task));
      }),
    );
  }

  filterTask(List<TaskModel> itens, status) {
    return itens.where((element) => element.done == status);
  }
}
