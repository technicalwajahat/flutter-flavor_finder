import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/recipe_model.dart';
import '../../repository/auth_repository.dart';
import '../../utils/utils.dart';
import '../../viewModel/product_viewmodel.dart';
import '../../widgets/add_product_fields.dart';
import '../../widgets/appBar.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  ProductViewModel productViewModel = Get.put(ProductViewModel());
  final _formKey = GlobalKey<FormState>();
  final authRepo = Get.put(AuthRepository());

  @override
  void initState() {
    super.initState();
    productViewModel.clearFormData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(text: "Add Recipe"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AddProductFields(
                    name: "Recipe Name",
                    regExp: "[a-zA-Z ]",
                    enabled: true,
                    validator: "Recipe Name cannot be empty",
                    textInputType: TextInputType.name,
                    controller: productViewModel.productName,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: Get.height * 0.02),
                  AddProductFields(
                    name: "Recipe Price",
                    regExp: "[0-9]",
                    validator: "Recipe Price cannot be empty",
                    textInputType: TextInputType.number,
                    controller: productViewModel.productPrice,
                    textInputAction: TextInputAction.next,
                    enabled: true,
                  ),
                  SizedBox(height: Get.height * 0.02),
                  AddProductFields(
                    regExp: "[a-zA-Z ]",
                    name: "Recipe Type",
                    enabled: true,
                    validator: "Recipe Type cannot be empty",
                    textInputType: TextInputType.name,
                    controller: productViewModel.productMaterial,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: Get.height * 0.02),
                  AddProductFields(
                    regExp: "[0-9]",
                    name: "Recipe Stock",
                    enabled: true,
                    validator: "Recipe Stock cannot be empty",
                    textInputType: TextInputType.number,
                    controller: productViewModel.productStock,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: Get.height * 0.02),
                  AddProductFields(
                    regExp: "[a-zA-z_,@ ]",
                    name: "Recipe Ingredients",
                    enabled: true,
                    validator: "Recipe Ingredients cannot be empty",
                    textInputType: TextInputType.text,
                    controller: productViewModel.productCategory,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: Get.height * 0.02),
                  AddProductFields(
                    name: "Recipe Shipped",
                    regExp: "[a-zA-Z ]",
                    enabled: false,
                    validator: "Recipe Shipped cannot be empty",
                    textInputType: TextInputType.name,
                    controller: productViewModel.productShipped,
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
                      _addProduct(context);
                    },
                    child: const AutoSizeText(
                      "Add Product",
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

  void _addProduct(BuildContext context) {
    if (productViewModel.storagePath.value == "Choose Image!") {
      Utils.snackBar("Please choose an image", context);
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
      if (_formKey.currentState!.validate()) {
        final productModel = ProductModel(
          userId: authRepo.firebaseUser.value!.uid,
          recipeName: productViewModel.productName.text.trim(),
          recipePrice: productViewModel.productPrice.text.trim(),
          recipeType: productViewModel.productMaterial.text.trim(),
          recipeShipped: productViewModel.productShipped.text.trim(),
          recipeIngredients: productViewModel.productCategory.text.trim(),
          recipeStock: productViewModel.productStock.text.trim(),
          recipeImage: productViewModel.storagePath.value,
        );
        productViewModel.addProduct(productModel, context).then((value) {
          productViewModel.fetchProducts();
        });
      }
    }
  }
}
