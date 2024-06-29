import 'package:flavour_finder/widgets/appBar.dart';
import 'package:flutter/material.dart';

class RecipeDetection extends StatefulWidget {
  const RecipeDetection({super.key});

  @override
  State<RecipeDetection> createState() => _RecipeDetectionState();
}

class _RecipeDetectionState extends State<RecipeDetection> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(text: "Recipe Recommendation"),
    );
  }
}
