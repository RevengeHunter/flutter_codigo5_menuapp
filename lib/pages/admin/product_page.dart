import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/models/category_model.dart';
import 'package:flutter_codigo5_menuapp/pages/admin/product_form_page.dart';
import 'package:flutter_codigo5_menuapp/services/firestore_service.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/floating_button_widget.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/my_appbar_widget.dart';

import '../../models/product_model.dart';
import '../../ui/widgets/general_widget.dart';
import '../../ui/widgets/item_admin_producto_widget.dart';

class ProductPage extends StatefulWidget {
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final FirestoreService _productService =
      FirestoreService(collection: "products");
  List<ProductModel> productModelList = [];

  final FirestoreService _categoryReference =
      FirestoreService(collection: "categories");
  List<CategoryModel> categoryList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    categoryList = await _categoryReference.getCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: MyAppBarWidget(text: "Lista de Productos"),
      ),
      floatingActionButton: FloatingButtonWidget(onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductFormPage(
              categorylist: categoryList,
            ),
          ),
        );
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: _productService.getStreamProducts(),
              builder: (BuildContext context, AsyncSnapshot snap) {
                if (snap.hasData) {
                  QuerySnapshot collection = snap.data;
                  productModelList = collection.docs.map((e) {
                    ProductModel product =
                        ProductModel.fromJson(e.data() as Map<String, dynamic>);
                    product.id = e.id;

                    product.categoryDescription = categoryList.isNotEmpty
                        ? categoryList
                            .firstWhere(
                                (element) => element.id == product.categoryId)
                            .category
                        : "";

                    return product;
                  }).toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: productModelList.length,
                    itemBuilder: (context, index) {
                      // return Container();
                      return ItemAdminProductWidget(
                        productModel: productModelList[index],
                        categorylist: categoryList,
                      );
                    },
                  );
                }
                return loadingWidget();
              },
            ),
            divider40,
            divider40,
          ],
        ),
      ),
    );
  }
}
