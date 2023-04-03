import 'package:flutter/material.dart';
import 'package:todo_app/models/taskModel.dart';

class TodoModel extends ChangeNotifier {
  List<TaskModel> taskList = [];

  addTaskInList() {
    TaskModel taskModel = TaskModel(
        "Title ${taskList.length}", "This is the details of the task");
    taskList.add(taskModel);
    notifyListeners();
  }
}
