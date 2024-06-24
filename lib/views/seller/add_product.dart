import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/product_model.dart';
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
      appBar: const AppBarWidget(text: "Add Product"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AddProductFields(
                    name: "Product Name",
                    regExp: "[a-zA-Z ]",
                    enabled: true,
                    validator: "Product Name cannot be empty",
                    textInputType: TextInputType.name,
                    controller: productViewModel.productName,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: Get.height * 0.02),
                  AddProductFields(
                    name: "Product Price",
                    regExp: "[0-9]",
                    validator: "Product Price cannot be empty",
                    textInputType: TextInputType.number,
                    controller: productViewModel.productPrice,
                    textInputAction: TextInputAction.next,
                    enabled: true,
                  ),
                  SizedBox(height: Get.height * 0.02),
                  AddProductFields(
                    regExp: "[a-zA-Z ]",
                    name: "Product Material",
                    enabled: true,
                    validator: "Product Material cannot be empty",
                    textInputType: TextInputType.name,
                    controller: productViewModel.productMaterial,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: Get.height * 0.02),
                  AddProductFields(
                    regExp: "[0-9]",
                    name: "Product Stock",
                    enabled: true,
                    validator: "Product Stock cannot be empty",
                    textInputType: TextInputType.number,
                    controller: productViewModel.productStock,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: Get.height * 0.02),
                  DropdownButtonFormField<String>(
                    autofocus: false,
                    value: productViewModel.productCategory.value,
                    isExpanded: true,
                    onChanged: productViewModel.onChangedCategory,
                    items: <String>[
                      'Select Category',
                      'Hand Tools',
                      'Power Tools',
                      'Measurement Tools',
                      'Plumping Tools',
                      'Cutting Tools',
                      'Fastening Tools',
                      'Gardening Tools',
                      'Electrical Tools',
                      'Flooring & Paints',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: AutoSizeText(value),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == "Select Category") {
                        return ("Please Choose a Category");
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
                      hintText: "Categories",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.02),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      autofocus: false,
                      value: productViewModel.productColor.value,
                      isExpanded: true,
                      onChanged: productViewModel.colorEnabled.value
                          ? productViewModel.onChangedColor
                          : null,
                      items: [
                        const DropdownMenuItem<String>(
                          value: "No Color",
                          child: AutoSizeText("No Color"),
                        ),
                        ...productViewModel.colorMap.keys
                            .where((color) => color != "No Color")
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: AutoSizeText(value),
                          );
                        }),
                      ],
                      validator: (value) {
                        if (productViewModel.productCategory.value ==
                            "Flooring & Paints") {
                          if (value == "No Color") {
                            return ("Please Choose a Color");
                          }
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 15, 0, 15),
                        hintText: "Colors",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.02),
                  AddProductFields(
                    name: "Product Shipped",
                    regExp: "[a-zA-Z ]",
                    enabled: false,
                    validator: "Product Shipped cannot be empty",
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
      productViewModel.productColorCode.value =
          productViewModel.getColorCode(productViewModel.productColor.value)!;
      FocusManager.instance.primaryFocus?.unfocus();
      if (_formKey.currentState!.validate()) {
        final productModel = ProductModel(
          userId: authRepo.firebaseUser.value!.uid,
          productName: productViewModel.productName.text.trim(),
          productPrice: productViewModel.productPrice.text.trim(),
          productMaterial: productViewModel.productMaterial.text.trim(),
          productShipped: productViewModel.productShipped.text.trim(),
          productCategories: productViewModel.productCategory.value.trim(),
          productStock: productViewModel.productStock.text.trim(),
          productImage: productViewModel.storagePath.value,
          productColor: productViewModel.productColorCode,
        );
        productViewModel.addProduct(productModel, context).then((value) {
          productViewModel.fetchProducts();
        });
      }
    }
  }
}
