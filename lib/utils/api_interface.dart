import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as HTTP;
import 'package:mega_dot_pk/utils/models.dart';

class APIInterface {
  static const baseURL = "http://192.168.1.121/mobile";

  static Future<DataFunctionResponse<List<Category>>> categories() async {
    try {
      DataFunctionResponse<Map> response =
          await _sendRequest("$baseURL/categories/read.php");

      if (response.success) {
        Map json = response.data;
        List<dynamic> categoriesJSONList = json["records"];
        List<Category> categories = [];

        for (Map json in categoriesJSONList) {
          categories.add(Category.fromJSON(json));
        }

        return DataFunctionResponse.success(categories);
      } else
        return DataFunctionResponse.error(errorMessage: response.errorMessage);
    } catch (e) {
      print("APIInterface: Categories: UnexpectedError: $e");
      return DataFunctionResponse.error();
    }
  }

  static Future<DataFunctionResponse<List<Product>>> products(
    String userID,
    Category category,
    List<Product> loadedProducts, {
    Brand brand,
    Sorting sorting,
  }) async {
    int offset = loadedProducts?.length ?? 0;

    try {
      String url = "$baseURL/items/read.php?cid=${category.id}&offset=$offset";

      if (userID != null) url += "&uid=$userID";

      if (brand != null) url += "&bid=${brand.id}";

      if (sorting != null) url += "&s_val=${sorting.value}";

      DataFunctionResponse<Map> response = await _sendRequest(url);

      if (response.success) {
        Map json = response.data;
        List<dynamic> itemsJSONList = json["records"];
        List<Product> items = loadedProducts ?? [];

        for (Map json in itemsJSONList) {
          items.add(Product.fromJSON(json));
        }

        return DataFunctionResponse.success(items, hasMore: json["has_more"]);
      } else
        return DataFunctionResponse.error(errorMessage: response.errorMessage);
    } catch (e) {
      print("APIInterface: Items: UnexpectedError: $e");
      return DataFunctionResponse.error();
    }
  }

  static Future<DataFunctionResponse<Map>> productDetails(
      Product product) async {
    try {
      String url =
          "$baseURL/items/details.php?item_id=${product.id}&cid=${product.categoryID}";

      DataFunctionResponse<Map> response = await _sendRequest(url);

      if (response.success) {
        Map json = response.data;
        Map itemDetails = json["details"];

        return DataFunctionResponse.success(itemDetails);
      } else
        return DataFunctionResponse.error(errorMessage: response.errorMessage);
    } catch (e) {
      print("APIInterface: Items: UnexpectedError: $e");
      return DataFunctionResponse.error();
    }
  }

  static Future<DataFunctionResponse<List<Brand>>> brands(
      Category category) async {
    try {
      DataFunctionResponse<Map> response =
          await _sendRequest("$baseURL/filters/read.php?cid=${category.id}");

      if (response.success) {
        Map json = response.data;
        List<dynamic> itemsJSONList = json["records"];
        List<Brand> brands = [];

        for (Map json in itemsJSONList) {
          brands.add(Brand.fromJSON(json));
        }

        return DataFunctionResponse.success(brands);
      } else
        return DataFunctionResponse.error(errorMessage: response.errorMessage);
    } catch (e) {
      print("APIInterface: Brands: UnexpectedError: $e");
      return DataFunctionResponse.error();
    }
  }

  static Future<DataFunctionResponse<bool>> toggleWished(
      String userID, String itemID, bool wished) async {
    try {
      int wishState = wished ? 1 : 0;
      DataFunctionResponse<Map> response = await _sendRequest(
          "$baseURL/wishlist/toggle.php?uid=$userID&item_id=$itemID&state=$wishState");

      if (response.success) {
        Map json = response.data;
        bool success = json["success"];

        return DataFunctionResponse.success(success);
      } else
        return DataFunctionResponse.error(errorMessage: response.errorMessage);
    } catch (e) {
      print("APIInterface: ToggleWished: UnexpectedError: $e");
      return DataFunctionResponse.error();
    }
  }

  static Future<DataFunctionResponse<Map>> _sendRequest(String url) async {
    try {
      HTTP.Response response = await HTTP.get(url);
      Map json = jsonDecode(response.body);

      return DataFunctionResponse.success(json);
    } on SocketException catch (e) {
      print("APIInterface: SendRequest: $e");
      if (e.osError.errorCode == 61)
        return DataFunctionResponse.error(
            errorMessage: "Server Connection Refused");
      return DataFunctionResponse.error();
    } on PlatformException catch (e) {
      if (e.code == "ERROR_NETWORK_REQUEST_FAILED") {
        print("APIInterface: SendRequest: NetworkError: $e");
        return DataFunctionResponse.error(errorMessage: "Network Error");
      } else {
        print("APIInterface: SendRequest: PlatformException: $e");
        return DataFunctionResponse.error();
      }
    } catch (e, s) {
      print("APIInterface: SendRequest: UnexpectedError: $url: $e: $s");
      return DataFunctionResponse.error();
    }
  }
}
