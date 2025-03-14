import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/common/const.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;

  @override
  void initState() {
    _wf.currentWeatherByCityName("London").then((weather) {
      setState(() {
        _weather = weather;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime? now = _weather!.date;
    return Scaffold(
      body:
          _weather == null
              ? Center(child: CircularProgressIndicator())
              : SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "City: ${_weather!.areaName}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.08),
                    Column(
                      children: [
                        Text(
                          DateFormat("h:mm a").format(now!),
                          style: TextStyle(fontSize: 35),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              DateFormat("EEEE").format(now),
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              DateFormat(", d MMMM y").format(now),
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text("Temperature: ${_weather!.temperature?.celsius}"),
                    Text("Weather: ${_weather!.weatherMain}"),
                  ],
                ),
              ),
    );
  }
}
