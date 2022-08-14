import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/models/category_model.dart';
import 'package:flutter_codigo5_menuapp/services/firestore_service.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/my_appbar_widget.dart';

import '../../ui/widgets/floating_button_widget.dart';
import '../../ui/widgets/general_widget.dart';
import '../../ui/widgets/item_admin_category_widget.dart';

class CategoryPage extends StatelessWidget {
  final FirestoreService _categoryService =
      FirestoreService(collection: 'categories');
  List<CategoryModel> _categoryModelList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: MyAppBarWidget(
          text: "Categorías",
        ),
      ),
      floatingActionButton: FloatingButtonWidget(
        onTap: (){},
      ),
      body: StreamBuilder(
        stream: _categoryService.getStreamCategories(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.hasData) {
            QuerySnapshot collection = snap.data;
            _categoryModelList = collection.docs.map((e) {
              CategoryModel _categoryModel =
                  CategoryModel.fromJson(e.data() as Map<String, dynamic>);
              _categoryModel.id = e.id;
              return _categoryModel;
            }).toList();
            return ListView.builder(
              itemCount: _categoryModelList.length,
              itemBuilder: (BuildContext context, int index) {
                return ItemAdminCategoryWidget(
                  categoryModel: _categoryModelList[index],
                  onDelete: () {},
                  onUpdate: () {},
                );
              },
            );
          }
          return loadingWidget();
        },
      ),
    );
  }
}
