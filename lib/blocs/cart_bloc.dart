import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:mega_dot_pk/widgets/native_alert_dialog.dart';

class CartBLOC extends ChangeNotifier {
  bool get hasItems => _items != null && _items.isNotEmpty;

  Map<String, List<Product>> _items = {};

  Map<String, List<Product>> get items => _items;

  void addItem(Product item) {
    if (_items.containsKey(item.id))
      _items[item.id].add(item);
    else
      _items[item.id] = [item];

    notifyListeners();
  }

  void removeItem(String id) {
    _items[id].removeLast();

    if (_items[id].length <= 0) _items.remove(id);

    notifyListeners();
  }

  Future<void> clear(BuildContext context) async {
    bool confirmedByUser = await NativeAlertDialog.show(
      context,
      title: "Are you sure?",
      content: "You will have to add all items to cart again manually.",
      actions: [
        NativeAlertDialogAction(
          text: "Cancel",
          onTap: () {
            Navigator.pop(context, false);
          },
        ),
        NativeAlertDialogAction(
          text: "Clear",
          isDestructive: true,
          onTap: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
    if (confirmedByUser) {
      _items = {};

      notifyListeners();
    }
  }
}
