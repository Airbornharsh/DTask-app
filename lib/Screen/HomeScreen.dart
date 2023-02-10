import 'package:dtask/Provider/Settings.dart';
import 'package:dtask/Provider/Task.dart';
import 'package:dtask/Widgets/HomeScreen/AddTask.dart';
import 'package:dtask/Widgets/HomeScreen/Drawer/Home.dart';
import 'package:dtask/Widgets/HomeScreen/HomeDrawer.dart';
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
      Provider.of<Task>(context, listen: false).onLoad();
      setState(() {
        widget.start = false;
      });

      Provider.of<Settings>(context, listen: false).onLoad();
    }

    Widget getWidgetAccordingDrawer() {
      switch (Provider.of<Settings>(context).getSelectedDrawerIndex) {
        case 0:
          return const Home();

        case 1:
          return Container();
          
        default:
          return Container();
      }
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
      drawer: const HomeDrawer(),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Column(
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
                child: getWidgetAccordingDrawer(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
