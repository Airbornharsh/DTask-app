import 'package:dtask/Provider/Settings.dart';
import 'package:dtask/Provider/Task.dart';
import 'package:dtask/Widgets/HomeScreen/AddTask.dart';
import 'package:dtask/Widgets/HomeScreen/Drawer/Days.dart';
import 'package:dtask/Widgets/HomeScreen/Drawer/Home.dart';
import 'package:dtask/Widgets/HomeScreen/Drawer/Months.dart';
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
  TextEditingController _searchController = TextEditingController();
  bool isSearching = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.start) {
      Provider.of<Task>(context, listen: false).onLoad();

      Provider.of<Settings>(context, listen: false).onLoad();

      setState(() {
        widget.start = false;
      });
    }

    final filter = [
      'Filter',
      'Days',
      'Month',
    ];

    final sort = ["Ascending", "Descending"];

    Widget getWidgetAccordingDrawer() {
      switch (Provider.of<Settings>(context).getSelectedFilterIndex) {
        case 0:
          return Home(
            isSearching: isSearching,
          );

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
        decoration:
            BoxDecoration(color: Provider.of<Settings>(context).getColor2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            // SizedBox(
            //   width: MediaQuery.of(context).size.width,
            //   child: Image.asset(
            //     "lib/assets/DTask_Upscaled_Logo_New2.png",
            //     height: 50,
            //   ),
            // ),
            Center(
              child: Container(
                  width: MediaQuery.of(context).size.width * 80 / 100,
                  // margin: EdgeInsets.symmetric(horizontal: 40),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                  decoration: BoxDecoration(
                      color: Provider.of<Settings>(context).getColor5,
                      borderRadius: BorderRadius.circular(60)),
                  child: TextField(
                    onTap: () {
                      setState(() {
                        isSearching = true;
                      });
                      Provider.of<Settings>(context, listen: false)
                          .setSelectedFilterIndex(0);
                    },
                    controller: _searchController,
                    style: TextStyle(color: Colors.grey.shade900),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search",
                        icon: Icon(Icons.search, color: Colors.grey),
                        iconColor: Colors.grey,
                        suffixIcon: isSearching
                            ? IconButton(
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  setState(() {
                                    isSearching = false;
                                  });
                                },
                                icon: Icon(Icons.clear),
                              )
                            : IconButton(
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  setState(() {
                                    isSearching = false;
                                  });
                                  _searchController.clear();
                                },
                                icon: Icon(Icons.clear),
                              ),
                        suffixIconColor: Colors.grey),
                    onChanged: (value) async {
                      await Provider.of<Task>(context, listen: false)
                          .searchingTasks(_searchController.text);
                    },
                    onSubmitted: (value) async {
                      await Provider.of<Task>(context, listen: false)
                          .searchingTasks(_searchController.text);
                      FocusScope.of(context).requestFocus(new FocusNode());
                      setState(() {
                        isSearching = false;
                      });
                    },
                  )),
            ),
            const SizedBox(
              height: 16,
            ),
            Stack(
              children: [
                Positioned(
                  right: 5,
                  top: 11,
                  child: Text(
                      Provider.of<Task>(context)
                          .getSelectedTaskLength
                          .toString(),
                      style: const TextStyle(fontSize: 20)),
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 0),
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 252, 252, 252),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButton(
                            icon: const Icon(Icons.filter_alt_rounded),
                            value: Provider.of<Settings>(context)
                                .getSelectedFilterIndex,
                            items: [
                              DropdownMenuItem(
                                  value: 0, child: Text(filter[0])),
                              DropdownMenuItem(
                                  value: 1, child: Text(filter[1])),
                              DropdownMenuItem(value: 2, child: Text(filter[2]))
                            ],
                            onChanged: (value) {
                              setState(() {
                                isSearching = false;
                              });
                              Provider.of<Settings>(context, listen: false)
                                  .setSelectedFilterIndex(value as int);
                            },
                          ),
                        ),
                        Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 0),
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 252, 252, 252),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButton(
                            icon: const Icon(Icons.sort),
                            value: Provider.of<Settings>(context)
                                .getSelectedSortIndex,
                            items: [
                              DropdownMenuItem(value: 0, child: Text(sort[0])),
                              DropdownMenuItem(value: 1, child: Text(sort[1])),
                            ],
                            onChanged: (value) {
                              Provider.of<Settings>(context, listen: false)
                                  .setSelectedSortIndex(value as int);

                              Provider.of<Task>(context, listen: false)
                                  .sorting(sort[value]);
                            },
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () async {
                          if (Provider.of<Task>(context, listen: false)
                                  .getSelectedTaskLength ==
                              0) {
                            const snackBar = SnackBar(
                              content: Text("Not Selected"),
                              duration: Duration(milliseconds: 500),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            await Provider.of<Task>(context, listen: false)
                                .deleteSelectedTask();
                            const snackBar =
                                SnackBar(content: Text("Deleted Tasks"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        icon: const Icon(Icons.delete))
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  Provider.of<Task>(context, listen: false).onLoad();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: getWidgetAccordingDrawer(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
