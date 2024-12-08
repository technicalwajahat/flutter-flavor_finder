import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../viewModel/product_viewmodel.dart';
import '../../widgets/appBar.dart';

class WeatherDetection extends StatefulWidget {
  const WeatherDetection({super.key});

  @override
  State<WeatherDetection> createState() => _WeatherDetectionState();
}

class _WeatherDetectionState extends State<WeatherDetection> {
  final ProductViewModel _productViewModel = Get.put(ProductViewModel());
  Position? _currentPosition;
  String _temperature = '';
  String _message = '';

  @override
  void initState() {
    super.initState();
    _getLocation().then((value) {
      _getWeather();
    });
  }

  Future<bool> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<void> _getLocation() async {
    bool hasPermission = await _requestLocationPermission();
    if (!hasPermission) {
      return;
    }

    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = currentPosition;
    });
  }

  Future<void> _getWeather() async {
    if (_currentPosition == null) {
      return;
    }

    const apiKey = '';
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=31.520370&lon=74.358749&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final weatherData = jsonDecode(response.body);
      final temp = weatherData['main']['temp'] as double;
      setState(() {
        _temperature = temp.toStringAsFixed(1);
        if (temp < 15) {
          _message = 'cold';
        } else if (temp >= 15 && temp < 23) {
          _message = 'rainy';
        } else if (temp >= 23 && temp < 30) {
          _message = 'sunny';
        } else {
          _message = "hot";
        }
      });
    } else {
      setState(() {
        _message = 'Error fetching weather data.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(text: "Weather Detection"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_temperature.isEmpty)
                const Text(
                  'Loading Temperature ...',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              if (_temperature.isNotEmpty)
                Text(
                  'Temperature: $_temperature °C',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22),
                ),
              SizedBox(height: Get.height * 0.01),
              if (_message.isNotEmpty)
                Text(
                  _message.toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              SizedBox(height: Get.height * 0.025),
              if (_message.isNotEmpty)
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    _productViewModel.fetchWeatherRecipes(_message);
                  },
                  child: const Text(
                    'Get Weather Recipes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
