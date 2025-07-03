# Weather App

A modern Flutter weather application that allows users to search for cities worldwide and view their current weather conditions using the OpenWeatherMap API. The app features a responsive design with dynamic backgrounds that change based on weather conditions and time of day.

## Features

- **City Search**: Search for any city globally to get current weather information
- **Dynamic UI**: Background gradients change based on weather conditions and time of day
- **Weather Details**: View temperature, weather conditions, humidity, wind speed, and pressure
- **Recent Searches**: Automatically saves and displays your recent city searches
- **Pull-to-Refresh**: Easily update weather data with a pull-down gesture
- **Error Handling**: User-friendly error messages with retry options
- **Responsive Design**: Optimized for various screen sizes
- **Popular Cities**: Quick access to popular cities via pre-defined chips
- **Persistent Storage**: Remembers your last searched city between sessions
- **Multiple Locations**: Save and track weather for multiple cities simultaneously
- **Desktop View**: Optimized layout for larger screens with side-by-side design

## Design

View the app design in Figma:
[Weather App Design](https://www.figma.com/design/JSNOHmkDaL3I6OzARvKxW3/Untitled?node-id=0-1&t=MJrz8xYZJeVzAgBC-1)

## Screenshots
![App Screenshot](assets/screenshots/Screenshot%202025-07-03 222451.png)
![App Screenshot](assets/screenshots/Screenshot%202025-07-03 222530.png)



## Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/weather_app.git
   cd weather_app
   ```

2. Get an API key from [OpenWeatherMap](https://openweathermap.org/api)

3. Create a `.env` file in the root directory with the following content:
   ```
   OPENWEATHER_API_KEY=your_api_key_here
   ```
   Replace `your_api_key_here` with your actual OpenWeatherMap API key

4. Install dependencies:
   ```bash
   flutter pub get
   ```

5. Run the app:
   ```bash
   flutter run
   ```

## Dependencies

- **Flutter SDK**: Framework for building cross-platform applications
- **http**: ^1.2.1 - For making API requests to OpenWeatherMap
- **shared_preferences**: ^2.2.2 - For storing recent searches and app preferences
- **flutter_dotenv**: ^5.1.0 - For managing environment variables and API keys
- **google_fonts**: ^6.1.0 - For custom typography
- **cupertino_icons**: ^1.0.8 - For iOS style icons

## Project Structure

```
lib/
  ├── main.dart                  # App entry point
  └── src/
      ├── config/
      │   └── env_config.dart    # Environment configuration
      ├── models/
      │   └── weather_model.dart # Weather data model
      ├── screens/
      │   └── home_screen.dart   # Main screen
      ├── services/
      │   └── weather_service.dart # API service
      ├── theme/
      │   └── app_theme.dart     # App theming
      └── widgets/
          ├── city_suggestions.dart # Popular cities widget
          └── weather_card.dart     # Weather display widget
```

## API Usage

This app uses the OpenWeatherMap API to fetch weather data. The free tier allows up to 1,000 API calls per day, which is sufficient for personal and testing purposes.

## Security Notes

- The `.env` file is included in `.gitignore` to prevent accidentally committing sensitive information
- Never commit your API keys to version control
- For production deployments, use appropriate secret management solutions

## Performance Optimizations

- Minimized network requests using local storage
- Optimized image loading with error handling
- Efficient UI rendering with proper widget hierarchy

## Future Enhancements

- Weather forecasts for upcoming days
- Location-based weather detection
- Weather alerts and notifications
- More detailed weather information
- Weather maps and radar
- Multiple city management

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- [OpenWeatherMap](https://openweathermap.org/) for providing the weather data API
- [Flutter](https://flutter.dev/) for the amazing framework
- Icons and design inspiration from various sources