class Item {
  String id;
  String name;
  String price;
  String stock;
  String views;
  String warranty;
  String categoryID;
  String brandID;
  String brandName;
  String thumbnailImageURL;
  String xsThumbnailImageURL;

  Item.fromJSON(Map json)
      : this.id = json["id"],
        this.price = json["price"],
        this.categoryID = json["category_id"],
        this.brandID = json["brand_id"],
        this.stock =
            (json["stock"] as String).isNotEmpty ? json["stock"] : "Available",
        this.warranty = (json["warranty"] as String).isNotEmpty
            ? json["warranty"]
            : "No Warranty",
        this.views = json["views"],
        this.brandName = json["name"].split(" ")[0],
        this.name = (json["name"] as String)
            .replaceAll(json["name"].split(" ")[0] + " ", ""),
        this.xsThumbnailImageURL = json["tss_img_url"],
        this.thumbnailImageURL = json["t_img_url"];
}

class Category {
  String id;
  String pid;
  String name;
  String description;

  Category.fromJSON(Map json)
      : this.id = json["id"],
        this.pid = json["pid"],
        this.name = json["name"],
        this.description = "Gadgets for your home.";
}

class Brand {
  String id;
  String name;
  String totalItems;

  Brand.fromJSON(Map json)
      : this.id = json["id"],
        this.name = json["name"],
        this.totalItems = json["total_active_items"];
}

class Sorting {
  final int value;
  final String name;

  const Sorting(this.value, this.name);
}

class AsyncTaskStatus {
  bool loading;
  bool error;
  String errorMessage;

  AsyncTaskStatus.clear()
      : this.loading = false,
        this.error = false,
        this.errorMessage = null;

  AsyncTaskStatus.loading()
      : this.loading = true,
        this.error = false,
        this.errorMessage = null;

  AsyncTaskStatus.error([this.errorMessage = "Something Went Wrong"])
      : this.loading = false,
        this.error = true;

  AsyncTaskStatus.fromDataFunctionResponse(DataFunctionResponse response)
      : this.loading = false,
        this.error = response.success == false,
        this.errorMessage =
            (response.success == false) == true ? response.errorMessage : null;
}

class DataFunctionResponse<T> {
  T data;
  bool success;
  bool hasMore;
  String errorMessage;

  DataFunctionResponse.success(this.data, {this.hasMore = false})
      : this.success = true;

  DataFunctionResponse.error({this.errorMessage = "Something Broke"})
      : this.success = false;
}
