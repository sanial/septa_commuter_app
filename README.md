# septa_commuter_app

SEPTA Commuter App
This is a mobile application built using Flutter that shows train schedules and real-time data for various train routes.

## Features
- View train schedules for different routes
- Get real-time updates on train arrival and departure times
- Search for train routes and schedules
- Save favorite train routes for quick access

## Getting Started
- Clone this repository: git clone https://github.com/your-username/train-schedule-app.git
- Install Flutter and all required dependencies (see Flutter documentation for instructions)
- Run flutter run to start the app on your device or emulator

## API
This app uses the Train Schedule API to fetch train schedules and real-time data. You will need to obtain an API key from the API provider and include it in the lib/utils/api.dart file.

dart
Copy code
  class Api {
    static const String baseUrl = 'https://train-schedule-api.com';
    static const String apiKey = 'your-api-key-here';
  }

## Screenshots
Train Schedule App Screenshot 1

Train Schedule App Screenshot 2

## Contributing
If you find any issues or would like to contribute to this project, please feel free to submit a pull request or open an issue.

## License
This project is licensed under the MIT License - see the LICENSE file for details.


