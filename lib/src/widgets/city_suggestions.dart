import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class CityChips extends StatefulWidget {
  final Function(String) onCitySelected;

  const CityChips({
    super.key,
    required this.onCitySelected,
  });

  @override
  State<CityChips> createState() => _CityChipsState();
}

class _CityChipsState extends State<CityChips> {
  int _selectedIndex = -1;
  static const List<Map<String, dynamic>> cities = [
    {'name': 'Mumbai', 'emoji': '🌊', 'query': 'Mumbai', 'color': Color(0xFF039BE5)},
    {'name': 'Delhi', 'emoji': '🏛️', 'query': 'Delhi', 'color': Color(0xFF1976D2)},
    {'name': 'Bangalore', 'emoji': '🌳', 'query': 'Bangalore', 'color': Color(0xFF43A047)},
    {'name': 'Hyderabad', 'emoji': '🍗', 'query': 'Hyderabad', 'color': Color(0xFF7B1FA2)},
    {'name': 'Chennai', 'emoji': '🌊', 'query': 'Chennai', 'color': Color(0xFF0288D1)},
    {'name': 'Kolkata', 'emoji': '🌉', 'query': 'Kolkata', 'color': Color(0xFF689F38)},
    {'name': 'Jaipur', 'emoji': '🏰', 'query': 'Jaipur', 'color': Color(0xFFEF6C00)},
    {'name': 'Pune', 'emoji': '🎓', 'query': 'Pune', 'color': Color(0xFF0097A7)},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(
                Icons.location_city,
                color: AppTheme.accentLight,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Popular Cities',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        
        isDesktop ? _buildCityGrid() : _buildCityList(),
      ],
    );
  }
  
  Widget _buildCityGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: cities.length,
      itemBuilder: (context, index) {
        final city = cities[index];
        final isSelected = index == _selectedIndex;
     
        return _buildCityCard(city, isSelected, index);
      },
    );
  }
  
  Widget _buildCityList() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final city = cities[index];
          final isSelected = index == _selectedIndex;
          
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _buildCityCard(city, isSelected, index),
          );
        },
      ),
    );
  }
  
  Widget _buildCityCard(Map<String, dynamic> city, bool isSelected, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        widget.onCitySelected(city['query']);
        HapticFeedback.selectionClick();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 90,
        decoration: BoxDecoration(
          color: isSelected ? city['color'] : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected ? [
            BoxShadow(
              color: city['color'].withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ] : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.3) : Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  city['emoji'],
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                city['name'],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 