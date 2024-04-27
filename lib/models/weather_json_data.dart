// To parse this JSON data, do
//
//     final weather = weatherFromJson(jsonString);

import 'dart:convert';

Weather weatherFromJson(String str) => Weather.fromJson(json.decode(str));

String weatherToJson(Weather data) => json.encode(data.toJson());

class Weather {
  int status;
  List<WeatherDatum> weatherData;


  Weather({
    required this.status,
    required this.weatherData,

  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    status: json["status"],
    weatherData: List<WeatherDatum>.from(json["weather_data"].map((x) => WeatherDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "weather_data": List<dynamic>.from(weatherData.map((x) => x.toJson())),
  };

  static getSelectedCities() {}
}

class WeatherDatum {
  String city;
  List<Forecast> forecast;

  WeatherDatum({
    required this.city,
    required this.forecast,
  });

  factory WeatherDatum.fromJson(Map<String, dynamic> json) => WeatherDatum(
    city: json["city"],
    forecast: List<Forecast>.from(json["forecast"].map((x) => Forecast.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "city": city,
    "forecast": List<dynamic>.from(forecast.map((x) => x.toJson())),
  };
}

class Forecast {
  DateTime date;
  Temperature temperature;
  int humidity;
  String weatherDescription;
  int windSpeed;

  Forecast({
    required this.date,
    required this.temperature,
    required this.humidity,
    required this.weatherDescription,
    required this.windSpeed,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) => Forecast(
    date: DateTime.parse(json["date"]),
    temperature: Temperature.fromJson(json["temperature"]),
    humidity: json["humidity"],
    weatherDescription: json["weather_description"],
    windSpeed: json["wind_speed"],
  );

  Map<String, dynamic> toJson() => {
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "temperature": temperature.toJson(),
    "humidity": humidity,
    "weather_description": weatherDescription,
    "wind_speed": windSpeed,
  };
}

class Temperature {
  int min;
  int max;

  Temperature({
    required this.min,
    required this.max,
  });

  factory Temperature.fromJson(Map<String, dynamic> json) => Temperature(
    min: json["min"],
    max: json["max"],
  );

  Map<String, dynamic> toJson() => {
  "min": min,
  "max":max,
  };
}