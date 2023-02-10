import 'package:dtask/Provider/Task.dart';
import 'package:flutter/material.dart';

class TaskItem extends StatefulWidget {
  TaskModel task;
  TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(widget.task.createdOn,
        isUtc: false);

    return GestureDetector(
      onTap: () {},
      child: Draggable(
        data: widget.task.id,
        feedback: const Icon(
          Icons.file_copy,
          size: 60,
        ),
        childWhenDragging: Container(),
        child: Container(
          decoration: BoxDecoration(color: Colors.grey.shade300),
          padding: const EdgeInsets.all(10),
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
    );
  }
}
