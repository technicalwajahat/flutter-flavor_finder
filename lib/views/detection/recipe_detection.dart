import 'package:flavour_finder/viewModel/product_viewmodel.dart';
import 'package:flavour_finder/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecipeDetection extends StatefulWidget {
  const RecipeDetection({super.key});

  @override
  State<RecipeDetection> createState() => _RecipeDetectionState();
}

class _RecipeDetectionState extends State<RecipeDetection> {
  final ProductViewModel _productViewModel = Get.put(ProductViewModel());

  final _textFields = <TextEditingController>[];
  final _allIngredients = <String>[];

  var ingredients = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(text: "Recipe Recommendation"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListView.separated(
                  shrinkWrap: true,
                  itemCount: _textFields.length,
                  itemBuilder: (context, index) => Row(
                        children: [
                          Expanded(
                            child: TextField(
                              key: UniqueKey(),
                              controller: _textFields[index],
                              decoration: InputDecoration(
                                labelText: 'Enter Ingredients',
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              if (_textFields.isNotEmpty &&
                                  index < _textFields.length) {
                                setState(() {
                                  _textFields.removeAt(index);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: Get.height * 0.025)),
              SizedBox(height: Get.height * 0.025),
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _textFields.add(TextEditingController());
                  });
                },
                child: const Text(
                  'Add Ingredients',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.025),
              _textFields.isNotEmpty
                  ? FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _allIngredients.clear();
                          for (var controller in _textFields) {
                            _allIngredients.add(controller.text);
                          }
                          ingredients = _allIngredients.join(' ');
                        });
                        _productViewModel.fetchRecipes(ingredients);
                      },
                      child: const Text(
                        'View Recipes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
