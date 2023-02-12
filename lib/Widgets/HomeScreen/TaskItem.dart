import 'package:dtask/Provider/Settings.dart';
import 'package:dtask/Provider/Task.dart';
import 'package:dtask/Widgets/HomeScreen/TaskView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskItem extends StatelessWidget {
  TaskModel task;
  bool isDrag;
  bool isDeleted = false;
  TaskItem({super.key, required this.task, required this.isDrag});

  @override
  Widget build(BuildContext context) {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(task.createdOn, isUtc: false);

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
                  child: TaskView(task: task),
                ),
              ),
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: Provider.of<Settings>(context).getSelectedFilterIndex == 0
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
                tag: task.id,
                child: Text(task.taskName),
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
    );
  }
}
