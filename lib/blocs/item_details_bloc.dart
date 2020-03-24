import 'package:flutter/cupertino.dart';
import 'package:mega_dot_pk/utils/api_interface.dart';
import 'package:mega_dot_pk/utils/mixins.dart';
import 'package:mega_dot_pk/utils/models.dart';

class ProductDetailsBLOC extends ChangeNotifier with AsyncTaskMixin {
  Product _product;
  Map _productDetails;

  Map get productDetails => _productDetails;

  set productDetails(Map itemDetails) {
    _productDetails = itemDetails;
    notifyListeners();
  }

  ProductDetailsBLOC(Product item) {
    this._product = item;
    loadData();
  }

  Future<void> loadData() async {
    try {
      taskStatus = AsyncTaskStatus.loading();

      DataFunctionResponse<Map> response =
          await APIInterface.productDetails(_product);
      taskStatus = AsyncTaskStatus.fromDataFunctionResponse(response);

      if (taskStatus.error == false) productDetails = response.data;
    } catch (e) {
      print("ProductDetailsBLOC: LoadData: UnexpectedError: $e");
      taskStatus = AsyncTaskStatus.error();
    }
  }
}
