import 'package:dtask/Provider/Settings.dart';
import 'package:dtask/Provider/Task.dart';
import 'package:dtask/Widgets/HomeScreen/TaskView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskItem extends StatefulWidget {
  TaskModel task;
  bool isDrag;

  TaskItem({super.key, required this.task, required this.isDrag});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool isDeleted = false;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(widget.task.createdOn,
        isUtc: false);

    setState(() {
      isSelected = Provider.of<Task>(context).isSelected(widget.task.id);
    });

    return GestureDetector(
      onTap: () {
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black45,
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (context, animation, secondaryAnimation) {
            return Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.height - 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: TaskView(task: widget.task),
                ),
              ),
            );
          },
        );
      },
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Provider.of<Settings>(context)
                                  .getSelectedFilterIndex ==
                              0
                          ? Colors.white
                          : Provider.of<Settings>(context).getColor4,
                      borderRadius: BorderRadius.circular(7)),
                  padding: const EdgeInsets.all(7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GridTile(
                            child: Hero(
                          tag: widget.task.id,
                          child: Text(widget.task.taskName),
                        )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${dateTime.hour}:${dateTime.minute} ${dateTime.day}/${dateTime.month}/${dateTime.year}",
                        style: const TextStyle(fontSize: 11),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
              right: -7,
              bottom: -7,
              child: Checkbox(
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    isSelected = value!;
                  });
                  if (value!) {
                    Provider.of<Task>(context, listen: false)
                        .addSelectedTask(widget.task.id);
                  } else {
                    Provider.of<Task>(context, listen: false)
                        .removeSelectedTsak(widget.task.id);
                  }
                },
              )),
        ],
      ),
    );
  }
}
