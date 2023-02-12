import 'package:dtask/Provider/Settings.dart';
import 'package:dtask/Provider/Task.dart';
import 'package:dtask/Widgets/HomeScreen/TaskItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Days extends StatelessWidget {
  const Days({super.key});

  @override
  Widget build(BuildContext context) {
    final taskDayList = Provider.of<Task>(context).getTaskDayList;
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
      itemCount: Provider.of<Task>(context).getTaskDayListLength,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 2),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(7)),
            child: ExpansionTile(
              backgroundColor: Provider.of<Settings>(context).getColor3,
              collapsedBackgroundColor:
                  Provider.of<Settings>(context).getColor3,
              title: Text(
                  "${Provider.of<Task>(context).getDays(date.day - index)} ${months[date.month - 1]}"),
              trailing: Text("${taskDayList[index].length} Items"),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  height: 300,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 3,
                            crossAxisSpacing: 3,
                            childAspectRatio: 4 / 3),
                    itemCount: taskDayList[index].length,
                    itemBuilder: (context, i) {
                      return TaskItem(
                        task: taskDayList[index][i],
                        isDrag: false,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
