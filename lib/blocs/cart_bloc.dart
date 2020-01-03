import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/models.dart';

class CartBLOC extends ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items => _items;

  void addItem(Item item) {
    _items.insert(0, item);
    notifyListeners();
  }
}
