import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/models/category_model.dart';
import 'package:flutter_svg/svg.dart';

import '../general/colors.dart';

class ItemAdminCategoryWidget extends StatelessWidget {
  CategoryModel categoryModel;
  Function onDelete;
  Function onUpdate;

  ItemAdminCategoryWidget({
    required this.categoryModel,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: kBrandPrimaryColor,
          child: Text(
            categoryModel.category[0],
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        title: Text(categoryModel.category),
        subtitle:
            Text("Estado: ${categoryModel.status ? 'Activo' : 'Inactivo'}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                onDelete();
              },
              icon: SvgPicture.asset(
                'assets/icons/trash.svg',
                color: kBrandPrimaryColor.withOpacity(0.8),
                height: 20.0,
              ),
            ),
            IconButton(
              onPressed: () {
                onUpdate();
              },
              icon: SvgPicture.asset(
                'assets/icons/edit.svg',
                color: kBrandPrimaryColor.withOpacity(0.8),
                height: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
