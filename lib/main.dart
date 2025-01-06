import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Weather'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  String city = 'Omsk';
  Map<String, dynamic> weatherData = {};
  bool loadingFlag = true;
  Future<void> _fetchWeatherInfo(String city) async {
    loadingFlag = true;
    Uri url = Uri.parse(
        'http://api.weatherapi.com/v1/current.json?key=44073bca73c849dea57100035250601&q=${city}&aqi=no');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(
        () {
          weatherData = json.decode(response.body);
          loadingFlag = false;
        },
      );
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  void initState() {
    _fetchWeatherInfo(city);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loadingFlag) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    var location = weatherData['location']['name'];
    final temp = weatherData['current']['temp_c'];
    final feelsLike = weatherData['current']['feelslike_c'];

    return Scaffold(
      appBar: AppBar(title: const Text('Погода')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 32,
              ),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Введите город',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  setState(() {
                    city = value;
                    _fetchWeatherInfo(city);
                  });
                },
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                location,
                style: const TextStyle(fontSize: 24),
              ),
              Text(
                '$temp˚C',
                style: const TextStyle(fontSize: 36),
              ),
              Text(
                'Чувствуется как $feelsLike˚C',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
