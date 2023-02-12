import 'package:dtask/Provider/Settings.dart';
import 'package:dtask/Provider/Task.dart';
import 'package:dtask/Widgets/HomeScreen/TaskItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Days extends StatefulWidget {
  const Days({super.key});

  @override
  State<Days> createState() => _DaysState();
}

class _DaysState extends State<Days> {
  List<bool> isSelected = [];

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
        isSelected.add(false);
        if (Provider.of<Task>(context).isListSelected(taskDayList[index]) &&
            taskDayList[index].isNotEmpty) {
          isSelected[index] = true;
        }
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
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    Text("${taskDayList[index].length} Items"),
                    Checkbox(
                      activeColor: Provider.of<Settings>(context).getPrimary,
                      value: isSelected[index],
                      onChanged: (value) {
                        setState(() {
                          isSelected[index] = value!;
                          if (value) {
                            Provider.of<Task>(context, listen: false)
                                .addSelectedListTask(taskDayList[index]);
                          } else {
                            Provider.of<Task>(context, listen: false)
                                .removeSelectedListTask(taskDayList[index]);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
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
