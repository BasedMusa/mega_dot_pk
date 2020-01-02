import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as HTTP;
import 'package:mega_dot_pk/utils/models.dart';

class APIInterface {
  static const baseURL = "http://192.168.1.121/mobile";

  static Future<DataFunctionResponse<List<Category>>> categories() async {
    try {
      Map json = await _sendRequest("$baseURL/categories/read.php");
      if (json != null) {
        List<dynamic> categoriesJSONList = json["records"];
        List<Category> categories = [];

        for (Map json in categoriesJSONList) {
          categories.add(Category.fromJSON(json));
        }

        return DataFunctionResponse.success(categories);
      } else
        return DataFunctionResponse.error();
    } catch (e) {
      print("APIInterface: Categories: UnexpectedError: $e");
      return DataFunctionResponse.error();
    }
  }

  static Future<DataFunctionResponse<List<Item>>> items(
    Category category,
    Brand brand,
    Sorting sorting,
    int offset,
    List<Item> alreadyLoadedItems,
  ) async {
    try {
      String url = "$baseURL/items/read.php?cid=${category.id}&offset=$offset";

      if (brand != null) url += "&bid=${brand.id}";

      if (sorting != null) url += "&s_val=${sorting.value}";

      Map json = await _sendRequest(url);

      if (json != null) {
        List<dynamic> itemsJSONList = json["records"];
        List<Item> items = alreadyLoadedItems ?? [];

        for (Map json in itemsJSONList) {
          items.add(Item.fromJSON(json));
        }

        return DataFunctionResponse.success(items, hasMore: json["has_more"]);
      } else
        return DataFunctionResponse.error();
    } catch (e) {
      print("APIInterface: Items: UnexpectedError: $e");
      return DataFunctionResponse.error();
    }
  }

  static Future<DataFunctionResponse<Map>> itemDetails(Item item) async {
    try {
      String url =
          "$baseURL/items/details.php?item_id=${item.id}&cid=${item.categoryID}";

      Map json = await _sendRequest(url);

      if (json != null) {
        Map itemDetails = json["details"];

        return DataFunctionResponse.success(itemDetails);
      } else
        return DataFunctionResponse.error();
    } catch (e) {
      print("APIInterface: Items: UnexpectedError: $e");
      return DataFunctionResponse.error();
    }
  }

  static Future<DataFunctionResponse<List<Brand>>> brands(
      Category category) async {
    try {
      Map json =
          await _sendRequest("$baseURL/filters/read.php?cid=${category.id}");

      if (json != null) {
        List<dynamic> itemsJSONList = json["records"];
        List<Brand> brands = [];

        for (Map json in itemsJSONList) {
          brands.add(Brand.fromJSON(json));
        }

        return DataFunctionResponse.success(brands);
      } else
        return DataFunctionResponse.error();
    } catch (e) {
      print("APIInterface: Brands: UnexpectedError: $e");
      return DataFunctionResponse.error();
    }
  }

  static Future<Map> _sendRequest(String url) async {
    try {
      HTTP.Response response = await HTTP.get(url);
      Map json = jsonDecode(response.body);

      return json;
    } on SocketException catch (e) {
      print("APIInterface: SendRequest: SocketException: $e");
      return null;
    } on PlatformException catch (e) {
      if (e.code == "ERROR_NETWORK_REQUEST_FAILED") {
        print("APIInterface: SendRequest: NetworkError: $e");
        return null;
      } else {
        print("APIInterface: SendRequest: PlatformException: $e");
        return null;
      }
    } catch (e) {
      print("APIInterface: SendRequest: UnexpectedError: $url: $e");
      return null;
    }
  }
}
