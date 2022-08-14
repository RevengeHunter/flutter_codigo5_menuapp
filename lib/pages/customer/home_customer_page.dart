import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/helpers/sp_global.dart';
import 'package:flutter_codigo5_menuapp/models/category_model.dart';
import 'package:flutter_codigo5_menuapp/models/product_model.dart';
import 'package:flutter_codigo5_menuapp/services/firestore_service.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/item_product_widget.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/text_widget.dart';
import '../../ui/general/colors.dart';
import '../../ui/widgets/general_widget.dart';
import '../../ui/widgets/item_category_widget.dart';
import '../../ui/widgets/item_promotion_widget.dart';
import '../../ui/widgets/search_widget.dart';
import '../../utils/search_product_delegate.dart';

class HomeCustomerPage extends StatefulWidget {
  @override
  State<HomeCustomerPage> createState() => _HomeCustomerPageState();
}

class _HomeCustomerPageState extends State<HomeCustomerPage> {
  final FirestoreService _productService =
      FirestoreService(collection: "products");

  final FirestoreService _categorieService =
      FirestoreService(collection: "categories");

  List<ProductModel> products = [];
  List<ProductModel> productsAux = [];
  List<ProductModel> promotionProducts = [];

  List<CategoryModel> categories = [];

  String indexCategory = "";

  bool isLoading = true;
  
  final SPGlobal _prefs = SPGlobal();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFirebase();
    _prefs.isLogin = false;
  }

  getDataFirebase() async {
    categories = await _categorieService.getCategories();
    categories.insert(
        0,
        CategoryModel(
          category: "Todos",
          status: true,
          id: "0",
        ));

    products = await _productService.getProduct();
    products = products.map((e) {
      print(e);
      String categoryDescription = categories
          .firstWhere((element) => element.id == e.categoryId)
          .category;
      e.categoryDescription = categoryDescription;
      return e;
    }).toList();
    productsAux = products;
    promotionProducts =
        products.where((element) => element.discount > 0).toList();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isLoading ? SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextNormal(
                  text: "Bienvenido, ${ _prefs.fullName.indexOf(' ').isNegative ? _prefs.fullName : _prefs.fullName.substring(0,_prefs.fullName.indexOf(' '))}",
                ),
                Text(
                  "Las espadas de Rámon",
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
                divider12,
                SearchWidget(
                  onTap: () async {
                    final res = await showSearch(
                      context: context,
                      delegate: SearchProductDelegate(
                        products: products,
                      ),
                    );
                    print(res);
                  },
                ),
                divider12,
                TextNormal(
                  text: "Promociones",
                ),
                divider12,
                SizedBox(
                  height: 260.0,
                  child: PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: promotionProducts.length,
                    controller: PageController(
                      initialPage: 0,
                      viewportFraction: 0.8,
                    ),
                    padEnds: false,
                    itemBuilder: (BuildContext context, int index) {
                      return ItemPromotionWidget(
                        productModel: promotionProducts[index],
                      );
                    },
                  ),
                ),
                divider20,
                TextNormal(
                  text: "Categorias",
                ),
                divider12,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                      children: categories
                          .map(
                            (e) => ItemCategoryWidget(
                              text: e.category,
                              selected: indexCategory == e.id ? true : false,
                              onTap: () {
                                indexCategory = e.id!;
                                print(e.id);
                                if (e.id == "0") {
                                  products = productsAux;
                                } else {
                                  print(productsAux);
                                  products = productsAux;
                                  products = products
                                      .where((element) =>
                                          element.categoryId == e.id)
                                      .toList();
                                }
                                setState(() {});
                              },
                            ),
                          )
                          .toList()),
                ),
                divider20,
                products.isNotEmpty
                    ? ListView.builder(
                        itemCount: products.length,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return ItemProductWidget(
                            productModel: products[index],
                          );
                        },
                      )
                    : Container(
                        width: double.infinity,
                        height: 200,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/box.png',
                              height: 80.0,
                            ),
                            divider6,
                            TextNormal(
                                text: "Aun no hay productos en esta categoría"),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ) : Center(child: SizedBox(
        width: 20,
          height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: kBrandSecondaryColor,
        ),
      ),),
    );
  }
}
