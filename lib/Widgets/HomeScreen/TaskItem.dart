import 'package:dtask/Provider/Settings.dart';
import 'package:dtask/Provider/Task.dart';
import 'package:dtask/Widgets/HomeScreen/EditTask.dart';
import 'package:flutter/material.dart';
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
      onLongPress: () {
        final alert = AlertDialog(
          title: const Text("Alert"),
          content: const Text("Want to Delete"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.close,
                )),
            IconButton(
                onPressed: () {
                  Provider.of<Task>(context, listen: false).deleteTask(task);
                },
                icon: const Icon(Icons.delete))
          ],
        );

        showDialog(
          context: context,
          builder: (context) => alert,
        );
      },
      onDoubleTap: () {
        final alert = AlertDialog(
          title: const Text("Alert"),
          content: const Text("Want to Edit"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close)),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return EditTask(task: task);
                    },
                  );
                },
                icon: const Icon(Icons.edit))
          ],
        );

        showDialog(
          context: context,
          builder: (context) => alert,
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
