import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings with ChangeNotifier {
  final Color _color1 = const Color.fromARGB(255, 14, 124, 123);
  final Color _color2 = const Color.fromARGB(255, 143, 221, 220);
  final Color _color3 = const Color.fromARGB(255, 255, 255, 255);
  final Color _color4 = const Color.fromARGB(255, 143, 221, 220);
  final Color _color5 = Color.fromARGB(255, 200, 238, 237);

  int _selectedFilterIndex = 0;
  int _selectedSortIndex = 0;

  Color get getPrimary {
    return _color1;
  }

  Color get getColor2 {
    return _color2;
  }

  Color get getColor3 {
    return _color3;
  }

  Color get getColor4 {
    return _color4;
  }

  Color get getColor5 {
    return _color5;
  }

  int get getSelectedFilterIndex {
    return _selectedFilterIndex;
  }

  int get getSelectedSortIndex {
    return _selectedSortIndex;
  }

  void onLoad() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey("dtask_selected_filter_index")) {
        _selectedFilterIndex = prefs.getInt("dtask_selected_filter_index")!;
      } else {
        await prefs.setInt("dtask_selected_filter_index", _selectedFilterIndex);
      }
      if (prefs.containsKey("dtask_selected_sort_index")) {
        _selectedSortIndex = prefs.getInt("dtask_selected_sort_index")!;
      } else {
        await prefs.setInt("dtask_selected_sort_index", _selectedSortIndex);
      }
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  void setSelectedFilterIndex(int n) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("dtask_selected_filter_index", n);
      _selectedFilterIndex = n;
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  void setSelectedSortIndex(int n) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("dtask_selected_sort_index", n);
      _selectedSortIndex = n;
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }
}
