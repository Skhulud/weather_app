import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:real_time_weather_ap/models/weather_json_data.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({required this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Weather weather;
  late String selectedCity;

  @override
  void initState() {
    super.initState();
    selectedCity = '';

    getData(); // Fetch weather data when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              if (weather == null) // Check if weather is null
                Center(child: CircularProgressIndicator()) // Display a loading indicator
              else
              // Your existing code here
              // You can use weather!.weatherData to access the weather data
                Container(
                  height: size.height * 0.75,
                  width: size.width,
                  margin: EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff955cd1),
                        Color(0xff3fa2fa),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.2, 0.85],
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xff3fa2fa),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButton<String>(
                            value: selectedCity,
                            items: weather.weatherData.map((data) {
                              return DropdownMenuItem<String>(
                                value: data.city,
                                child: Text(data.city),
                                onTap: () {
                                  setState(() {
                                    selectedCity = data.city;
                                  });
                                },
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedCity = value!;
                              });
                            },
                            hint: Text('Select a city'),
                            style: TextStyle(color: Colors.purple),
                            icon: Icon(Icons.location_on_outlined),
                            iconSize: 36,
                            elevation: 16,
                            underline: SizedBox(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          child: Column(
                            children: [
                              Text(
                                '${selectedCity.isNotEmpty ? weather.weatherData.firstWhere((element) => element.city == selectedCity).forecast[0].temperature.max : ''}°C',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 55,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(selectedCity.isNotEmpty
                                  ? weather.weatherData.firstWhere((element) => element.city == selectedCity).forecast[0].weatherDescription
                                  : ''),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: weather.weatherData.length,
                          itemBuilder: (context, index) {
                            if (weather.weatherData[index].city == selectedCity) {
                              String animationLink = getAnimationLink(weather.weatherData[index].forecast[0].weatherDescription);
                              return Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.network(
                                      animationLink,
                                      width: size.width * 0.3,
                                      height: size.width * 0.3,
                                      fit: BoxFit.contain,
                                    ),
                                    ListTile(
                                      title: Center(
                                        child: Text(
                                          '${selectedCity.isNotEmpty ? DateFormat('MM/dd/yyy').format(DateTime.parse(weather.weatherData.firstWhere((element) => element.city == selectedCity).forecast[0].date.toString())).toString() : ''}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          //  Text('Min Temperature: ${weather.weatherData[index].forecast[0].temperature.min}°C',),
                                          // Text('Max Temperature: ${weather.weatherData[index].forecast[0].temperature.max}°C'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Next 7 Days",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.2, color: Colors.black54),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                '${selectedCity.isNotEmpty ? weather.weatherData.firstWhere((element) => element.city == selectedCity).forecast[0].temperature.max : ''}°C',
                              ),
                              Image.asset('asset/snow.png',height: 10,width: 70,),
                              Text(
                                selectedCity.isNotEmpty
                                    ? DateFormat('MMMM dd').format(
                                  DateTime.parse(
                                    weather.weatherData
                                        .firstWhere((element) => element.city == selectedCity)
                                        .forecast[0]
                                        .date
                                        .toString(),
                                  ),
                                )
                                    : '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          Text(
                            '${selectedCity.isNotEmpty ? weather.weatherData.firstWhere((element) => element.city == selectedCity).forecast[0].temperature.max : ''}°C',
                          ),
                          Image.asset('asset/snow.png',height: 10,width: 70,),
                          Text(
                            selectedCity.isNotEmpty
                                ? DateFormat('MMMM dd').format(
                              DateTime.parse(
                                weather.weatherData
                                    .firstWhere((element) => element.city == selectedCity)
                                    .forecast[0]
                                    .date
                                    .toString(),
                              ),
                            )
                                : '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${selectedCity.isNotEmpty ? weather.weatherData.firstWhere((element) => element.city == selectedCity).forecast[0].temperature.max : ''}°C',
                          ),
                          Image.asset('asset/snow.png',height: 10,width: 70,),
                          Text(
                            selectedCity.isNotEmpty
                                ? DateFormat('MMMM dd').format(
                              DateTime.parse(
                                weather.weatherData
                                    .firstWhere((element) => element.city == selectedCity)
                                    .forecast[0]
                                    .date
                                    .toString(),
                              ),
                            )
                                : '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${selectedCity.isNotEmpty ? weather.weatherData.firstWhere((element) => element.city == selectedCity).forecast[0].temperature.max : ''}°C',
                          ),
                          Image.asset('asset/snow.png',height: 10,width: 70,),
                          Text(
                            selectedCity.isNotEmpty
                                ? DateFormat('MMMM dd').format(
                              DateTime.parse(
                                weather.weatherData
                                    .firstWhere((element) => element.city == selectedCity)
                                    .forecast[0]
                                    .date
                                    .toString(),
                              ),
                            )
                                : '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${selectedCity.isNotEmpty ? weather.weatherData.firstWhere((element) => element.city == selectedCity).forecast[0].temperature.max : ''}°C',
                          ),
                          Image.asset('asset/snow.png',height: 10,width: 70,),
                          Text(
                            selectedCity.isNotEmpty
                                ? DateFormat('MMMM dd').format(
                              DateTime.parse(
                                weather.weatherData
                                    .firstWhere((element) => element.city == selectedCity)
                                    .forecast[0]
                                    .date
                                    .toString(),
                              ),
                            )
                                : '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${selectedCity.isNotEmpty ? weather.weatherData.firstWhere((element) => element.city == selectedCity).forecast[0].temperature.max : ''}°C',
                          ),
                          Image.asset('asset/snow.png',height: 10,width: 70,),
                          Text(
                            selectedCity.isNotEmpty
                                ? DateFormat('MMMM dd').format(
                              DateTime.parse(
                                weather.weatherData
                                    .firstWhere((element) => element.city == selectedCity)
                                    .forecast[0]
                                    .date
                                    .toString(),
                              ),
                            )
                                : '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getData() async {
    try {
      final response = await http.get(Uri.parse('https://run.mocky.io/v3/135c4f69-522f-40e4-9e75-a65f99ee69cc'));
      if (response.statusCode == 200) {
        setState(() {
          weather = weatherFromJson(response.body);
          selectedCity = weather.weatherData.isNotEmpty ? weather.weatherData[0].city : '';
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }

  String getAnimationLink(String weatherDescription) {
    switch (weatherDescription.toLowerCase()) {
    case 'sunny':
    return 'https://lottie.host/b2e9bd14-743c-4a44-ab53-23d6e22fcc4e/Y3ulyMVjK2.json';
    case 'cloudy':
    return 'https://lottie.host/9786a217-da61-4717-8a7f-2bea3945a9a8/rjNTaWniQK.json';
    case 'thunderstorm':
    return 'https://lottie.host/e0b5693b-2350-4655-a366-8a89ab0de043/sefgeAbyvM.json';
    case 'rainy':
    return 'https://lottie.host/ded925d2-0410-4db0-b7b9-7d3f3e43c5eb/24JYNQTeey.json';
    default:
    return'';
    }
    }
}