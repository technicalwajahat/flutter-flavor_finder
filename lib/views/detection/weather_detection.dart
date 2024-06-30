import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../../widgets/appBar.dart';

class WeatherDetection extends StatefulWidget {
  const WeatherDetection({super.key});

  @override
  State<WeatherDetection> createState() => _WeatherDetectionState();
}

class _WeatherDetectionState extends State<WeatherDetection> {
  Position? _currentPosition;
  String _temperature = '';
  String _message = '';

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

    const apiKey = '8b90f023a818698c184bdd1f70e76ec3';
    final url = Uri.parse(
        'https://api.openweathermap.org/data/3.0/onecall?lat=${_currentPosition!.latitude}&lon=${_currentPosition!.longitude}&appid=$apiKey');
    final response = await http.get(url);

    print(response.statusCode);

    if (response.statusCode == 200) {
      final weatherData = jsonDecode(response.body);
      final temp = weatherData['main']['temp'] as double;
      setState(() {
        _temperature = temp.toStringAsFixed(1);

        if (temp < 20) {
          _message = 'Cold!';
        } else if (temp >= 20 && temp < 30) {
          _message = 'Normal weather.';
        } else {
          _message = 'Hot!';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _getLocation,
              child: const Text('Get Location'),
            ),
            if (_currentPosition != null)
              Text(
                  'Latitude: ${_currentPosition!.latitude.toStringAsFixed(2)}'),
            if (_currentPosition != null)
              Text(
                  'Longitude: ${_currentPosition!.longitude.toStringAsFixed(2)}'),
            ElevatedButton(
              onPressed: _getWeather,
              child: const Text('Get Weather'),
            ),
            if (_temperature.isNotEmpty) Text('Temperature: $_temperature °C'),
            if (_message.isNotEmpty) Text(_message),
          ],
        ),
      ),
    );
  }
}
