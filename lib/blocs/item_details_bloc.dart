import 'package:flutter/cupertino.dart';
import 'package:mega_dot_pk/utils/api_interface.dart';
import 'package:mega_dot_pk/utils/mixins.dart';
import 'package:mega_dot_pk/utils/models.dart';

class ItemDetailsBLOC extends ChangeNotifier with AsyncTaskMixin {
  Item _item;
  Map _itemDetails;

  Map get itemDetails => _itemDetails;

  set itemDetails(Map itemDetails) {
    _itemDetails = itemDetails;
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
