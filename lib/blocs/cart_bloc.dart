import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/models.dart';

class CartBLOC extends ChangeNotifier {
  Map<String, List<Item>> _items = {};

  Map<String, List<Item>> get items => _items;

  void addItem(Item item) {
    if (_items.containsKey(item.id))
      _items[item.id].add(item);
    else
      _items[item.id] = [item];

    notifyListeners();
  }
}
