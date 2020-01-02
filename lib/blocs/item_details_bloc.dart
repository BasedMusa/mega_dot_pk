import 'package:flutter/cupertino.dart';
import 'package:mega_dot_pk/utils/api_interface.dart';
import 'package:mega_dot_pk/utils/models.dart';

class ItemDetailsBLOC extends ChangeNotifier {
  Item _item;
  Map _itemDetails;
  AsyncTaskStatus _taskStatus;

  Map get itemDetails => _itemDetails;

  AsyncTaskStatus get taskStatus => _taskStatus;

  set itemDetails(Map itemDetails) {
    _itemDetails = itemDetails;
    notifyListeners();
  }

  set taskStatus(AsyncTaskStatus taskStatus) {
    _taskStatus = taskStatus;
    notifyListeners();
  }

  ItemDetailsBLOC(Item item) {
    this._item = item;
    loadData();
  }

  Future<void> loadData() async {
    try {
      taskStatus = AsyncTaskStatus.loading();

      DataFunctionResponse<Map> response =
          await APIInterface.itemDetails(_item);
      taskStatus = AsyncTaskStatus.fromDataFunctionResponse(response);

      if (taskStatus.error == false) itemDetails = response.data;
    } catch (e) {
      print("ItemDetailsBLOC: LoadData: UnexpectedError: $e");
      taskStatus = AsyncTaskStatus.error();
    }
  }
}
