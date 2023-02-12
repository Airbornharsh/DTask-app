import 'package:dtask/Provider/Settings.dart';
import 'package:dtask/Provider/Task.dart';
import 'package:dtask/Widgets/HomeScreen/TaskItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Months extends StatefulWidget {
  const Months({super.key});

  @override
  State<Months> createState() => _MonthsState();
}

class _MonthsState extends State<Months> {
  List<bool> isSelected = [];

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
        isSelected.add(false);
        if (Provider.of<Task>(context).isListSelected(taskMonthList[index]) &&
            taskMonthList[index].isNotEmpty) {
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
              title: Text(months[date.month - index - 1]),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    Text("${taskMonthList[index].length} Items"),
                    Checkbox(
                      activeColor: Provider.of<Settings>(context).getPrimary,
                      value: isSelected[index],
                      onChanged: (value) {
                        setState(() {
                          isSelected[index] = value!;
                          if (value) {
                            Provider.of<Task>(context, listen: false)
                                .addSelectedListTask(taskMonthList[index]);
                          } else {
                            Provider.of<Task>(context, listen: false)
                                .removeSelectedListTask(taskMonthList[index]);
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
            ),
          ),
        );
      },
    );
  }
}
