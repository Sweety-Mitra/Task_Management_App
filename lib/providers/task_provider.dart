import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  List<Task> tasks = [];

  bool isLoading = false;

  String searchText = '';
  String filterStatus = 'All';

  String draftTitle = '';
  String draftDesc = '';
  String draftStatus = 'To-Do';
  DateTime draftDate = DateTime.now();
  int? draftBlockedBy;

  // Constructor → load saved data
  TaskProvider() {
    loadTasks();
  }

  Timer? _debounce;

  // ADD TASK
  Future<void> addTask(Task task) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 2));

    tasks.add(task);

    await saveTasks();

    isLoading = false;
    notifyListeners();
  }

  // UPDATE TASK
  Future<void> updateTask(int index, Task task) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 2));

    tasks[index] = task;

    await saveTasks();

    isLoading = false;
    notifyListeners();
  }

  // DELETE TASK
  void deleteTask(int index) async {
    tasks.removeAt(index);

    await saveTasks();

    notifyListeners();
  }

  // SEARCH
  void setSearch(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(milliseconds: 300), () {
      searchText = value;
      notifyListeners();
    });
  }

  // FILTER
  void setFilter(String value) {
    filterStatus = value;
    notifyListeners();
  }

  // FILTERED LIST
  List<Task> get filteredTasks {
    return tasks.where((task) {
      final matchSearch = task.title.toLowerCase().contains(
        searchText.toLowerCase(),
      );

      final matchFilter = filterStatus == 'All' || task.status == filterStatus;

      return matchSearch && matchFilter;
    }).toList();
  }

  // SAVE TASKS TO LOCAL STORAGE
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> taskList = tasks
        .map((task) => jsonEncode(task.toJson()))
        .toList();

    await prefs.setStringList('tasks', taskList);
  }

  // LOAD TASKS FROM LOCAL STORAGE
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getStringList('tasks');

    if (data != null) {
      tasks = data
          .map((taskString) => Task.fromJson(jsonDecode(taskString)))
          .toList();

      notifyListeners();
    }
  }

  // SAVE DRAFT
  void saveDraft({
    required String title,
    required String desc,
    required String status,
    required DateTime date,
    int? blockedBy,
  }) {
    draftTitle = title;
    draftDesc = desc;
    draftStatus = status;
    draftDate = date;
    draftBlockedBy = blockedBy;
  }

  // CLEAR DRAFT (after saving task)
  void clearDraft() {
    draftTitle = '';
    draftDesc = '';
    draftStatus = 'To-Do';
    draftDate = DateTime.now();
    draftBlockedBy = null;
  }
}