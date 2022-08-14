import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/models/category_model.dart';
import 'package:flutter_codigo5_menuapp/models/product_model.dart';
import 'package:flutter_codigo5_menuapp/services/firestore_service.dart';
import 'package:flutter_codigo5_menuapp/ui/general/colors.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/general_widget.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/text_field_widget.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/text_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../ui/widgets/my_appbar_widget.dart';

class ProductFormPage extends StatefulWidget {
  List<CategoryModel> categorylist;
  ProductModel? productoModel;

  ProductFormPage({required this.categorylist, this.productoModel});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  List<String> ingredientesList = [];
  String categoryValue = "";
  XFile? _image;
  bool isLoading = true;
  String imageLoaded = "";

  //TextEditingControllers
  TextEditingController txtProductName = TextEditingController();
  TextEditingController txtProductDescription = TextEditingController();
  TextEditingController txtProductPrice = TextEditingController();
  TextEditingController txtProductDiscount = TextEditingController();
  TextEditingController txtProductTime = TextEditingController();
  TextEditingController txtProductPlates = TextEditingController();
  TextEditingController txtProductRate = TextEditingController();
  TextEditingController txtProductIngredient = TextEditingController();

  final FirestoreService _productService =
      FirestoreService(collection: "products");

  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    getData();
  }

  getData() async {
    if (widget.productoModel == null) {
      // _categories = await _categoryService.getCategories();
      // categoryValue = _categories.first.id;
      categoryValue = widget.categorylist.first.id!;
      isLoading = false;
    } else {
      ingredientesList.clear();
      imageLoaded = widget.productoModel!.image;
      categoryValue = widget.productoModel!.categoryId;
      txtProductRate.text = widget.productoModel!.rate.toStringAsFixed(2);
      txtProductPrice.text = widget.productoModel!.price.toStringAsFixed(2);
      txtProductName.text = widget.productoModel!.name;
      txtProductDiscount.text =
          widget.productoModel!.discount.toStringAsFixed(2);
      ingredientesList = widget.productoModel!.ingredients;
      txtProductDescription.text = widget.productoModel!.description;
      txtProductTime.text = widget.productoModel!.time.toStringAsFixed(0);
      txtProductPlates.text = widget.productoModel!.serving.toStringAsFixed(0);
      isLoading = false;
    }
    setState(() {});
  }

  getImageGallery() async {
    ImagePicker _imagePicker = ImagePicker();
    _image = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  getImageCamera() async {
    ImagePicker _imagePicker = ImagePicker();
    _image = await _imagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  Future<String> uploadImageStorage() async {
    firebase_storage.Reference _reference = _storage.ref().child("Products");
    String time = DateTime.now().toString();
    firebase_storage.TaskSnapshot uploadTask = await _reference
        .child("imagenDesdeFlutter_$time.jpg")
        .putFile(File(_image!.path));
    String url = await uploadTask.ref.getDownloadURL();
    return url;
  }

  saveProduct() async {
    if (_formKey.currentState!.validate()) {

      isLoading = true;
      setState(() {});

      ProductModel productModel = ProductModel(
        image: "",
        categoryId: categoryValue,
        rate: double.parse(txtProductRate.text),
        price: double.parse(txtProductPrice.text),
        name: txtProductName.text,
        discount: double.parse(txtProductDiscount.text),
        ingredients: ingredientesList,
        description: txtProductDescription.text,
        time: int.parse(txtProductTime.text),
        serving: int.parse(txtProductPlates.text),
      );

      if (_image != null) {
        String imageUrl = await uploadImageStorage();
        productModel.image = imageUrl;
      } else {
        if (widget.productoModel != null) {
          productModel.image = widget.productoModel!.image;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              content: Row(
                children: const [
                  Icon(
                    Icons.image_not_supported,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "Por favor selecciona una imagen.",
                  ),
                ],
              ),
            ),
          );
          isLoading = false;
          setState(() {});
          return;
        }
      }

      if (widget.productoModel == null) {
        //Agregar nuevo
        _productService.addProduct(productModel).then((value) {
          isLoading = false;
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              content: Row(
                children: const [
                  Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text("El producto se guardo con éxito."),
                ],
              ),
            ),
          );
          Navigator.pop(context);
        });
      } else {
        //Actualizar
        productModel.id = widget.productoModel!.id;
        _productService.updateProduct(productModel).then((value) {
          isLoading = false;
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              content: Row(
                children: const [
                  Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text("El producto se actualizó con éxito."),
                ],
              ),
            ),
          );
          Navigator.pop(context);
        });
      }

      // if (_image != null) {
      //   isLoading = true;
      //   setState(() {});
      //   String imageUrl = await uploadImageStorage();
      //   ProductModel saveProduct = ProductModel(
      //     image: imageUrl,
      //     categoryId: categoryValue,
      //     rate: double.parse(txtProductRate.text),
      //     price: double.parse(txtProductPrice.text),
      //     name: txtProductName.text,
      //     discount: double.parse(txtProductDiscount.text),
      //     ingredients: ingredientesList,
      //     description: txtProductDescription.text,
      //     time: int.parse(txtProductTime.text),
      //     serving: int.parse(txtProductPlates.text),
      //   );
      //   _productService.addProduct(saveProduct).then((value) {
      //     isLoading = false;
      //     setState(() {});
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         backgroundColor: Colors.redAccent,
      //         behavior: SnackBarBehavior.floating,
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(12.0),
      //         ),
      //         content: Row(
      //           children: const [
      //             Icon(
      //               Icons.check,
      //               color: Colors.white,
      //             ),
      //             SizedBox(
      //               width: 10.0,
      //             ),
      //             Text("El producto se guardo con exito."),
      //           ],
      //         ),
      //       ),
      //     );
      //     Navigator.pop(context);
      //   });
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: Colors.redAccent,
      //       behavior: SnackBarBehavior.floating,
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(12.0),
      //       ),
      //       content: Row(
      //         children: const [
      //           Icon(
      //             Icons.image_not_supported,
      //             color: Colors.white,
      //           ),
      //           SizedBox(
      //             width: 10.0,
      //           ),
      //           Text("Por favor selecciona una imagen."),
      //         ],
      //       ),
      //     ),
      //   );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: MyAppBarWidget(text: "${widget.productoModel == null ? 'Agregar' : 'Actualizar'} producto"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFieldWidget(
                        hintText: "Nombre del producto",
                        textEditingController: txtProductName),
                    TextFieldWidget(
                      hintText: "Descripción",
                      textEditingController: txtProductDescription,
                      maxLines: 4,
                    ),
                    Row(
                      children: [
                        TextNormal(text: "Categorias"),
                      ],
                    ),
                    divider6,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12.0,
                            offset: const Offset(4, 4),
                          ),
                        ],
                      ),
                      child: DropdownButton(
                        value: categoryValue,
                        isExpanded: true,
                        items: widget.categorylist
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.id,
                                child: Text(
                                  e.category,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (String? value) {
                          categoryValue = value!;
                          setState(() {});
                        },
                      ),
                    ),
                    divider20,
                    divider6,
                    Row(
                      children: [
                        Expanded(
                          child: TextFieldWidget(
                            hintText: "Precio",
                            textEditingController: txtProductPrice,
                            isNumeric: true,
                          ),
                        ),
                        dividerWidth10,
                        Expanded(
                          child: TextFieldWidget(
                            hintText: "Descuento",
                            textEditingController: txtProductDiscount,
                            isNumeric: true,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFieldWidget(
                            hintText: "Tiempo",
                            textEditingController: txtProductTime,
                            isNumeric: true,
                          ),
                        ),
                        dividerWidth10,
                        Expanded(
                          child: TextFieldWidget(
                            hintText: "Porciones",
                            textEditingController: txtProductPlates,
                            isNumeric: true,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFieldWidget(
                            hintText: "Calificación",
                            textEditingController: txtProductRate,
                            isNumeric: true,
                          ),
                        ),
                        dividerWidth10,
                        const Expanded(
                          child: SizedBox(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30.0,
                      child: Divider(
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextNormal(
                          text: "Ingredientes: ",
                        ),
                      ],
                    ),
                    divider12,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextFieldWidget(
                            hintText: "Ingrediente",
                            textEditingController: txtProductIngredient,
                            validate: false,
                          ),
                        ),
                        dividerWidth10,
                        InkWell(
                          onTap: () {
                            ingredientesList.add(txtProductIngredient.text);
                            txtProductIngredient.clear();
                            setState(() {});
                          },
                          child: Container(
                            height: 50.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                              color: kBrandSecondaryColor,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ingredientesList.isNotEmpty
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 12.0,
                                  offset: const Offset(4, 4),
                                ),
                              ],
                            ),
                            child: ListView.builder(
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: ingredientesList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: TextNormal(
                                      text: ingredientesList[index],
                                    ),
                                    trailing: IconButton(
                                      icon: SvgPicture.asset(
                                        'assets/icons/trash.svg',
                                        height: 18.0,
                                        color:
                                            kBrandPrimaryColor.withOpacity(0.8),
                                      ),
                                      onPressed: () {
                                        ingredientesList.removeAt(index);
                                        setState(() {});
                                      },
                                    ),
                                  );
                                }),
                          )
                        : Container(
                            margin: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/box.png',
                                  height: 90.0,
                                  color: kBrandPrimaryColor.withOpacity(0.8),
                                ),
                                divider6,
                                TextNormal(
                                  text: "Aún no hay ingredientes",
                                ),
                              ],
                            ),
                          ),
                    divider20,
                    const SizedBox(
                      height: 30.0,
                      child: Divider(
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                    ),
                    TextNormal(
                      text: "Imagen del Producto",
                    ),
                    divider20,
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40.0,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                getImageGallery();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xffc1121f),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              icon: const Icon(Icons.image_search_sharp),
                              label: Text(
                                "Galería",
                              ),
                            ),
                          ),
                        ),
                        dividerWidth10,
                        Expanded(
                          child: SizedBox(
                            height: 40.0,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                getImageCamera();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xff669bbc),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              icon: const Icon(Icons.camera_alt),
                              label: Text(
                                "Cámara",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    divider20,
                    Container(
                      height: height * 0.32,
                      width: width * 0.85,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 12.0,
                            offset: const Offset(4, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14.0),
                        // child: Image.asset(
                        //   fit: BoxFit.cover,
                        //   'assets/images/placeholder.png',
                        // ),
                        // child: Image.network(
                        //   "https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                        //   fit: BoxFit.cover,
                        // ),
                        child: Image(
                          image: _image != null
                              ? FileImage(File(_image!.path))
                              : imageLoaded != ""
                                  ? NetworkImage(imageLoaded)
                                  : AssetImage('assets/images/placeholder.png')
                                      as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    divider30,
                    SizedBox(
                      height: 48.0,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          saveProduct();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: kBrandPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                        ),
                        icon: Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Guardar",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    divider40,
                    divider40,
                  ],
                ),
              ),
            ),
          ),
          isLoading
              ? Container(
                  color: Colors.white.withOpacity(0.8),
                  child: Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: kBrandSecondaryColor,
                        strokeWidth: 2.0,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
