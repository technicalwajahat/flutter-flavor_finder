import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/checkout_model.dart';
import '../models/recipe_model.dart';
import '../repository/auth_repository.dart';
import '../repository/product_repository.dart';

class ProductViewModel extends GetxController {
  static ProductViewModel get instance => Get.find();

  final ProductRepository _productRepo = Get.put(ProductRepository());
  final AuthRepository _authRepo = Get.put(AuthRepository());
  var storagePath = "Choose Image!".obs;
  Rx<bool> colorEnabled = false.obs;

  final productName = TextEditingController();
  final productPrice = TextEditingController();
  final productMaterial = TextEditingController();
  final productStock = TextEditingController();
  final productCategory = TextEditingController();
  final productShipped = TextEditingController(text: "Ships all over Pakistan");

  final _productsController = StreamController<List<ProductModel>>.broadcast();
  final _checkoutController = StreamController<List<CheckoutModel>>.broadcast();

  Stream<List<ProductModel>> get productsStream => _productsController.stream;

  Stream<List<CheckoutModel>> get checkoutStream => _checkoutController.stream;

  // Clear Data
  void clearFormData() {
    productName.clear();
    productPrice.clear();
    productMaterial.clear();
    productStock.clear();
    productCategory.clear();
    storagePath.value = "Choose Image!";
    colorEnabled.value = false;
  }

  // Upload Product
  Future<String> uploadProduct(File imageFile) async {
    return await _productRepo.uploadProduct("products/", imageFile);
  }

  // Add Product
  Future<void> addProduct(
      ProductModel productModel, BuildContext context) async {
    await _productRepo.addProduct(productModel, context);
  }

  // Fetch Product
  fetchProducts() async {
    var userId = _authRepo.firebaseUser.value!.uid;
    List<ProductModel> products = await _productRepo.getProducts(userId);
    _productsController.add(products);
  }

  // Fetch All Product
  fetchAllProducts(String category) async {
    List<ProductModel> products = await _productRepo.getAllProducts(category);
    _productsController.add(products);
  }

  // Update Product
  Future<void> updateProduct(
      ProductModel productModel, BuildContext context) async {
    await _productRepo.updateProduct(productModel, context);
    clearFormData();
  }

  // Delete Product
  Future<void> deleteProduct(String id) async {
    await _productRepo.deleteProduct(id);
  }

  // Add Checkout Product
  Future<void> checkoutProduct(
      CheckoutModel checkout, BuildContext context, argument) async {
    await _productRepo.checkoutProduct(checkout, context, argument);
  }

  // Fetch Product By User ID
  fetchCheckoutProduct() async {
    var userId = _authRepo.firebaseUser.value!.uid;
    List<CheckoutModel> checkout =
        await _productRepo.getCheckoutProducts(userId);
    _checkoutController.add(checkout);
  }

  // Upload Product
  void uploadProductAPI(
      File imageFile, BuildContext context, List<dynamic> colorCodes) async {
    await _productRepo
        .sendImageToAPI(imageFile, context, colorCodes)
        .then((value) {
      Get.toNamed('/paintWall', arguments: value!['result']);
    });
  }

  @override
  void onClose() {
    _productsController.close();
    super.onClose();
  }
}
