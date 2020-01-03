import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/models.dart';

mixin AsyncTaskMixin on ChangeNotifier {
  AsyncTaskStatus _taskStatus;

  AsyncTaskStatus get taskStatus => _taskStatus;

  set taskStatus(AsyncTaskStatus taskStatus) {
    _taskStatus = taskStatus;
    notifyListeners();
  }
}