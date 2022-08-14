class ProductOrderModel {
  String id;
  String name;
  double price;
  String image;
  int quantity;

  ProductOrderModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
  });

  factory ProductOrderModel.fromJson(Map<String, dynamic> json) =>
      ProductOrderModel(
        id: json["id"] ?? "",
        name: json["name"],
        price: json["price"],
        image: json["image"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "image": image,
        "quantity": quantity,
      };
}
