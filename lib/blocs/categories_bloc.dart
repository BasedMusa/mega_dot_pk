import 'package:flutter/cupertino.dart';
import 'package:mega_dot_pk/utils/api_interface.dart';
import 'package:mega_dot_pk/utils/mixins.dart';
import 'package:mega_dot_pk/utils/models.dart';

class CategoriesBLOC extends ChangeNotifier with AsyncTaskMixin {
  List<Category> _categories;

  List<Category> get categories => _categories;

  set categories(List<Category> categories) {
    _categories = categories;
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
