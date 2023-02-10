import 'package:dtask/Provider/Settings.dart';
import 'package:dtask/Provider/Task.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditTask extends StatefulWidget {
  TaskModel task;
  EditTask({super.key, required this.task});
  bool start = true;

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final _taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.start) {
      setState(() {
        // _taskController.text = widget.task.taskName;
        widget.start = false;
      });
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: [
        TextField(
          controller: _taskController,
          textInputAction: TextInputAction.done,
          // expands: true,
          maxLines: null,
          autofocus: true,
          decoration: const InputDecoration(
            label: Text("Note"),
            hintText: "Edit Task Here",
          ),
        ),
        TextButton(
            onPressed: () {
              Provider.of<Task>(context, listen: false)
                  .editTask(widget.task, _taskController.text);
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                    Provider.of<Settings>(context).getPrimary)),
            child: const Text(
              "Edit",
              style: TextStyle(color: Colors.white),
            ))
      ]),
    );
  }
}
