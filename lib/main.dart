import 'package:dtask/Provider/Settings.dart';
import 'package:dtask/Provider/Task.dart';
import 'package:dtask/Screen/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:google_mobile_ads/google_mobile_ads.dart";

Future main() async {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Settings()),
        ChangeNotifierProvider.value(value: Task()),
      ],
      child: MaterialApp(
        title: 'DTask',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color.fromARGB(255, 14, 124, 123),
          ),
        ),
        // home: const HomeScreen(),
        home: HomeScreen(),
        // routes: {},
      ),
    );
  }
}
