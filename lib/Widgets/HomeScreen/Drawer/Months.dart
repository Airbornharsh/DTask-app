import 'package:dtask/Provider/Task.dart';
import 'package:dtask/Widgets/HomeScreen/TaskItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Months extends StatelessWidget {
  const Months({super.key});

  @override
  Widget build(BuildContext context) {
    final taskMonthList = Provider.of<Task>(context).getTaskMonthList;
    final date = DateTime.now();

    List months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return ListView.builder(
      itemCount: Provider.of<Task>(context).getTaskMonthListLength,
      itemBuilder: (context, index) {
        return ExpansionTile(
          title: Text(months[date.month - index - 1]),
          trailing: Text("${taskMonthList[index].length} Items"),
          children: [
            SizedBox(
              height: 300,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                    childAspectRatio: 4 / 3),
                itemCount: taskMonthList[index].length,
                itemBuilder: (context, i) {
                  return TaskItem(
                    task: taskMonthList[index][i],
                    isDrag: false,
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}
