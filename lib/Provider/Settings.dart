import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings with ChangeNotifier {
  final Color _color1 = const Color.fromARGB(255, 14, 124, 123);

  int _selectedDrawerIndex = 0;

  Color get getPrimary {
    return _color1;
  }

  int get getSelectedDrawerIndex {
    return _selectedDrawerIndex;
  }

  void onLoad() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey("dtask_selected_drawer_index")) {
        _selectedDrawerIndex = prefs.getInt("dtask_selected_drawer_index")!;
      } else {
        await prefs.setInt("dtask_selected_drawer_index", _selectedDrawerIndex);
      }
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  void setSelectedDrawerIndex(int n) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("dtask_selected_drawer_index", n);
      _selectedDrawerIndex = n;
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

}
