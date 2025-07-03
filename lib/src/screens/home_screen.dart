import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../widgets/weather_card.dart';
import '../widgets/city_suggestions.dart';
import '../config/env_config.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final WeatherService _weatherService;
  final _cityController = TextEditingController();
  WeatherModel? _weather;
  String? _error;
  bool _isLoading = false;
  bool _isNight = false;
  List<String> _recentCities = [];
  List<WeatherModel> _savedLocations = [];
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  bool _isLoadingSavedLocation = false;

  @override
  void initState() {
    super.initState();
    _weatherService = WeatherService(apiKey: EnvConfig.openWeatherApiKey);
    
    final hour = DateTime.now().hour;
    _isNight = hour < 6 || hour > 18;
    
    _loadRecentCities();
    _loadSavedLocations();
  }
  
  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
  
  Future<void> _loadRecentCities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _recentCities = prefs.getStringList('recentCities') ?? [];
      });
      
      final lastCity = prefs.getString('lastCity');
      if (lastCity != null && lastCity.isNotEmpty) {
        _cityController.text = lastCity;
        _getWeather(lastCity);
      }
    } catch (e) {

      debugPrint('Error loading preferences: $e');
    }
  }
  
  Future<void> _loadSavedLocations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCities = prefs.getStringList('savedLocations') ?? [];
      
      if (savedCities.isNotEmpty) {
        setState(() {
          _isLoadingSavedLocation = true;
        });
        
        List<WeatherModel> locations = [];
        for (final city in savedCities) {
          try {
            final weather = await _weatherService.getWeather(city);
            locations.add(weather);
          } catch (e) {
            debugPrint('Error loading weather for $city: $e');
          }
        }
        
        setState(() {
          _savedLocations = locations;
          _isLoadingSavedLocation = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading saved locations: $e');
      setState(() {
        _isLoadingSavedLocation = false;
      });
    }
  }
  
  Future<void> _saveLocation(WeatherModel weather) async {
    if (_savedLocations.any((loc) => loc.cityName == weather.cityName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${weather.cityName} is already saved')),
      );
      return;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCities = prefs.getStringList('savedLocations') ?? [];
      
      if (!savedCities.contains(weather.cityName)) {
        savedCities.add(weather.cityName);
        await prefs.setStringList('savedLocations', savedCities);
        
        setState(() {
          _savedLocations.add(weather);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${weather.cityName} added to saved locations')),
        );
      }
    } catch (e) {
      debugPrint('Error saving location: $e');
    }
  }
  
  Future<void> _removeLocation(WeatherModel weather) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCities = prefs.getStringList('savedLocations') ?? [];
      
      savedCities.remove(weather.cityName);
      await prefs.setStringList('savedLocations', savedCities);
      
      setState(() {
        _savedLocations.removeWhere((loc) => loc.cityName == weather.cityName);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${weather.cityName} removed from saved locations')),
      );
    } catch (e) {
      debugPrint('Error removing location: $e');
    }
  }
  
  Future<void> _saveRecentCity(String city) async {
    if (city.isEmpty) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      

      await prefs.setString('lastCity', city);
      

      if (!_recentCities.contains(city)) {
        _recentCities.insert(0, city);
        if (_recentCities.length > 5) {
          _recentCities = _recentCities.sublist(0, 5);
        }
        await prefs.setStringList('recentCities', _recentCities);
        setState(() {});
      }
    } catch (e) {

      debugPrint('Error saving recent city: $e');
      if (!_recentCities.contains(city)) {
        setState(() {
          _recentCities.insert(0, city);
          if (_recentCities.length > 5) {
            _recentCities = _recentCities.sublist(0, 5);
          }
        });
      }
    }
  }

  Future<void> _getWeather(String city) async {
    if (city.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final weather = await _weatherService.getWeather(city);
      setState(() {
        _weather = weather;
        _error = null;
      });
      _saveRecentCity(city);
    } catch (e) {
      setState(() {
        _error = 'City not found. Please try again.';
        _weather = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _refreshWeather() async {
    if (_cityController.text.isNotEmpty) {
      await _getWeather(_cityController.text);
    }
    
    await _loadSavedLocations();
  }

  void _onCitySelected(String city) {
    _cityController.text = city;
    _getWeather(city);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;
    LinearGradient backgroundGradient;
    if (_weather != null) {
      final condition = _weather!.condition.toLowerCase();
      if (condition.contains('rain') || condition.contains('drizzle') || condition.contains('thunderstorm')) {
        backgroundGradient = AppTheme.rainyGradient;
      } else if (condition.contains('cloud') || condition.contains('mist') || condition.contains('fog')) {
        backgroundGradient = AppTheme.cloudyGradient;
      } else {
        backgroundGradient = _isNight ? AppTheme.clearNightGradient : AppTheme.clearDayGradient;
      }
    } else {
      backgroundGradient = _isNight ? AppTheme.clearNightGradient : AppTheme.clearDayGradient;
    }
    
    final accentColor = AppTheme.accentLight;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: SafeArea(
          child: RefreshIndicator(
            key: _refreshKey,
            onRefresh: _refreshWeather,
            color: accentColor,
            child: isDesktop ? _buildDesktopLayout(size) : _buildMobileLayout(size),
          ),
        ),
      ),
    );
  }
  
  Widget _buildDesktopLayout(Size size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 30),
                      _buildSearchBar(),
                      const SizedBox(height: 24),
                      _buildRecentSearches(),
                      const SizedBox(height: 24),
                      CityChips(onCitySelected: _onCitySelected),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          flex: 7,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Weather Information',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_weather != null)
                            ElevatedButton.icon(
                              onPressed: () => _saveLocation(_weather!),
                              icon: const Icon(Icons.add_location),
                              label: const Text('Save Location'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentLight,
                                foregroundColor: Colors.black87,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildWeatherContent(),
                      const SizedBox(height: 30),
                      if (_savedLocations.isNotEmpty || _isLoadingSavedLocation) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Saved Locations',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh, color: Colors.white),
                              onPressed: _loadSavedLocations,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _isLoadingSavedLocation
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                              )
                            : _buildSavedLocationsGrid(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildMobileLayout(Size size) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 20),
                _buildSearchBar(),
                const SizedBox(height: 20),
                _buildRecentSearches(),
                const SizedBox(height: 20),
                CityChips(onCitySelected: _onCitySelected),
                const SizedBox(height: 30),
                _buildWeatherContent(),
                if (_weather != null) ...[
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => _saveLocation(_weather!),
                      icon: const Icon(Icons.add_location),
                      label: const Text('Save Location'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentLight,
                        foregroundColor: Colors.black87,
                      ),
                    ),
                  ),
                ],
                if (_savedLocations.isNotEmpty || _isLoadingSavedLocation) ...[
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Saved Locations',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: _loadSavedLocations,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _isLoadingSavedLocation
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      : _buildSavedLocationsList(),
                ],
                SizedBox(height: size.height * 0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSavedLocationsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _savedLocations.length,
      itemBuilder: (context, index) {
        final weather = _savedLocations[index];
        return Stack(
          children: [
            WeatherCard(
              weather: weather,
              isNight: _isNight,
              isCompact: true,
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => _removeLocation(weather),
              ),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildSavedLocationsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _savedLocations.length,
      itemBuilder: (context, index) {
        final weather = _savedLocations[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Stack(
            children: [
              WeatherCard(
                weather: weather,
                isNight: _isNight,
                isCompact: true,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => _removeLocation(weather),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    final accentColor = AppTheme.accentLight;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              _isNight ? Icons.nightlight_round : Icons.wb_sunny,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 10),
            Text(
              'Weather App',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          color: Colors.white,
          onPressed: () {
            _refreshKey.currentState?.show();
          },
        ),
      ],
    );
  }
  
  Widget _buildRecentSearches() {
    if (_recentCities.isEmpty) return const SizedBox.shrink();
    
    final accentColor = AppTheme.accentLight;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              Icon(
                Icons.history,
                color: accentColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Recent Searches',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _recentCities.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  backgroundColor: Colors.black.withOpacity(0.3),
                  label: Text(
                    _recentCities[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => _onCitySelected(_recentCities[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                hintText: 'Enter city name',
                border: InputBorder.none,
                icon: Icon(Icons.location_city),
              ),
              onSubmitted: (value) => _getWeather(value),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _getWeather(_cityController.text),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherContent() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    if (_error != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.redAccent,
              size: 60,
            ),
            const SizedBox(height: 20),
            Text(
              _error!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _cityController.text.isNotEmpty 
                ? _getWeather(_cityController.text)
                : null,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentLight,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_weather == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isNight ? Icons.nightlight_round : Icons.wb_sunny_outlined,
              size: 80,
              color: Colors.white54,
            ),
            const SizedBox(height: 16),
            Text(
              'Enter a city name to get weather information',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return WeatherCard(
      weather: _weather!, 
      isNight: _isNight,
      isCompact: false,
    );
  }
}