class CategoryModel {
  CategoryModel({
    required this.category,
    required this.status,
    this.id,
  });

  String category;
  bool status;
  String? id;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    category: json["category"],
    status: json["status"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "category": category,
    "status": status,
    "id": id,
  };
}