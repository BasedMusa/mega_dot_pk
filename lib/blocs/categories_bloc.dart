import 'package:flutter/cupertino.dart';
import 'package:mega_dot_pk/utils/api_interface.dart';
import 'package:mega_dot_pk/utils/models.dart';

class CategoriesBLOC extends ChangeNotifier {
  List<Category> _categories;
  AsyncTaskStatus _taskStatus;

  List<Category> get categories => _categories;

  AsyncTaskStatus get taskStatus => _taskStatus;

  set categories(List<Category> categories) {
    _categories = categories;
    notifyListeners();
  }

  set taskStatus(AsyncTaskStatus taskStatus) {
    _taskStatus = taskStatus;
    notifyListeners();
  }

  CategoriesBLOC() {
    loadData();
  }

  Future<void> loadData() async {
    try {
      taskStatus = AsyncTaskStatus.loading();

      DataFunctionResponse response = await APIInterface.categories();
      taskStatus = AsyncTaskStatus.fromDataFunctionResponse(response);

      if (taskStatus.error == false) categories = response.data;
    } catch (e) {
      print("CategoriesBLOC: LoadData: UnexpectedError: $e");
      taskStatus = AsyncTaskStatus.error();
    }
  }
}
