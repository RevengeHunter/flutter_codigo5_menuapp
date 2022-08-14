import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/pages/admin/product_page.dart';
import 'package:flutter_codigo5_menuapp/ui/general/colors.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/background_widget.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/general_widget.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/text_widget.dart';

import '../../ui/widgets/item_menu_widget.dart';
import 'category_page.dart';
import 'dashboard_page.dart';
import 'order_admin_page.dart';

class HomeAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          const BackgroundWidget(),
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    divider30,
                    TextNormal(
                      text: "Bienvenido",
                    ),
                    H1(
                      text: "Las espadas de Ramón",
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(4, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextNormal(
                            text: "23 de abril del 2022",
                            color: kBrandPrimaryColor.withOpacity(0.6),
                          ),
                          Text(
                            "#34",
                            style: TextStyle(
                              color: kBrandPrimaryColor,
                              fontSize: 34.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextNormal(
                            text: "Cantidad de ordenes en el dia",
                            color: kBrandPrimaryColor.withOpacity(0.8),
                          ),
                        ],
                      ),
                    ),
                    divider30,
                    GridView.count(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing: 12.0,
                      children: [
                        ItemMenuWidget(
                          text: "Ordenes",
                          imagenName: "burger",
                          toPage: OrderAdminPage(),
                        ),
                        ItemMenuWidget(
                          text: "Productos",
                          imagenName: "products",
                          toPage: ProductPage(),
                        ),
                        ItemMenuWidget(
                          text: "Categorias",
                          imagenName: "category",
                          toPage: CategoryPage(),
                        ),
                        ItemMenuWidget(
                          text: "Reportes",
                          imagenName: "report",
                          toPage: DashboardPage(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
