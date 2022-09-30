import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/model/user_model.ts.dart';
import 'package:task_manager/service/task_api.service.ts.dart';

class ToDoTile extends StatefulWidget {
  final TaskModel taskModel;
  final List<UserModel> users;
  Function(bool?)? action;
  Function(BuildContext)? deleteAction;
  Function(BuildContext)? updateAction;
  Function()? deleteAssignedAction;
  ValueChanged<String> reloadTasks;

  ToDoTile(
      {super.key,
      required this.taskModel,
      required this.users,
      required this.action,
      required this.deleteAction,
      required this.updateAction,
      required this.deleteAssignedAction,
      required this.reloadTasks});

  @override
  State<ToDoTile> createState() => _ToDoTileState();
}

class _ToDoTileState extends State<ToDoTile> {
  final TaskApiService taskApiService = TaskApiService();
  int secondsToHideDelete = 0;

  String getInitials(String bank_account_name) => bank_account_name.isNotEmpty
      ? bank_account_name.trim().split(' ').map((l) => l[0]).take(2).join()
      : '';

  bool confirmDel = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Slidable(
          startActionPane: ActionPane(
            motion: StretchMotion(),
            children: [
              SlidableAction(
                onPressed: widget.updateAction,
                icon: Icons.edit,
                backgroundColor: Colors.green,
              )
            ],
          ),
          endActionPane: ActionPane(
            motion: StretchMotion(),
            children: [
              SlidableAction(
                onPressed: widget.deleteAction,
                icon: Icons.delete_forever,
                backgroundColor: Colors.red,
              )
            ],
          ),
          child: card(context),
        ));
  }

  Container card(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(2)),
      child: ListTile(
          leading: Checkbox(
              activeColor: Colors.deepPurple,
              value: widget.taskModel.done == true,
              onChanged: widget.action),
          title: Text(
            widget.taskModel.title,
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                decoration: widget.taskModel.done
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
          trailing: getChip()),
    );
  }

  Row row() {
    return Row(children: [
      Checkbox(
          activeColor: Colors.deepPurple,
          value: widget.taskModel.done == true,
          onChanged: widget.action),
      Flexible(
          child: Text(
        widget.taskModel.title,
        style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16,
            overflow: TextOverflow.ellipsis,
            decoration: widget.taskModel.done
                ? TextDecoration.lineThrough
                : TextDecoration.none),
      )),
      getChip()
    ]);
  }

  Widget getChip() {
    if (widget.taskModel.assigned != null) {
      return InkWell(
        onTap: () {
          setState(() {
            confirmDel = !confirmDel;
          });
          Timer(Duration(seconds: 5), () {
            setState(() {
              confirmDel = !confirmDel;
            });
          });
        },
        child: Chip(
          backgroundColor: confirmDel ? Colors.redAccent : Colors.transparent,
          avatar: confirmDel
              ? null
              : CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                  child: Text(getInitials(nullableString(
                          widget.taskModel.assigned?.firstName) +
                      nullableString(widget.taskModel.assigned?.firstName))),
                ),
          label: confirmDel
              ? areYouShureButton()
              : Text(nullableString(widget.taskModel.assigned?.firstName)),
        ),
      );
    }
    return PopupMenuButton(itemBuilder: (_) {
      return widget.users.map((e) {
        return PopupMenuItem(
          onTap: () => widget.reloadTasks(e.id),
          child: Text(
            e.firstName,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        );
      }).toList();
    }, onSelected: (value) {
      log(value);
    });
  }

  nullableString(text) {
    return text != null ? text : '';
  }

  areYouShureButton() {
    return MaterialButton(
      onPressed: widget.deleteAssignedAction,
      child: Text('Are you shure?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300)),
    );
  }

  Container containerTile(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(2)),
      child: Row(
        children: [
          Checkbox(
              activeColor: Colors.deepPurple,
              value: widget.taskModel.done == true,
              onChanged: widget.action),
          Flexible(
              child: Text(
            widget.taskModel.title,
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                decoration: widget.taskModel.done
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          )),
          getChip()
        ],
      ),
    );
  }
}
