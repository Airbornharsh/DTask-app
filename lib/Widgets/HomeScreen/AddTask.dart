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
  final _taskBodyController = TextEditingController();
  final _taskHeadingController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _taskBodyController.dispose();
    _taskHeadingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: [
        TextField(
          controller: _taskHeadingController,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          // expands: true,
          maxLines: null,
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          decoration: const InputDecoration(
            label: Text("Heading"),
            hintText: "Enter Your Heading",
          ),
        ),
        TextField(
          controller: _taskBodyController,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          // expands: true,
          maxLines: null,
          autofocus: true,
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          decoration: const InputDecoration(
            label: Text("Body"),
            hintText: "Enter Your Body",
          ),
        ),
        TextButton(
            onPressed: () {
              Provider.of<Task>(context, listen: false).addTask(
                  _taskHeadingController.text, _taskBodyController.text);
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
