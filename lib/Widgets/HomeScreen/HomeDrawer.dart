import 'package:dtask/Provider/Settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3 <= 200
                  ? 250
                  : MediaQuery.of(context).size.height / 3,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Provider.of<Settings>(context).getPrimary),
              child: Stack(children: [
                Positioned(
                    right: 5,
                    top: 5,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.grey.shade200,
                        )))
              ]),
            ),
            ListTile(
              onTap: () {
                Provider.of<Settings>(context, listen: false)
                    .setSelectedDrawerIndex(0);
              },
              selected:
                  Provider.of<Settings>(context).getSelectedDrawerIndex == 0,
              selectedTileColor: Colors.grey.shade200,
              leading: const Icon(Icons.home),
              title: const Text("Home"),
            ),
            ListTile(
              onTap: () {
                Provider.of<Settings>(context, listen: false)
                    .setSelectedDrawerIndex(1);
              },
              selected:
                  Provider.of<Settings>(context).getSelectedDrawerIndex == 1,
              selectedTileColor: Colors.grey.shade200,
              leading: const Icon(Icons.calendar_view_day),
              title: const Text("Days"),
            ),
          ],
        ));
  }
}
