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

  void _getWeather(String city) {
    _wf.currentWeatherByCityName(city).then((weather) {
      setState(() {
        _weather = weather;
      });
    });
  }

  void _showDialog() {
    String? city;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter a city name"),
          content: TextField(
            onChanged: (value) {
              city = value;
            },
            onSubmitted: (value) {
              setState(() {
                city = value;
                _getWeather(value);
              });
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (city != null && city!.isNotEmpty) {
                  _getWeather(city!);
                }
                Navigator.pop(context);
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

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
                      " ${_weather!.areaName}",
                      style: TextStyle(
                        fontSize: 25,
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
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.5,
                          height: MediaQuery.sizeOf(context).height * 0.2,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
                              ),
                            ),
                          ),
                        ),
                        Text(
                          _weather?.weatherDescription ?? "",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
                    Text(
                      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C",
                      style: TextStyle(fontSize: 50),
                    ),
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          children: [
                            Text("Wind", style: TextStyle(fontSize: 20)),
                            Text(
                              "${_weather?.windSpeed?.toStringAsFixed(1)} m/s",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        SizedBox(width: MediaQuery.sizeOf(context).width * 0.1),
                        Column(
                          children: [
                            Text("Humidity", style: TextStyle(fontSize: 20)),
                            Text(
                              "${_weather?.humidity?.toString()}%",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        child: Icon(Icons.find_in_page),
      ),
    );
  }
}
