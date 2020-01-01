import 'package:flutter/cupertino.dart';
import 'package:mega_dot_pk/utils/api_interface.dart';
import 'package:mega_dot_pk/utils/models.dart';

class FiltersBLOC extends ChangeNotifier {
  Category _category;
  List<Brand> _brands;

  AsyncTaskStatus _taskStatus;

  List<Brand> get brands => _brands;

  AsyncTaskStatus get taskStatus => _taskStatus;

  set brands(List<Brand> brands) {
    _brands = brands;
    notifyListeners();
  }

  set taskStatus(AsyncTaskStatus taskStatus) {
    _taskStatus = taskStatus;
    notifyListeners();
  }

  FiltersBLOC(Category category){
    this._category = category;
    loadData();
  }

  Future<void> loadData() async {
    try {
      taskStatus = AsyncTaskStatus.loading();

      DataFunctionResponse<List<Brand>> response =
          await APIInterface.brands(_category);
      taskStatus = AsyncTaskStatus.fromDataFunctionResponse(response);

      if (taskStatus.error == false) brands = response.data;
    } catch (e) {
      print("FiltersBLOC: LoadData: UnexpectedError: $e");
      taskStatus = AsyncTaskStatus.error();
    }
  }
}
