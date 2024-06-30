import 'package:flavour_finder/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewRecipes extends StatefulWidget {
  const ViewRecipes({super.key});

  @override
  State<ViewRecipes> createState() => _ViewRecipesState();
}

class _ViewRecipesState extends State<ViewRecipes> {
  @override
  Widget build(BuildContext context) {
    var recipes = Get.arguments;
    return Scaffold(
      appBar: const AppBarWidget(text: "View Recipes"),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        child: ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return Card(
              elevation: 3,
              child: ListTile(
                title: Text(
                  recipe['recipe_name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(recipe['ingredients']),
                onTap: () {
                  Get.toNamed("/detailRecipe", arguments: recipe);
                },
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
            );
          },
        ),
      ),
    );
  }
}
