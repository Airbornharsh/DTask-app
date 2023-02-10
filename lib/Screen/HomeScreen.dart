import 'package:dtask/Provider/Settings.dart';
import 'package:dtask/Provider/Task.dart';
import 'package:dtask/Widgets/HomeScreen/AddTask.dart';
import 'package:dtask/Widgets/HomeScreen/TaskItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  bool start = true;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.start) {
      Provider.of<Task>(context).onLoad();
      setState(() {
        widget.start = false;
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text("DTask")),
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Container(
            padding: const EdgeInsets.all(4),
            decoration:
                BoxDecoration(color: Provider.of<Settings>(context).getPrimary),
            child: IconButton(
              onPressed: () async {
                await showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return const AddTask();
                    });
              },
              icon: Icon(
                Icons.add,
                size: 30,
                color: Colors.grey.shade200,
              ),
              tooltip: "Add",
            )),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          // DragTarget(
          //   onAccept: (data) {
          //     print(data);
          //   },
          //   builder: (context, candidateData, rejectedData) {
          //     return const Icon(Icons.delete);
          //   },
          // ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GridView.builder(
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
              ),
            ),
          )
        ],
      ),
    );
  }
}
