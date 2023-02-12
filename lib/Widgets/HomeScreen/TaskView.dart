import 'package:dtask/Provider/Settings.dart';
import 'package:dtask/Provider/Task.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskView extends StatefulWidget {
  TaskModel task;
  TaskView({super.key, required this.task});
  bool start = true;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  bool isEditing = false;
  final _taskController = TextEditingController();
  late String taskName;

  @override
  Widget build(BuildContext context) {
    if (widget.start) {
      setState(() {
        print("Hii");
        taskName = widget.task.taskName;
        widget.start = false;
      });
    }

    return Scaffold(
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Stack(
            children: [
              Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Provider.of<Settings>(context, listen: false)
                            .getPrimary,
                      ))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              _taskController.text = widget.task.taskName;
                              isEditing = true;
                              widget.start = false;
                            });
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Provider.of<Settings>(context, listen: false)
                                .getPrimary,
                          )),
                      IconButton(
                          onPressed: () {
                            final alert = AlertDialog(
                              title: const Text("Alert"),
                              content: const Text("Want to Delete"),
                              actions: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: Provider.of<Settings>(context,
                                              listen: false)
                                          .getPrimary,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      Provider.of<Task>(context, listen: false)
                                          .deleteTask(widget.task);
                                      Navigator.of(context).popUntil(
                                        (route) => route.settings.name == "/",
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Provider.of<Settings>(context,
                                              listen: false)
                                          .getPrimary,
                                    ))
                              ],
                            );

                            showDialog(
                              context: context,
                              builder: (context) => alert,
                            );
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Provider.of<Settings>(context, listen: false)
                                .getPrimary,
                          ))
                    ],
                  ),
                  if (isEditing)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(children: [
                        TextField(
                          controller: _taskController,
                          textInputAction: TextInputAction.done,
                          // expands: true,
                          maxLines: null,
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: "Edit Task Here",
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    isEditing = false;
                                  });
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            Provider.of<Settings>(context)
                                                .getPrimary)),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.white),
                                )),
                            const SizedBox(width: 10),
                            TextButton(
                                onPressed: () {
                                  Provider.of<Task>(context, listen: false)
                                      .editTask(
                                          widget.task, _taskController.text);
                                  // Navigator.of(context).pop();
                                  setState(() {
                                    taskName = _taskController.text;
                                    isEditing = false;
                                  });
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            Provider.of<Settings>(context)
                                                .getPrimary)),
                                child: const Text(
                                  "Update",
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        ),
                      ]),
                    ),
                  if (!isEditing)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(taskName),
                    ),
                ],
              )
            ],
          )),
    );
  }
}
