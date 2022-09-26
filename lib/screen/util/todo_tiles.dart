import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_manager/model/task_model.dart';

class ToDoTile extends StatelessWidget {
  final TaskModel taskModel;
  Function(bool?)? action;
  Function(BuildContext)? deleteAction;
  Function(BuildContext)? updateAction;

  ToDoTile(
      {super.key,
      required this.taskModel,
      required this.action,
      required this.deleteAction,
      required this.updateAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Slidable(
          startActionPane: ActionPane(
            motion: StretchMotion(),
            children: [
              SlidableAction(
                onPressed: updateAction,
                icon: Icons.edit,
                backgroundColor: Colors.green,
              )
            ],
          ),
          endActionPane: ActionPane(
            motion: StretchMotion(),
            children: [
              SlidableAction(
                onPressed: deleteAction,
                icon: Icons.delete_forever,
                backgroundColor: Colors.red,
              )
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(2)),
            child: Row(
              children: [
                Checkbox(
                    activeColor: Colors.deepPurple,
                    value: taskModel.done == true,
                    onChanged: action),
                Text(
                  taskModel.title,
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                      decoration: taskModel.done
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                )
              ],
            ),
          ),
        ));
  }
}
