import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

const String OPEN_WEATHER_API_KEY = '9c8f6cbd9e03dfa58aae73e87d71d392';

class WeatherDetails extends StatefulWidget {
  final String cityName;

  const WeatherDetails({required this.cityName, super.key});

  @override
  _WeatherDetailsState createState() => _WeatherDetailsState();
}

class _WeatherDetailsState extends State<WeatherDetails> {
  final WeatherFactory _wf = WeatherFactory(OPEN_WEATHER_API_KEY);
  Weather? _weather;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      Weather weather = await _wf.currentWeatherByCityName(widget.cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'No weather data available.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather in ${widget.cityName}'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchWeather,
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _errorMessage != null
            ? Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red),
        )
            : _buildWeatherBox(),
      ),
    );
  }

  Widget _buildWeatherBox() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'City: ${_weather!.areaName}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          Text(
            'Temperature: ${_weather!.temperature?.celsius?.toStringAsFixed(1)} °C',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          Text(
            'Condition: ${_weather!.weatherDescription}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          Image.network(
            'http://openweathermap.org/img/w/${_weather!.weatherIcon}.png',
            height: 50,
            width: 50,
          ),
          const SizedBox(height: 10),
          Text(
            'Humidity: ${_weather!.humidity}%',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          Text(
            'Wind Speed: ${_weather!.windSpeed} m/s',
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
