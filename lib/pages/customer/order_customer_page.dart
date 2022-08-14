import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_codigo5_menuapp/helpers/sp_global.dart';
import 'package:flutter_codigo5_menuapp/models/order_model.dart';
import 'package:flutter_codigo5_menuapp/services/order_stream_service.dart';
import 'package:flutter_codigo5_menuapp/ui/general/colors.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/general_widget.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/item_order_widget.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/text_widget.dart';

import '../../services/firestore_service.dart';
import '../../services/order_service.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final FirestoreService _ordersCollection =
      FirestoreService(collection: "orders");

  DateFormat format = DateFormat('yyyy-MM-dd hh:mm:ss');
  final SPGlobal _prefs = SPGlobal();

  _registerOrder() {
    OrderModel orderModel = OrderModel(
      customer: _prefs.fullName,
      email: _prefs.email,
      products: OrderService().getOrders,
      datetime: format.format(DateTime.now()),
      status: "Recibido",
    );
    // print(OrderService().getOrdersMap());
    _ordersCollection.addOrder(orderModel).then((value) {
      if (value.isNotEmpty) {
        showSnackBar(
          context,
          "Tu orden fue enviada con éxito.",
          Colors.green,
          Icons.check_circle,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextNormal(text: "Las espadas de Ramón"),
                    H1(text: "Mis ordenes"),
                    OrderService().ordersLength > 0
                        ? ListView.builder(
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: OrderService().ordersLength,
                            itemBuilder: (BuildContext context, int index) {
                              return ItemOrderWidget(
                                productOrderModel:
                                    OrderService().getProductOrder(index),
                                onDelete: () {
                                  OrderService().deleteProduct(index);
                                  OrderStreamService().removeCounter();
                                  setState(() {});
                                },
                              );
                            },
                          )
                        : Container(
                            height: height * 0.8,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/box.png',
                                  height: 100,
                                  color: kBrandPrimaryColor.withOpacity(0.8),
                                ),
                                divider6,
                                TextNormal(
                                  text:
                                      "Aún no has agregado productos a la lista",
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(
                      height: 100.0,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20.0,
                      offset: const Offset(0, -10.0),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            color: kBrandPrimaryColor.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        divider3,
                        Text(
                          "S/${OrderService().total.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: kBrandPrimaryColor.withOpacity(0.96),
                            fontWeight: FontWeight.w600,
                            fontSize: 22.0,
                          ),
                        ),
                      ],
                    ),
                    dividerWidth20,
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          onPressed: OrderService().ordersLength > 0
                              ? () {
                                  _registerOrder();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            primary: kBrandPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                14.0,
                              ),
                            ),
                          ),
                          child: Text(
                            "Ordernar ahora",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
