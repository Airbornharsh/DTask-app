import 'package:dtask/Provider/Settings.dart';
import 'package:dtask/Provider/Task.dart';
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
              onPressed: () {
                Provider.of<Task>(context, listen: false).addTask(
                    "Hii There nfvn k sjidjcis cs ci jsij isc siojc isjic sc sijci sicjs iiscjisjci ciosjisjijiohdios huHu hsdH iauih fsiuiv isuiR SFjljxiokxvnjkagUI jdi dgfid udx gd dzj srf i jshdc isj i cdsiosdcv usdfd vjc s sioscd  dcuxh iosd ssb  hsdc sh sh avxj df sfv ufv sdhcs cs icdjsij icssc sdic sijcisk c j cs dcsifsvbhgahv uoh asa uiui uibfsduivuv sdui");
              },
              icon: Icon(
                Icons.add,
                size: 30,
                color: Colors.grey.shade400,
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
                  final dateTime = DateTime.fromMillisecondsSinceEpoch(
                      task.createdOn,
                      isUtc: false);

                  return GestureDetector(
                    onTap: () {},
                    child: Draggable(
                      data: task.id,
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
                    ),
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
