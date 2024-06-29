import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FilledButton.icon(
                icon: const Icon(Icons.fastfood_rounded, size: 22.0),
                label: const Text('Recipe Detection'),
                onPressed: () {
                  Get.toNamed("/recipeDetection");
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: Get.height * 0.01),
              FilledButton.icon(
                icon: const Icon(Icons.cloud, size: 22.0),
                label: const Text('Weather Detection'),
                onPressed: () {
                  Get.toNamed("/weatherDetection");
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
