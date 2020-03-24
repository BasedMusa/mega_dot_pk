import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/api_interface.dart';
import 'package:mega_dot_pk/utils/mixins.dart';
import 'package:mega_dot_pk/utils/models.dart';

class BrandSpecificProductsBLOC extends ProductsBLOC {
  Brand brand;

  BrandSpecificProductsBLOC() : super("BrandSpecificProductsBLOC");

  void loadData({bool lazyLoading = false}) =>
      super._loadData(brand: brand, lazyLoading: lazyLoading);

  void updateBaseData({Brand brand, String uid, Category category}) {
    this.brand = brand ?? this.brand;
    super._updateBaseData(uid, category);
  }
}

class CategorySpecificProductsBLOC extends ProductsBLOC {
  CategorySpecificProductsBLOC() : super("CategorySpecificProductsBLOC");

  void loadData({bool lazyLoading = false}) =>
      super._loadData(lazyLoading: lazyLoading);

  void updateBaseData({String uid, Category category}) =>
      super._updateBaseData(uid, category);

  Future<bool> toggleItemWished(Product product) async {
    int index = products.indexOf(product);

    bool _originalState = product.wished;

    products[index].wished = !products[index].wished;

    notifyListeners();

    DataFunctionResponse<bool> response =
        await APIInterface.toggleWished(uid, product.id, product.wished);

    bool success = response.success && response.data == true;

    print("FINAL RESPONSE FOR WISH: $success: ${product.name}");

    if (success == false) {
      products[index].wished = _originalState;
      notifyListeners();
      return false;
    } else
      return true;
  }
}

/// This class can be extended to make
/// data models which may have varying lists.
///
/// e.g One data model might be need products
/// for a single category, while another one
/// might need products for a specific [Brand] under a specific [Category].
abstract class ProductsBLOC extends ChangeNotifier with AsyncTaskMixin {
  /* Non-notification variables */
  String _className;
  Category category;
  String uid;
  Sorting sorting;

  /* Notification variables */
  bool _hasMore;
  List<Product> _items;

  bool get hasItems => _items != null && _items.isNotEmpty;

  List<Product> get products => _items;

  set products(List<Product> items) {
    _items = items;
    notifyListeners();
  }

  bool get hasMore => _hasMore;

  set hasMore(bool hasMore) {
    _hasMore = hasMore;
    notifyListeners();
  }

  ProductsBLOC(String className) : this._className = className;

  Future<void> _loadData({
    bool lazyLoading = false,
    Brand brand,
  }) async {
    try {
      assert(category != null, "Category has not been assigned.");

      taskStatus = AsyncTaskStatus.loading();

      if (!lazyLoading) products = null;

      DataFunctionResponse<List<Product>> response =
          await APIInterface.products(uid, category, products,
              brand: brand, sorting: sorting);

      hasMore = response.hasMore;
      taskStatus = AsyncTaskStatus.fromDataFunctionResponse(response);

      if (taskStatus.error == false) products = response.data;
    } catch (e) {
      print("$_className: LoadData: UnexpectedError: $e");
      taskStatus = AsyncTaskStatus.error();
    }
  }

  void _updateBaseData(String uid, Category category) {
    this.category = category ?? this.category;
    this.uid = uid ?? this.uid;
  }
}
