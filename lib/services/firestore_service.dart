import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_codigo5_menuapp/models/category_model.dart';
import 'package:flutter_codigo5_menuapp/models/product_model.dart';

import '../models/order_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final String collection;

  FirestoreService({required this.collection});

  late final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection(collection);

  Future<List<ProductModel>> getProduct() async {
    List<ProductModel> products = [];
    QuerySnapshot _querySnapshot = await _collectionReference.get();

    _querySnapshot.docs.forEach((element) {
      Map<String, dynamic> product = element.data() as Map<String, dynamic>;
      product["id"] = element.id;

      ProductModel productModel = ProductModel.fromJson(product);

      products.add(productModel);
    });

    return products;
  }

  Future<List<CategoryModel>> getCategories() async {
    List<CategoryModel> categories = [];
    QuerySnapshot _querySnapshot = await _collectionReference.get();
    _querySnapshot.docs.forEach((element) {
      Map<String, dynamic> category = element.data() as Map<String, dynamic>;
      category["id"] = element.id;

      CategoryModel categoryModel = CategoryModel.fromJson(category);

      categories.add(categoryModel);
    });

    return categories;
  }

  Future<UserModel?> getUser(String emailUser) async {
    QuerySnapshot _querySnapshot =
        await _collectionReference.where('email', isEqualTo: emailUser).get();
    if (_querySnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot queryDocumentSnapshot = _querySnapshot.docs.first;
      UserModel userModel = UserModel.fromJson(
          queryDocumentSnapshot.data() as Map<String, dynamic>);
      userModel.id = queryDocumentSnapshot.id;
      return userModel;
    }
    return null;
  }

  Stream getStreamCategories() {
    return _collectionReference.orderBy('category').snapshots();
  }

  Stream getStreamProducts() {
    return _collectionReference.orderBy('name').snapshots();
  }

  Stream getStreamOrders() {
    return _collectionReference.orderBy('datetime').snapshots();
  }

  Future<String> addProduct(ProductModel productModel) async {
    DocumentReference documentReference =
        await _collectionReference.add(productModel.toJson());
    return documentReference.id;
  }

  // Update Product
  Future<int> updateProduct(ProductModel productModel) async {
    await _collectionReference
        .doc(productModel.id)
        .update(productModel.toJson());
    return 1;
  }

  // Delete Product
  Future<int> deleteProduct(ProductModel productModel) async {
    print(productModel.id);
    await _collectionReference.doc(productModel.id).delete();
    return 1;
  }

  // AddUser
  Future<String> addUser(UserModel userModel) async {
    try {
      DocumentReference documentReference =
          await _collectionReference.add(userModel.toJson());
      return documentReference.id;
    } on TimeoutException catch (e) {
      return Future.error("Error 01");
    } on SocketException catch (e) {
      return Future.error("Error 02");
    } on Error catch (e) {
      return Future.error("Error 03");
    }
  }

  Future<UserModel?> getRoleUser(String email) async {
    QuerySnapshot querySnapshot =
        await _collectionReference.where('email', isEqualTo: email).get();
    if (querySnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot queryDocumentSnapshot = querySnapshot.docs.first;
      UserModel userModel = UserModel.fromJson(
          queryDocumentSnapshot.data() as Map<String, dynamic>);
      userModel.id = queryDocumentSnapshot.id;
      return userModel;
    }
    return null;
  }

  // Add Order
  Future<String> addOrder(OrderModel orderModel) async {
    DocumentReference documentReference =
        await _collectionReference.add(orderModel.toJson());
    return documentReference.id;
  }

  // Update Order
  Future<int> updateStatusOrder(OrderModel orderModel) async {
    await _collectionReference.doc(orderModel.id).update({
      "status": orderModel.status,
    });
    return 1;
  }
}
