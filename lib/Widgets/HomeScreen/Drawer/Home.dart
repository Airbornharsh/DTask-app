import 'package:dtask/Provider/Task.dart';
import 'package:dtask/Widgets/HomeScreen/TaskItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
          childAspectRatio: 4 / 3),
      itemCount: Provider.of<Task>(context).getTaskListLength,
      itemBuilder: (context, index) {
        final task = Provider.of<Task>(context).getTaskList[index];

        return TaskItem(
          task: task,
        );
      },
    );
  }
}
