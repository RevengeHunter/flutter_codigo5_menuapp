import 'package:flutter_codigo5_menuapp/models/product_order_model.dart';

class OrderService {
  static final OrderService _instance = OrderService._();

  OrderService._();

  factory OrderService() {
    return _instance;
  }

  List<ProductOrderModel> _orders = [];

  int get ordersLength => _orders.length;

  List<ProductOrderModel> get getOrders => _orders;

  //get orders => _orders;

  ProductOrderModel getProductOrder(int index) => _orders[index];

  double get total {
    double total=0.0;
    _orders.forEach((element) {
      total+=(element.price * element.quantity);
    });
    return total;
  }

  addProduct(ProductOrderModel productOrderModel) {
    _orders.add(productOrderModel);
  }

  deleteProduct(int index) {
    _orders.removeAt(index);
  }

  clearOrder() {
    _orders.clear();
  }

  List<Map<String, dynamic>> getOrdersMap() => _orders.map((e) => e.toJson()).toList();

}
