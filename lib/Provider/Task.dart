import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class TaskModel {
  String taskName;
  int createdOn;
  String id;

  TaskModel(
      {required this.taskName, required this.createdOn, required this.id});
}

class TaskModelTime {
  // String taskName;
  // String id;
  // int seconds;
  // int minute;
  // int
}

class Task with ChangeNotifier {
  final List<String> _taskString = [];
  final List<TaskModel> _task = [];
  List<List<TaskModel>> _taskDay = [];
  List<List<TaskModel>> _taskMonth = [];

  List<TaskModel> get getTaskList {
    return _task;
  }

  List<List<TaskModel>> get getTaskDayList {
    return _taskDay;
  }

  List<List<TaskModel>> get getTaskMonthList {
    return _taskMonth;
  }

  int get getTaskListLength {
    return _task.length;
  }

  int get getTaskDayListLength {
    return _taskDay.length;
  }

  int get getTaskMonthListLength {
    return _taskMonth.length;
  }

  String getDays(int val) {
    if (val == 1 || val == 21 || val == 31) {
      return "${val}st";
    } else if (val == 2 || val == 22) {
      return "${val}nd";
    } else if (val == 3 || val == 23) {
      return "${val}rd";
    } else {
      return "${val}th";
    }
  }

  Future onLoad() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final date = DateTime.now();
      final day = date.day;
      final month = date.month;
      final year = date.year;

      if (prefs.containsKey("dtask_collection")) {
        final list = prefs.getStringList("dtask_collection") as List<String>;

        _taskString.addAll(list);

        for (int i = 1; i <= day; i++) {
          _taskDay.add([]);
        }

        for (int i = 1; i <= month; i++) {
          _taskMonth.add([]);
        }

        final taskList = _taskString.map((e) {
          final taskName = e.split("@#_dtask_task_detail_#@")[0];
          final createdOn = int.parse(e.split("@#_dtask_task_detail_#@")[1]);
          final id = e.split("@#_dtask_task_detail_#@")[2];

          final task =
              TaskModel(taskName: taskName, createdOn: createdOn, id: id);
          final tempDay =
              DateTime.fromMillisecondsSinceEpoch(task.createdOn).day;
          final tempMonth =
              DateTime.fromMillisecondsSinceEpoch(task.createdOn).month;
          final tempYear =
              DateTime.fromMillisecondsSinceEpoch(task.createdOn).year;

          for (int i = day; i >= 1; i--) {
            if (tempDay == i && tempMonth == month && tempYear == year) {
              _taskDay[day - i].add(task);
            }
          }

          for (int i = month; i >= 1; i--) {
            if (tempMonth == i && tempYear == year) {
              _taskMonth[month - i].add(task);
            }
          }

          return task;
        });

        _task.addAll(taskList);
        // _taskDay = _taskDay.reversed.toList();
        // _taskMonth = _taskMonth.reversed.toList();

        return;
      } else {
        return;
      }
    } catch (e) {
      print(e);
      return [];
    } finally {
      notifyListeners();
    }
  }

  void addTask(String taskName) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final date = DateTime.now();

      final taskId = const Uuid().v1();
      final taskCreatedOn = DateTime.now().millisecondsSinceEpoch;

      if (!prefs.containsKey("dtask_collection")) {
        await prefs.setStringList("dtask_collection", []);
      }

      final tempTask =
          TaskModel(taskName: taskName, createdOn: taskCreatedOn, id: taskId);

      _taskString.insert(0,
          "$taskName@#_dtask_task_detail_#@$taskCreatedOn@#_dtask_task_detail_#@$taskId");
      _task.insert(0, tempTask);
      _taskDay[0].insert(0, tempTask);
      _taskMonth[0].insert(0, tempTask);

      await prefs.setStringList("dtask_collection", _taskString);

      // await prefs.clear();
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }
}
