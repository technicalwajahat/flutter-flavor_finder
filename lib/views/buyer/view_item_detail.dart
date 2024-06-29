import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';

import '../../widgets/appBar.dart';

class ViewItemDetail extends StatefulWidget {
  const ViewItemDetail({super.key});

  @override
  State<ViewItemDetail> createState() => _ViewItemDetailState();
}

class _ViewItemDetailState extends State<ViewItemDetail> {
  var products = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(text: "Product Detail"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AutoSizeText(
                    "Product Name",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  AutoSizeText(
                    "${products[0].recipeName}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AutoSizeText(
                    "Product Price",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  AutoSizeText(
                    "${products[0].recipePrice}\$",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AutoSizeText(
                    "Product Material",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  AutoSizeText(
                    "${products[0].recipeType}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AutoSizeText(
                    "Product Stock",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  AutoSizeText(
                    "${products[0].recipeStock}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AutoSizeText(
                    "Product Shipped",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  AutoSizeText(
                    "${products[0].recipeShipped}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AutoSizeText(
                    "Product Categories",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  AutoSizeText(
                    "${products[0].recipeIngredients}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AutoSizeText(
                    "Product Color Code",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  AutoSizeText(
                    "${products[0].recipeColor}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              PersistentShoppingCart().showAndUpdateCartItemWidget(
                inCartWidget: Container(
                  margin: EdgeInsets.zero,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.red),
                  ),
                  child: const Center(
                    child: AutoSizeText(
                      'Remove',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                notInCartWidget: Container(
                  margin: EdgeInsets.zero,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: AutoSizeText(
                      'Add to Cart',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                product: PersistentShoppingCartItem(
                  productId: products[0].id.toString(),
                  productName: products[0].recipeName.toString(),
                  unitPrice: double.parse(products[0].recipePrice.toString()),
                  quantity: 1,
                  productDescription: products[0].recipeType,
                  productThumbnail: products[0].recipeImage,
                ),
              ),
              SizedBox(height: Get.height * 0.01),
              products[0].recipeIngredients == "Flooring & Paints"
                  ? FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        Get.toNamed("/takePicture",
                            arguments: [products[0].recipeColor]);
                      },
                      child: const AutoSizeText(
                        "Visualize Paint",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
