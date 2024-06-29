import 'package:flutter/material.dart';

import '../../widgets/appBar.dart';

class WeatherDetection extends StatefulWidget {
  const WeatherDetection({super.key});

  @override
  State<WeatherDetection> createState() => _WeatherDetectionState();
}

class _WeatherDetectionState extends State<WeatherDetection> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(text: "Weather Detection"),
    );
  }
}
