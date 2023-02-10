import 'package:dtask/Provider/Settings.dart';
import 'package:dtask/Provider/Task.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _taskController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _taskController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        TextField(
          controller: _taskController,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          // expands: true,
          maxLines: null,
          onEditingComplete: () {
            print("ok");
          },
          autofocus: true,
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          decoration: const InputDecoration(
            label: Text("Note"),
            hintText: "Enter Your Task Here",
          ),
        ),
        TextButton(
            onPressed: () {
              Provider.of<Task>(context,listen: false).addTask(_taskController.text);
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                    Provider.of<Settings>(context).getPrimary)),
            child: const Text(
              "ADD",
              style: TextStyle(color: Colors.white),
            ))
      ]),
    );
  }
}
