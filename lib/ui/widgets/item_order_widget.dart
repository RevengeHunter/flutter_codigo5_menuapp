import 'package:flutter/material.dart';

import '../../models/product_order_model.dart';
import '../general/colors.dart';
import 'general_widget.dart';

class ItemOrderWidget extends StatelessWidget {
  ProductOrderModel productOrderModel;
  Function onDelete;

  ItemOrderWidget({
    required this.productOrderModel,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(4, 4),
              blurRadius: 12.0),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14.0),
            child: Image.network(
              productOrderModel.image,
              height: 90,
              width: 90,
              fit: BoxFit.cover,
            ),
          ),
          dividerWidth10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productOrderModel.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: kBrandPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                divider3,
                Text(
                  "S/${productOrderModel.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 13.0,
                    color: kBrandPrimaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                divider3,
                InkWell(
                  onTap: () {
                    onDelete();
                  },
                  child: Text(
                    "Eliminar",
                    style: TextStyle(
                        color: kBrandPrimaryColor.withOpacity(0.7),
                        fontSize: 12.0,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
          dividerWidth10,
          dividerWidth6,
          Column(
            children: [
              Text(
                "Cant.",
                style: TextStyle(
                  fontSize: 12.0,
                  color: kBrandPrimaryColor.withOpacity(0.7),
                ),
              ),
              divider3,
              Text(
                productOrderModel.quantity.toString(),
                style: TextStyle(
                  fontSize: 14.0,
                  color: kBrandPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          dividerWidth10,
        ],
      ),
    );
  }
}
