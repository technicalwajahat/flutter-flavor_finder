import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/recipe_model.dart';
import '../../repository/auth_repository.dart';
import '../../viewModel/product_viewmodel.dart';
import '../../widgets/appBar.dart';
import '../../widgets/edit_product_fields.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  ProductViewModel productViewModel = Get.put(ProductViewModel());

  final authRepo = Get.put(AuthRepository());
  final _formKey = GlobalKey<FormState>();
  final product = Get.arguments["product"] as ProductModel;

  @override
  Widget build(BuildContext context) {
    final id = product.id;
    final userId = TextEditingController(text: product.userId);
    final productName = TextEditingController(text: product.recipeName);
    final productPrice = TextEditingController(text: product.recipePrice);
    final productMaterial = TextEditingController(text: product.recipeType);
    final productStock = TextEditingController(text: product.recipeStock);
    final productIngredeints =
        TextEditingController(text: product.recipeIngredients);
    final productShipped = TextEditingController(text: product.recipeShipped);

    return Scaffold(
      appBar: const AppBarWidget(text: "Edit Recipe"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  EditProductFields(
                    name: "Recipe Name",
                    regExp: "[a-zA-Z ]",
                    enabled: true,
                    validator: "Recipe Name cannot be empty",
                    textInputType: TextInputType.name,
                    controller: productName,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: Get.height * 0.02),
                  EditProductFields(
                    name: "Recipe Price",
                    regExp: "[0-9]",
                    validator: "Recipe Price cannot be empty",
                    textInputType: TextInputType.number,
                    controller: productPrice,
                    textInputAction: TextInputAction.next,
                    enabled: true,
                  ),
                  SizedBox(height: Get.height * 0.02),
                  EditProductFields(
                    regExp: "[a-zA-Z ]",
                    name: "Recipe Material",
                    enabled: true,
                    validator: "Recipe Material cannot be empty",
                    textInputType: TextInputType.name,
                    controller: productMaterial,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: Get.height * 0.02),
                  EditProductFields(
                    regExp: "[0-9]",
                    name: "Recipe Stock",
                    enabled: true,
                    validator: "Recipe Stock cannot be empty",
                    textInputType: TextInputType.number,
                    controller: productStock,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: Get.height * 0.02),
                  EditProductFields(
                    regExp: "[a-zA-z_,@ ]",
                    name: "Recipe Ingredients",
                    enabled: true,
                    validator: "Recipe Ingredients cannot be empty",
                    textInputType: TextInputType.text,
                    controller: productIngredeints,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: Get.height * 0.02),
                  EditProductFields(
                    name: "Product Shipped",
                    regExp: "[a-zA-Z ]",
                    enabled: false,
                    validator: "Product Shipped cannot be empty",
                    textInputType: TextInputType.name,
                    controller: productShipped,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: Get.height * 0.03),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      _pickImageFromGallery();
                    },
                    child: const AutoSizeText(
                      "Choose Image",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.016),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      _updateProduct(
                          context,
                          id!,
                          userId,
                          productName,
                          productPrice,
                          productMaterial,
                          productStock,
                          productShipped);
                    },
                    child: const AutoSizeText(
                      "Update",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _pickImageFromGallery() async {
    await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100)
        .then((value) {
      productViewModel.uploadProduct(File(value!.path)).then((value) {
        productViewModel.storagePath.value = value;
      });
    });
  }

  void _updateProduct(
      BuildContext context,
      String id,
      TextEditingController userId,
      TextEditingController productName,
      TextEditingController productPrice,
      TextEditingController productMaterial,
      TextEditingController productStock,
      TextEditingController productShipped) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      final productModel = ProductModel(
        userId: userId.text,
        id: id,
        recipeName: productName.text.trim(),
        recipePrice: productPrice.text.trim(),
        recipeType: productMaterial.text.trim(),
        recipeShipped: productShipped.text.trim(),
        recipeStock: productStock.text.trim(),
        recipeIngredients: productViewModel.productCategory.text.trim(),
        recipeImage: productViewModel.storagePath.value == "Choose Image!"
            ? product.recipeImage
            : productViewModel.storagePath.value,
      );
      productViewModel.updateProduct(productModel, context);
    }
  }
}
