import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/services/firestore_service.dart';

import '../../models/order_model.dart';
import '../../ui/general/colors.dart';
import '../../ui/widgets/general_widget.dart';
import '../../ui/widgets/item_order_admin_widget.dart';
import '../../ui/widgets/my_appbar_widget.dart';
import '../../ui/widgets/text_widget.dart';

class OrderAdminPage extends StatelessWidget {
  final FirestoreService _orderReference =
      FirestoreService(collection: "orders");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: MyAppBarWidget(text: "Ordenes"),
      ),
      body: StreamBuilder(
        stream: _orderReference.getStreamOrders(),
        builder: (BuildContext context, AsyncSnapshot snap){
          if(snap.hasData){
            QuerySnapshot collection = snap.data;
            List<OrderModel> orders =  collection.docs.map((e){
              OrderModel model = OrderModel.fromJson(e.data() as Map<String, dynamic>);
              model.id = e.id;
              return model;
            }).toList();
            orders = orders.reversed.toList();
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return ItemOrderAdminWidget(orderModel: orders[index],);
              },
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
