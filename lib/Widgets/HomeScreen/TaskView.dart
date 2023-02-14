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
  final _taskBodyController = TextEditingController();
  final _taskHeadingController = TextEditingController();

  late String taskBody;
  late String taskHeading;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _taskBodyController.dispose();
    _taskHeadingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.start) {
      setState(() {
        taskBody = widget.task.taskBody;
        taskHeading = widget.task.taskHeading;
        widget.start = false;
      });
    }

    final dateTime = DateTime.fromMillisecondsSinceEpoch(widget.task.createdOn,
        isUtc: false);

    final List fullMonths = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return Scaffold(
      body: Container(
          decoration:
              BoxDecoration(color: Provider.of<Settings>(context).getColor5),
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
                              _taskBodyController.text = widget.task.taskBody;
                              _taskHeadingController.text =
                                  widget.task.taskHeading;
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
                          )),
                      Text(
                        "${dateTime.hour}:${dateTime.minute}  ${Provider.of<Task>(context).getDays(dateTime.day)} ${fullMonths[dateTime.month - 1]}",
                      )
                    ],
                  ),
                  if (isEditing)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(children: [
                        TextField(
                          controller: _taskHeadingController,
                          textInputAction: TextInputAction.done,
                          // expands: true,
                          maxLines: null,
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: "Edit Task Here",
                          ),
                        ),
                        TextField(
                          controller: _taskBodyController,
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
                                          widget.task,
                                          _taskHeadingController.text,
                                          _taskBodyController.text);
                                  // Navigator.of(context).pop();
                                  setState(() {
                                    taskBody = _taskBodyController.text;
                                    taskHeading = _taskHeadingController.text;
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
                      child: Hero(
                        tag: widget.task.id,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.task.taskHeading,
                              style: TextStyle(fontSize: 17),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(widget.task.taskBody)
                          ],
                        ),
                      ),
                    ),
                ],
              )
            ],
          )),
    );
  }
}
