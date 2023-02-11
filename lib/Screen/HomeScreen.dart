import 'package:dtask/Provider/Settings.dart';
import 'package:dtask/Provider/Task.dart';
import 'package:dtask/Widgets/HomeScreen/AddTask.dart';
import 'package:dtask/Widgets/HomeScreen/Drawer/Days.dart';
import 'package:dtask/Widgets/HomeScreen/Drawer/Home.dart';
import 'package:dtask/Widgets/HomeScreen/Drawer/Months.dart';
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
  // int dropdownindex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.start) {
      Provider.of<Task>(context, listen: false).onLoad();

      Provider.of<Settings>(context, listen: false).onLoad();

      setState(() {
        widget.start = false;
      });
    }

    final items = [
      'Filter',
      'Days',
      'Month',
    ];

    Widget getWidgetAccordingDrawer() {
      switch (Provider.of<Settings>(context).getSelectedDrawerIndex) {
        case 0:
          return const Home();

        case 1:
          return const Days();

        case 2:
          return const Months();

        default:
          return const Text("ok");
      }
    }

    // var appBarTitle = ["DTask", "Sorted By Days", "Sorted By Months"];

    return Scaffold(
      // appBar: AppBar(
      //     title: Text(
      //   appBarTitle[Provider.of<Settings>(context).getSelectedDrawerIndex],
      // )),
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
      // drawer: const HomeDrawer(),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "lib/assets/DTask_Logo.png",
                height: 50,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 252, 252, 252),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton(
                icon: const Icon(Icons.filter_alt_rounded),
                value: Provider.of<Settings>(context).getSelectedDrawerIndex,
                items: [
                  DropdownMenuItem(value: 0, child: Text(items[0])),
                  DropdownMenuItem(value: 1, child: Text(items[1])),
                  DropdownMenuItem(value: 2, child: Text(items[2]))
                ],
                onChanged: (value) {
                  Provider.of<Settings>(context, listen: false)
                      .setSelectedDrawerIndex(value as int);
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
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
