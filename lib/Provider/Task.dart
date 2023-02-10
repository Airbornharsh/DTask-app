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

  List<TaskModel> get getTaskList {
    return _task;
  }

  int get getTaskListLength {
    return _task.length;
  }

  Future<List<TaskModel>> onLoad() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey("dtask_collection")) {
        final list = prefs.getStringList("dtask_collection") as List<String>;

        _taskString.addAll(list);

        final taskList = _taskString.map((e) {
          final task = TaskModel(
              taskName: e.split("@#_dtask_task_detail_#@")[0],
              createdOn: int.parse(e.split("@#_dtask_task_detail_#@")[1]),
              id: e.split("@#_dtask_task_detail_#@")[2]);

          return task;
        });

        _task.addAll(taskList);

        return _task;
      } else {
        return [];
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

      final taskId = const Uuid().v1();
      final taskCreatedOn = DateTime.now().millisecondsSinceEpoch;

      if (!prefs.containsKey("dtask_collection")) {
        await prefs.setStringList("dtask_collection", []);
      }

      _taskString.insert(0,
          "$taskName@#_dtask_task_detail_#@$taskCreatedOn@#_dtask_task_detail_#@$taskId");
      _task.insert(0,
          TaskModel(taskName: taskName, createdOn: taskCreatedOn, id: taskId));

      await prefs.setStringList("dtask_collection", _taskString);

      // await prefs.clear();
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }
}
