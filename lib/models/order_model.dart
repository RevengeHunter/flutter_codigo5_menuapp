import 'package:flutter_codigo5_menuapp/models/product_order_model.dart';

class OrderModel {
  String? id;
  String customer;
  String email;
  List<ProductOrderModel> products;
  String datetime;
  String status;

  OrderModel({
    this.id,
    required this.customer,
    required this.email,
    required this.products,
    required this.datetime,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"] ?? "",
        customer: json["customer"],
        email: json["email"],
        products: json["products"] != null
            ? json["products"]
                .map<ProductOrderModel>((e) => ProductOrderModel.fromJson(e))
                .toList()
            : [],
        datetime: json["datetime"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer": customer,
        "email": email,
        "products": products.map((e) => e.toJson()).toList(),
        "datetime": datetime,
        "status": status,
      };
}
