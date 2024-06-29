import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? id;
  final String? userId;
  final String? recipeName;
  final String? recipePrice;
  final String? recipeType;
  final String? recipeShipped;
  final String? recipeIngredients;
  final String? recipeStock;
  late final String? recipeImage;

  ProductModel({
    this.id,
    this.userId,
    required this.recipeName,
    required this.recipePrice,
    required this.recipeType,
    required this.recipeShipped,
    required this.recipeIngredients,
    required this.recipeStock,
    required this.recipeImage,
  });

  factory ProductModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return ProductModel(
      id: document.id,
      userId: data!['userId'] ?? '',
      recipeName: data['productName'] ?? '',
      recipePrice: data['productPrice'] ?? '',
      recipeType: data['productMaterial'] ?? '',
      recipeShipped: data['productShipped'] ?? '',
      recipeIngredients: data['productCategories'] ?? '',
      recipeStock: data['productStock'] ?? '',
      recipeImage: data['productImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['productName'] = recipeName;
    data['productPrice'] = recipePrice;
    data['productMaterial'] = recipeType;
    data['productShipped'] = recipeShipped;
    data['productCategories'] = recipeIngredients;
    data['productStock'] = recipeStock;
    data['productImage'] = recipeImage;
    return data;
  }
}
