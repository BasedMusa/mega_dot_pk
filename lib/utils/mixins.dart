import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/models.dart';

mixin AsyncTaskMixin on ChangeNotifier {
  AsyncTaskStatus _taskStatus = AsyncTaskStatus.clear();

  AsyncTaskStatus get taskStatus => _taskStatus;

  set taskStatus(AsyncTaskStatus taskStatus) {
    _taskStatus = taskStatus;
    notifyListeners();
  }
}

mixin PlatformBoolMixin on Widget {
  final bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;
}
