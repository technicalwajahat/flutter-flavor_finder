import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/product_model.dart';
import '../../viewModel/dashboard_viewmodel.dart';
import '../../viewModel/product_viewmodel.dart';
import '../../widgets/user_product_cards.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final _productViewModel = Get.put(ProductViewModel());
  final _dashboardViewModel = Get.put(DashboardViewModel());

  final List<String> _chipLabel = [
    'All',
    'Hand Tools',
    'Power Tools',
    'Measurement Tools',
    'Plumping Tools',
    'Cutting Tools',
    'Fastening Tools',
    'Gardening Tools',
    'Electrical Tools',
    'Flooring & Paints',
  ];

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
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: Get.height * 0.005,
            ),
            const AutoSizeText(
              "Flavor Finder",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: 5,
                  children: List<Widget>.generate(
                    _chipLabel.length,
                    (int index) {
                      return ChoiceChip(
                        label: AutoSizeText(_chipLabel[index]),
                        selected: _dashboardViewModel.selectedChip == index,
                        onSelected: (bool selected) {
                          _dashboardViewModel.selectedChip =
                              selected ? index : null;
                          if (selected) {
                            _productViewModel
                                .fetchAllProducts(_chipLabel[index]);
                          } else {
                            _productViewModel.fetchAllProducts('All');
                          }
                        },
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.02),
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
    );
  }
}
