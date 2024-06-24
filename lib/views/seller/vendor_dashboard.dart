import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/product_model.dart';
import '../../viewModel/dashboard_viewmodel.dart';
import '../../viewModel/product_viewmodel.dart';
import '../../widgets/vendor_product_cards.dart';

class DrawerData {
  const DrawerData(this.label, this.selectedIcon);

  final String label;
  final Widget selectedIcon;
}

class VendorDashboard extends StatefulWidget {
  const VendorDashboard({super.key});

  @override
  State<VendorDashboard> createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard> {
  final _productViewModel = Get.put(ProductViewModel());
  final _dashboardViewModel = Get.put(DashboardViewModel());

  static List<DrawerData> destinations = <DrawerData>[
    const DrawerData('Home', Icon(Icons.home_rounded)),
    const DrawerData('Logout', Icon(Icons.logout_rounded))
  ];

  @override
  void initState() {
    super.initState();
    _productViewModel.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Vendor",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AutoSizeText(
              "Products",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: Get.height * 0.005,
            ),
            const AutoSizeText(
              "AR Hardware Tools",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: Get.height * 0.03,
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
                            VendorProductCard(product: products[index]),
                      ),
                    );
                  } else {
                    return const Center(
                      child: AutoSizeText(
                        'No product found. Add some using the "+" button!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
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
        tooltip: "Add Product",
        onPressed: () {
          Get.toNamed('/addProduct');
        },
        child: const Icon(Icons.add_circle_outlined),
      ),
      drawer: NavigationDrawer(
        onDestinationSelected: _dashboardViewModel.handleScreenChanged,
        selectedIndex: _dashboardViewModel.screenIndex.value,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 22, 16, 5),
            child: AutoSizeText(
              'AR Hardware Tool',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 5, 24, 10),
            child: Divider(
              color: Colors.black45,
            ),
          ),
          ...destinations.map(
            (DrawerData destination) {
              return NavigationDrawerDestination(
                label: AutoSizeText(destination.label),
                icon: destination.selectedIcon,
                selectedIcon: destination.selectedIcon,
              );
            },
          ),
        ],
      ),
    );
  }
}
