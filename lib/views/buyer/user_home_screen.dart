import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/recipe_model.dart';
import '../../viewModel/product_viewmodel.dart';
import '../../widgets/user_product_cards.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final _productViewModel = Get.put(ProductViewModel());

  @override
  void initState() {
    super.initState();
    _productViewModel.fetchAllProducts('All');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 12, right: 24, left: 24, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AutoSizeText(
              "Recipes",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: Get.height * 0.005,
            ),
            const AutoSizeText(
              "Flavor Finder",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            StreamBuilder<List<ProductModel>>(
              stream: _productViewModel.productsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else {
                  List<ProductModel>? products = snapshot.data;
                  if (products != null && products.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: products.length,
                        itemBuilder: (context, index) =>
                            UserProductCard(product: products[index]),
                      ),
                    );
                  } else {
                    return const Center(
                      child: AutoSizeText(
                        'No recipe found!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed("/chatBot");
        },
        child: const Icon(Icons.smart_toy),
      ),
    );
  }
}
