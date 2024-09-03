import 'package:flutter/material.dart';
import 'package:progetto_mobile_programming/models/functionalities/action.dart';

enum WeatherCondition { none, sunny, cloudy, rainy, hot, cold, snowy }

class Automation {
  String name;
  String executionTime;
  WeatherCondition? weather;
  Set<DeviceAction> actions;

  Automation(
      {required this.name,
      required this.executionTime,
      this.weather,
      required this.actions});

  /*
  factory Automation.fromMap(Map<String, dynamic> map) {
    WeatherCondition weatherCondition;
    if(map['weateher'] == "sunny"){
      weatherCondition = WeatherCondition.sunny;
    }
    else if(map['weather'] == "cloudy"){
      weatherCondition = WeatherCondition.cloudy;
    }
    else if(map['weather'] == "rainy"){
      weatherCondition = WeatherCondition.rainy;
    }
    else if(map['weather'] == "hot"){
      weatherCondition = WeatherCondition.hot;
    }
    else if(map['weather'] == "cold"){
      weatherCondition = WeatherCondition.cold;
    }
    else{
      weatherCondition = WeatherCondition.snowy;
    }

    return Automation(
      name: map['name'] as String,
      executionTime: map['executionTime'] as int,
      weather: weatherCondition,

    );
  }
  */

/*  
  @override
  Map<String, Object?> toMap() {
    return {'deviceName': deviceName, 'room': room, 'isActive': isActive};
  }
  */
}
