import 'package:dtask/Provider/Task.dart';
import 'package:dtask/Widgets/HomeScreen/TaskItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  bool isSearching;
  Home({super.key, required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
          childAspectRatio: 4 / 3),
      itemCount: isSearching
          ? Provider.of<Task>(context).getSearchedTaskListLength
          : Provider.of<Task>(context).getTaskListLength,
      itemBuilder: (context, index) {
        final task = isSearching
            ? Provider.of<Task>(context).getSearchedTaskList[index]
            : Provider.of<Task>(context).getTaskList[index];

        return TaskItem(
          task: task,
          isDrag: true,
        );
      },
    );
  }
}
