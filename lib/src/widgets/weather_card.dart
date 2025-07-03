import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final bool isNight;
  final bool isCompact;

  const WeatherCard({
    super.key, 
    required this.weather,
    this.isNight = false,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final cardWidth = size.width;
    final iconSize = isCompact ? size.width * 0.10 : size.width * 0.25;
    LinearGradient cardGradient;
    IconData weatherIcon;
    
    final cond = weather.cond.toLowerCase();
    if (cond.contains('rain') || cond.contains('drizzle')) {
      cardGradient = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF546E7A), // Blue Grey 600
          Color(0xFF78909C), // Blue Grey 400
        ],
      );
      weatherIcon = Icons.grain;
    } else if (cond.contains('thunderstorm')) {
      cardGradient = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF455A64), // Blue Grey 700
          Color(0xFF546E7A), // Blue Grey 600
        ],
      );
      weatherIcon = Icons.flash_on;
    } else if (cond.contains('snow')) {
      cardGradient = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF90A4AE), // Blue Grey 300
          Color(0xFFB0BEC5), // Blue Grey 200
        ],
      );
      weatherIcon = Icons.ac_unit;
    } else if (cond.contains('cloud') || cond.contains('mist') || cond.contains('fog')) {
      cardGradient = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF42A5F5), // Blue 400
          Color(0xFF64B5F6), // Blue 300
        ],
      );
      weatherIcon = Icons.cloud;
    } else {
      if (isNight) {
        cardGradient = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A237E), // Indigo 900
            Color(0xFF283593), // Indigo 800
          ],
        );
        weatherIcon = Icons.nightlight_round;
      } else {
        cardGradient = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF039BE5), // Light Blue 600
            Color(0xFF29B6F6), // Light Blue 400
          ],
        );
        weatherIcon = Icons.wb_sunny;
      }
    }
    
    return SizedBox(
      width: cardWidth,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: cardGradient,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: isCompact ? _buildCompactLayout(context, theme, weatherIcon, iconSize) : _buildFullLayout(context, theme, weatherIcon, iconSize, size),
        ),
      ),
    );
  }
  
  Widget _buildCompactLayout(BuildContext context, ThemeData theme, IconData weatherIcon, double iconSize) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            weather.city,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: iconSize,
                width: iconSize,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(iconSize / 2),
                ),
                child: Image.network(
                  'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Error loading weather icon: $error');
                    return Icon(
                      weatherIcon,
                      size: iconSize * 0.8,
                      color: Colors.white70,
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / 
                              (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                        color: Colors.white70,
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(width: 12),
              Text(
                '${weather.temp.toStringAsFixed(1)}°C',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              weather.cond,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFullLayout(BuildContext context, ThemeData theme, IconData weatherIcon, double iconSize, Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.02,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  weather.city,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          Container(
            height: iconSize,
            width: iconSize,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(iconSize / 2),
            ),
            child: Image.network(
              'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Error loading weather icon: $error');
                return Icon(
                  weatherIcon,
                  size: iconSize * 0.8,
                  color: Colors.white70,
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / 
                          (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                    color: Colors.white70,
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 20),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: weather.temp),
            duration: const Duration(milliseconds: 1000),
            builder: (context, value, _) {
              return Text(
                '${value.toStringAsFixed(1)}°C',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.5,
                  fontSize: 48,
                ),
              );
            },
          ),
          
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              weather.cond,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildWeatherDetail(
                Icons.water_drop,
                'Humidity',
                '${weather.hum}%',
              ),
              _buildWeatherDetail(
                Icons.air,
                'Wind',
                '${weather.wSp} m/s',
              ),
              _buildWeatherDetail(
                Icons.compress,
                'Pressure',
                '${weather.pa} hPa',
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildWeatherDetail(
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}