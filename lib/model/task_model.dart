import 'package:task_manager/model/user_model.ts.dart';

class TaskModel {
  String? _id;
  late String id;
  late String title;
  List<String>? tags;
  late bool done = false;
  late UserModel? assigned;

  TaskModel(String id, String title, {done: false, assigned: null}) {
    this.id = id;
    this.title = title;
    this.done = done;
    this.assigned = assigned;
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'done': done.toString(),
    'assigned': assigned?.id == null ? '' : assigned?.id,
    'id': id
  };

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['firstName'];
    title = json['lastName'];
    done = json['username'];
    assigned = json['assigned'] != null
        ? new UserModel.fromJson(json['assigned'])
        : new UserModel('', '', '', '');
  }
}
