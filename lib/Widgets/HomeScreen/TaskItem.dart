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

    return GestureDetector(
      onTap: () {
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black45,
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            final curvedValue =
                Curves.easeInOutBack.transform(animation.value) - 1.0;

            return Transform(
              transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
              child: child,
            );
          },
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.task.taskHeading,
                                style: TextStyle(fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(widget.task.taskBody)
                            ],
                          ),
                        )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Text(
                      //   "${dateTime.hour}:${dateTime.minute} ${dateTime.day}/${dateTime.month}/${dateTime.year}",
                      //   style: const TextStyle(fontSize: 11),
                      // )
                      Padding(
                        padding: EdgeInsets.only(right: 18),
                        child: Text(
                          "${dateTime.hour}:${dateTime.minute}  ${Provider.of<Task>(context).getDays(dateTime.day)} ${fullMonths[dateTime.month - 1]}",
                          overflow: TextOverflow.ellipsis,
                        ),
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
                activeColor: Provider.of<Settings>(context).getPrimary,
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
