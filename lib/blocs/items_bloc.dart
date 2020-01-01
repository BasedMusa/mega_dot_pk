import 'package:flutter/cupertino.dart';
import 'package:mega_dot_pk/utils/api_interface.dart';
import 'package:mega_dot_pk/utils/models.dart';

class ItemsBLOC extends ChangeNotifier {
  Category _category;
  Brand _brand;
  bool _hasMore;
  Sorting _sorting;
  List<Item> _items;
  AsyncTaskStatus _taskStatus;

  List<Item> get items => _items;

  Brand get brand => _brand;

  Sorting get sorting => _sorting;

  AsyncTaskStatus get taskStatus => _taskStatus;

  bool get hasMore => _hasMore;

  set items(List<Item> items) {
    _items = items;
    notifyListeners();
  }

  set taskStatus(AsyncTaskStatus taskStatus) {
    _taskStatus = taskStatus;
    notifyListeners();
  }

  set brand(Brand brand) {
    _brand = brand;
    notifyListeners();
  }

  set sorting(Sorting sorting) {
    _sorting = sorting;
    notifyListeners();
  }

  set hasMore(bool hasMore) {
    _hasMore = hasMore;
    notifyListeners();
  }

  ItemsBLOC(Category category) {
    this._category = category;
    loadData();
  }

  Future<void> loadData(
      {Brand brandFilter,
      Sorting sortingFilter,
      bool lazyLoading = false}) async {
    try {
      taskStatus = AsyncTaskStatus.loading();

      brand = brandFilter;

      sorting = sortingFilter;

      if (!lazyLoading) items = null;

      DataFunctionResponse<List<Item>> response = await APIInterface.items(
          _category, brandFilter, sortingFilter, _items?.length ?? 0, _items);

      hasMore = response.hasMore;
      taskStatus = AsyncTaskStatus.fromDataFunctionResponse(response);

      if (taskStatus.error == false) items = response.data;
    } catch (e) {
      print("ItemsBLOC: LoadData: UnexpectedError: $e");
      taskStatus = AsyncTaskStatus.error();
    }
  }
}
