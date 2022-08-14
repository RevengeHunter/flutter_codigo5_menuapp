import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/models/product_model.dart';
import 'package:flutter_codigo5_menuapp/models/product_order_model.dart';
import 'package:flutter_codigo5_menuapp/services/order_service.dart';
import 'package:flutter_codigo5_menuapp/ui/general/colors.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/general_widget.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/text_widget.dart';

import '../../services/order_stream_service.dart';
import '../../ui/widgets/item_ingredient_widget.dart';

class ProductDetailPage extends StatefulWidget {
  ProductModel productModel;
  bool isGeneral;

  ProductDetailPage({
    required this.productModel,
    required this.isGeneral,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    double heigth = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        fit: StackFit.loose,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Hero(
                      tag: widget.isGeneral
                          ? "${widget.productModel.id}general"
                          : "${widget.productModel.id}promotion",
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(60.0),
                          bottomLeft: Radius.circular(60.0),
                        ),
                        child: CachedNetworkImage(
                          height: heigth * 0.45,
                          width: double.infinity,
                          imageUrl: widget.productModel.image,
                          fit: BoxFit.cover,
                          fadeInCurve: Curves.easeIn,
                          fadeInDuration: const Duration(milliseconds: 800),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) {
                            return const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: kBrandPrimaryColor,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned.fill(
                      bottom: -50.0,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 14.0),
                          constraints: BoxConstraints(
                            maxWidth: width * 0.8,
                            minWidth: width * 0.8,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  offset: const Offset(0, 5),
                                  blurRadius: 12.0,
                                ),
                              ]),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.productModel.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: kBrandPrimaryColor,
                                ),
                              ),
                              divider6,
                              TextNormal(
                                text: widget.productModel.categoryDescription ??
                                    "",
                              ),
                              divider6,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.punch_clock,
                                        color: Color(0xffE2CE6D),
                                      ),
                                      Text(
                                        "${widget.productModel.time} min",
                                      ),
                                    ],
                                  ),
                                  dividerWidth10,
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Color(0xffE2CE6D),
                                      ),
                                      Text(
                                        widget.productModel.rate
                                            .toStringAsFixed(1),
                                      ),
                                    ],
                                  ),
                                  dividerWidth10,
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.fastfood_sharp,
                                        color: Color(0xffE2CE6D),
                                      ),
                                      Text(
                                        "Porciones: ${widget.productModel.serving}",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              divider6,
                              Text(
                                "S./ ${widget.productModel.price}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: kBrandPrimaryColor,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          margin: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 12,
                                offset: const Offset(5, 5),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_sharp,
                            color: kBrandPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                divider40,
                divider40,
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextNormal(
                        text: "Descripción: ",
                      ),
                      divider12,
                      TextNormal(
                        text: widget.productModel.description,
                        color: kBrandPrimaryColor.withOpacity(0.6),
                      ),
                      divider12,
                      TextNormal(
                        text: "Ingredientes: ",
                      ),
                      divider12,
                      Wrap(
                        spacing: 12.0,
                        runSpacing: 5.0,
                        children: widget.productModel.ingredients
                            .map((e) => ItemIngredientWidget(
                                  text: e,
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                divider40,
                divider40,
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80.0,
              margin:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.4),
                    Colors.white.withOpacity(0.6),
                    Colors.white.withOpacity(0.8),
                    Colors.white,
                  ],
                ),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: quantity > 1
                        ? () {
                            quantity--;
                            setState(() {});
                          }
                        : null,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: quantity > 1
                            ? kBrandPrimaryColor
                            : kBrandPrimaryColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      minWidth: 42.0,
                      maxWidth: 42.0,
                    ),
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Text(
                      quantity.toString(),
                      style: const TextStyle(
                        color: kBrandPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      quantity++;
                      setState(() {});
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: kBrandPrimaryColor,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  dividerWidth10,
                  Expanded(
                    child: SizedBox(
                      height: 54.0,
                      child: ElevatedButton(
                        onPressed: () {
                          ProductOrderModel productOrder = ProductOrderModel(
                            id: widget.productModel.id!,
                            name: widget.productModel.name,
                            price: widget.productModel.price,
                            image: widget.productModel.image,
                            quantity: quantity,
                          );
                          OrderService().addProduct(productOrder);
                          OrderStreamService().addCounter();
                          quantity = 1;
                          setState(() {});
                          showSnackBar(context,"El producto se agregó a tu orden.",Colors.green,Icons.check_circle);
                        },
                        child: const Text(
                          "Agregar Compra",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: kBrandPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            side: BorderSide.none,
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
    );
  }
}
