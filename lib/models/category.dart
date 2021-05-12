class Category {
  int categoryId;
  String categoryName;
  String categoryDesc;
  int parent;

  ImageCat image;

  Category({
    this.categoryId,
    this.categoryName,
    this.categoryDesc,
    this.image,
  });

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['id'];
    categoryName = json['name'];
    categoryDesc = json['description'];
    parent = json['parent'];
    image = json['image'] != null ? new ImageCat.fromJson(json['image']) : null;
  }
}

class ImageCat {
  String url;

  ImageCat({
    this.url,
  });

  ImageCat.fromJson(Map<String, dynamic> json) {
    url = json['src'];
  }
}
