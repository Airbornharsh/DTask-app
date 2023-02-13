import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class TaskModel {
  String taskHeading;
  String taskBody;
  int createdOn;
  String id;

  TaskModel(
      {required this.taskHeading,
      required this.taskBody,
      required this.createdOn,
      required this.id});
}

class Task with ChangeNotifier {
  final List<String> _taskString = [];
  List<TaskModel> _task = [];
  final List<List<TaskModel>> _taskDay = [];
  final List<List<TaskModel>> _taskMonth = [];
  final List<String> _selectedTask = [];

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

  int get getSelectedTaskLength {
    return _selectedTask.length;
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
      _taskString.clear();
      _task.clear();
      _taskDay.clear();
      _taskMonth.clear();

      final prefs = await SharedPreferences.getInstance();
      final date = DateTime.now();
      final day = date.day;
      final month = date.month;

      if (prefs.containsKey("dtask_collection")) {
        final list = prefs.getStringList("dtask_collection") as List<String>;

        _taskString.addAll(list);

        for (int i = 1; i <= day; i++) {
          _taskDay.add([]);
        }

        for (int i = 1; i <= month; i++) {
          _taskMonth.add([]);
        }

        late List<TaskModel> taskList;

        int sortIndex = prefs.getInt("dtask_selected_sort_index")!;

        if (sortIndex == 0) {
          taskList = ascendingSort(date);
        } else if (sortIndex == 1) {
          taskList = descendingSort(date);

          taskList = taskList.reversed.toList();
        }

        _task.addAll(taskList);

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

  void addTask(String taskHeading, String taskBody) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final taskId = const Uuid().v1();
      final taskCreatedOn = DateTime.now().millisecondsSinceEpoch;

      if (!prefs.containsKey("dtask_collection")) {
        await prefs.setStringList("dtask_collection", []);
      }

      final tempTask = TaskModel(
          taskHeading: taskHeading,
          taskBody: taskBody,
          createdOn: taskCreatedOn,
          id: taskId);

      _taskString.insert(0,
          "$taskHeading@#_dtask_task_detail_#@$taskBody@#_dtask_task_detail_#@$taskCreatedOn@#_dtask_task_detail_#@$taskId");
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

  Future editTask(TaskModel task, String taskHeading, String taskBody) async {
    final prefs = await SharedPreferences.getInstance();
    final date = DateTime.now();
    final tempDate = DateTime.fromMillisecondsSinceEpoch(task.createdOn);

    final index = _taskString.indexOf(
        "${task.taskHeading}@#_dtask_task_detail_#@${task.taskBody}@#_dtask_task_detail_#@${task.createdOn}@#_dtask_task_detail_#@${task.id}");

    _taskString[index] =
        "$taskHeading@#_dtask_task_detail_#@$taskBody@#_dtask_task_detail_#@${task.createdOn}@#_dtask_task_detail_#@${task.id}";
    final tempTask = TaskModel(
        taskHeading: taskHeading,
        taskBody: taskBody,
        createdOn: task.createdOn,
        id: task.id);
    _task[index] = tempTask;

    if (date.month == tempDate.month && date.year == tempDate.year) {
      final tempList = _taskDay[date.day - tempDate.day];
      final tempIndex = tempList.indexWhere((e) => e.id == task.id);
      _taskDay[date.day - tempDate.day][tempIndex] = tempTask;
    }

    if (date.year == tempDate.year) {
      final tempList = _taskMonth[date.month - tempDate.month];
      final tempIndex = tempList.indexWhere((e) => e.id == task.id);
      _taskMonth[date.month - tempDate.month][tempIndex] = tempTask;
    }

    await prefs.setStringList("dtask_collection", _taskString);

    notifyListeners();
  }

  Future deleteTask(TaskModel task) async {
    final prefs = await SharedPreferences.getInstance();
    final date = DateTime.now();
    final tempDate = DateTime.fromMillisecondsSinceEpoch(task.createdOn);

    _taskString.remove(
        "${task.taskHeading}@#_dtask_task_detail_#@${task.taskBody}@#_dtask_task_detail_#@${task.createdOn}@#_dtask_task_detail_#@${task.id}");
    _task.removeWhere((e) => e.id == task.id);

    if (date.month == tempDate.month && date.year == tempDate.year) {
      _taskDay[date.day - tempDate.day].removeWhere((e) => e.id == task.id);
    }

    if (date.year == tempDate.year) {
      _taskMonth[date.month - tempDate.month]
          .removeWhere((e) => e.id == task.id);
    }

    await prefs.setStringList("dtask_collection", _taskString);

    notifyListeners();
  }

  Future deleteSelectedTask() async {
    final prefs = await SharedPreferences.getInstance();
    final date = DateTime.now();

    List<TaskModel> tasks = [];

    for (var taskId in _selectedTask) {
      final tempTask = _task.firstWhere((task) => task.id == taskId);
      tasks.add(tempTask);
    }

    _selectedTask.clear();

    for (var task in tasks) {
      final tempDate = DateTime.fromMillisecondsSinceEpoch(task.createdOn);

      _taskString.remove(
          "${task.taskHeading}@#_dtask_task_detail_#@${task.taskBody}@#_dtask_task_detail_#@${task.createdOn}@#_dtask_task_detail_#@${task.id}");
      _task.removeWhere((e) => e.id == task.id);

      if (date.month == tempDate.month && date.year == tempDate.year) {
        _taskDay[date.day - tempDate.day].removeWhere((e) => e.id == task.id);
      }

      if (date.year == tempDate.year) {
        _taskMonth[date.month - tempDate.month]
            .removeWhere((e) => e.id == task.id);
      }
    }
    await prefs.setStringList("dtask_collection", _taskString);

    notifyListeners();
  }

  Future sorting(String type) async {
    // final prefs = await SharedPreferences.getInstance();
    final date = DateTime.now();

    late List<TaskModel> taskList;

    for (int i = 1; i <= date.day; i++) {
      _taskDay[i - 1] = [];
    }

    for (int i = 1; i <= date.month; i++) {
      _taskMonth[i - 1] = [];
    }

    if (type == "Ascending") {
      taskList = ascendingSort(date);
    } else if (type == "Descending") {
      taskList = descendingSort(date);

      taskList = taskList.reversed.toList();
    }

    _task = taskList;

    notifyListeners();
  }

  //Helper Functions
  List<TaskModel> ascendingSort(DateTime date) {
    return _taskString.map((e) {
      final taskHeading = e.split("@#_dtask_task_detail_#@")[0];
      final taskBody = e.split("@#_dtask_task_detail_#@")[1];
      final createdOn = int.parse(e.split("@#_dtask_task_detail_#@")[2]);
      final id = e.split("@#_dtask_task_detail_#@")[3];

      final task = TaskModel(
          taskHeading: taskHeading,
          taskBody: taskBody,
          createdOn: createdOn,
          id: id);
      final tempDay = DateTime.fromMillisecondsSinceEpoch(task.createdOn).day;
      final tempMonth =
          DateTime.fromMillisecondsSinceEpoch(task.createdOn).month;
      final tempYear = DateTime.fromMillisecondsSinceEpoch(task.createdOn).year;

      for (int i = date.day; i >= 1; i--) {
        if (tempDay == i && tempMonth == date.month && tempYear == date.year) {
          _taskDay[date.day - i].add(task);
        }
      }

      for (int i = date.month; i >= 1; i--) {
        if (tempMonth == i && tempYear == date.year) {
          _taskMonth[date.month - i].add(task);
        }
      }

      return task;
    }).toList();
  }

  List<TaskModel> descendingSort(DateTime date) {
    return _taskString.map((e) {
      final taskHeading = e.split("@#_dtask_task_detail_#@")[0];
      final taskBody = e.split("@#_dtask_task_detail_#@")[1];
      final createdOn = int.parse(e.split("@#_dtask_task_detail_#@")[2]);
      final id = e.split("@#_dtask_task_detail_#@")[3];

      final task = TaskModel(
          taskHeading: taskHeading,
          taskBody: taskBody,
          createdOn: createdOn,
          id: id);
      final tempDay = DateTime.fromMillisecondsSinceEpoch(task.createdOn).day;
      final tempMonth =
          DateTime.fromMillisecondsSinceEpoch(task.createdOn).month;
      final tempYear = DateTime.fromMillisecondsSinceEpoch(task.createdOn).year;

      for (int i = date.day; i >= 1; i--) {
        if (tempDay == i && tempMonth == date.month && tempYear == date.year) {
          _taskDay[date.day - i].insert(0, task);
        }
      }

      for (int i = date.month; i >= 1; i--) {
        if (tempMonth == i && tempYear == date.year) {
          _taskMonth[date.month - i].insert(0, task);
        }
      }

      return task;
    }).toList();
  }

  bool isSelected(String taskId) {
    return _selectedTask.contains(taskId);
  }

  bool isListSelected(List<TaskModel> tasks) {
    for (var task in tasks) {
      if (!_selectedTask.contains(task.id)) {
        return false;
      }
    }
    return true;
  }

  void addSelectedTask(String taskId) {
    if (!_selectedTask.contains(taskId)) {
      _selectedTask.add(taskId);
    }
    notifyListeners();
  }

  void addSelectedListTask(List<TaskModel> tasks) {
    for (var task in tasks) {
      if (!_selectedTask.contains(task.id)) {
        _selectedTask.add(task.id);
      }
    }
    notifyListeners();
  }

  void removeSelectedTsak(String taskId) {
    if (_selectedTask.contains(taskId)) {
      _selectedTask.remove(taskId);
    }
    notifyListeners();
  }

  void removeSelectedListTask(List<TaskModel> tasks) {
    for (var task in tasks) {
      if (_selectedTask.contains(task.id)) {
        _selectedTask.remove(task.id);
      }
    }
    notifyListeners();
  }
}
