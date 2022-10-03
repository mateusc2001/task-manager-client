import 'package:flutter/material.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/screen/util/my_button.dart';

class DialogBox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final TaskModel? taskModel;

  const DialogBox(
      {Key? key,
      required this.controller,
      required this.onSave,
      required this.onCancel,
      this.taskModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromRGBO(40, 40, 40, 1),
      title: Text(taskModel != null ? 'Editando tarefa' : 'Nova tarefa',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300)),
      content: Container(
        height: 120,
        width: 600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextField(
              controller: controller,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                  hintText: "Descrição da tarefa",
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: MyButton(text: 'Cancelar', action: onCancel)),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: MyButton(text: 'Salvar', action: onSave),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
