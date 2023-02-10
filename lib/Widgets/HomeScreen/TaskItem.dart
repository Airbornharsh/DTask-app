import 'package:dtask/Provider/Task.dart';
import 'package:dtask/Widgets/HomeScreen/AddTask.dart';
import 'package:dtask/Widgets/HomeScreen/EditTask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TaskItem extends StatelessWidget {
  TaskModel task;
  bool isDrag;
  TaskItem({super.key, required this.task, required this.isDrag});

  @override
  Widget build(BuildContext context) {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(task.createdOn, isUtc: false);

    return GestureDetector(
      onTap: () {},
      onDoubleTap: () {
        // Provider.of<Task>(context, listen: false).editTask(task, "Hesdcs");
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return EditTask(task: task);
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(7)),
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
