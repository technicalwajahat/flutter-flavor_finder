import 'package:flavour_finder/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailRecipe extends StatefulWidget {
  const DetailRecipe({super.key});

  @override
  State<DetailRecipe> createState() => _DetailRecipeState();
}

class _DetailRecipeState extends State<DetailRecipe> {
  @override
  Widget build(BuildContext context) {
    var recipe = Get.arguments;
    return Scaffold(
      appBar: const AppBarWidget(text: "Recipe Detail"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Recipe Name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: Get.height * 0.01),
              Text(recipe['recipe_name']),
              SizedBox(height: Get.height * 0.02),
              const Text("Ingredients",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: Get.height * 0.01),
              Text(recipe['ingredients']),
              SizedBox(height: Get.height * 0.02),
              const Text("Nutrition",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: Get.height * 0.01),
              Text(recipe['nutrition']),
              SizedBox(height: Get.height * 0.02),
              const Text("Total Time",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: Get.height * 0.01),
              Text(recipe['total_time']),
            ],
          ),
        ),
      ),
    );
  }
}
