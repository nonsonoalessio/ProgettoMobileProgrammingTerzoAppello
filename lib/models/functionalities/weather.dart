import 'package:progetto_mobile_programming/models/functionalities/automation.dart';

class Weather {
  final String location;
  final double temp;
  final WeatherCondition condition;

  const Weather({
    required this.location,
    required this.temp,
    required this.condition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      location: json['name'],
      temp: json['main']['temp'].toDouble(),
      condition: WeatherCondition.sunny,
      // mainCondition: json['weather'][0]['main'],
    );
  }
}
