class WeatherModel {
  final String weat;
  final String main;
  final String cond;
  final String icon;
  final double temp;
  final int hum;
  final double wSp;
  final int pa;
  final String city;

  WeatherModel({
    required this.weat,
    required this.main,
    required this.cond,
    required this.icon,
    required this.temp,
    required this.hum,
    required this.wSp,
    required this.pa,
    required this.city,
  });
  
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'] as List;
    final weatherData = weather.isNotEmpty ? weather[0] as Map<String, dynamic> : {};
    final mainData = json['main'] as Map<String, dynamic>? ?? {};
    final windData = json['wind'] as Map<String, dynamic>? ?? {};
    
    return WeatherModel(
      weat: weatherData['description']?.toString() ?? '',
      main: mainData['temp']?.toString() ?? '0',
      cond: weatherData['main']?.toString() ?? '',
      icon: weatherData['icon']?.toString() ?? '01d',
      temp: (mainData['temp'] != null) ? double.parse(mainData['temp'].toString()) : 0.0,
      hum: (mainData['humidity'] != null) ? int.parse(mainData['humidity'].toString()) : 0,
      wSp: (windData['speed'] != null) ? double.parse(windData['speed'].toString()) : 0.0,
      pa: (mainData['pressure'] != null) ? int.parse(mainData['pressure'].toString()) : 0,
      city: json['name']?.toString() ?? 'Unknown',
    );
  }
}