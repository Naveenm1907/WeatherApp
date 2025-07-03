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
    return WeatherModel(
      weat: json['weather']?[0]['description'],
      main: json['main']?['temp'].toDouble(),
      cond: json['weather']?[0]['main'],
      icon: json['weather']?[0]['icon'],
      temp: json['main']?['temp'].toDouble(),
      hum: json['main']?['humidity'],
      wSp: json['wind']?['speed'].toDouble(),
      pa: json['main']?['pressure'],
      city: json['name'],
    );
  }
}