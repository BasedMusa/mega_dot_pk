class Product {
  String id;
  String name;
  String priceText;
  String price;
  String stock;
  String views;
  String warranty;
  String categoryID;
  String brandID;
  String brandName;
  String thumbnailImageURL;
  String xsThumbnailImageURL;
  bool wished;

  Product.fromJSON(Map json)
      : this.id = json["id"],
        this.price = json["price"] != null ? json["price"] : null,
        this.priceText = json["price"] != null ? "${json["price"]} PKR" : null,
        this.categoryID = json["category_id"],
        this.brandID = json["brand_id"],
        this.stock =
            (json["stock"] as String).isNotEmpty ? json["stock"] : "Available",
        this.warranty = (json["warranty"] as String).isNotEmpty
            ? json["warranty"]
            : "No Warranty",
        this.views = "${json["views"]} Views",
        this.brandName = json["name"].split(" ")[0],
        this.name = (json["name"] as String)
            .replaceAll(json["name"].split(" ")[0] + " ", ""),
        this.xsThumbnailImageURL = json["tss_img_url"],
        this.thumbnailImageURL = json["t_img_url"],
        this.wished = json["wished"] == "1";
}

class Category {
  String id;
  String name;
  String description;
  List<Brand> brands;

  Category.fromJSON(Map json)
      : this.id = json["id"],
        this.name = json["name"],
        this.description = "Gadgets for your home.",
        this.brands = json["brands"]
            .map((json) => Brand.fromJSON(json))
            .toList()
            .cast<Brand>();
}

class Brand {
  String id;
  String name;
  String imageURL;
  String activeItems;

  Brand.fromJSON(Map json)
      : this.id = json["id"],
        this.name = json["brand_name"],
        this.imageURL = json["image_url"],
        this.activeItems = json["active_items"];
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
