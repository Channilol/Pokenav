# Pokenav

A modern and sleek Pokémon navigation app that brings the entire Pokédex universe to your fingertips with cutting-edge design and performance.

## 🚀 Overview

Pokenav is a vertical mobile/tablet application designed to provide an immersive browsing experience through all existing Pokémon generations. Built with performance in mind, it leverages stream-based API calls with intelligent auto-caching to deliver real-time data loading updates while efficiently managing the massive amount of Pokémon information.

## ✨ Features

- **Stream-Based Data Loading**: Real-time updates on data fetching progress with smooth, responsive UI
- **Intelligent Auto-Caching**: Automatic caching system to minimize API calls and preserve valuable resources
- **Modern Pokédex Design**: Innovative vertical split-screen interface inspired by classic Pokédex devices
- **Comprehensive Coverage**: Access to all Pokémon generations with complete data sets
- **Optimized Performance**: Built for both mobile and tablet devices with fluid animations and transitions

## 🛠️ Technologies

- **Framework**: Flutter & Dart
- **State Management**: Flutter Riverpod for global state management
- **Local Storage**: shared_preferences 2.5.3
- **API**: [PokéAPI](https://pokeapi.co) - RESTful Pokémon API
- **Architecture**: Stream-based reactive programming with automatic caching layer

## 📱 Design

The app features a unique vertical layout divided into two main sections:

- **Upper Section**: Interactive scroll wheel displaying Pokémon sprites and numbers with center-focused selection
- **Lower Section**: Detailed information panel that dynamically updates based on the selected Pokémon

## 🚧 Development Status

**Work in Progress**

- ✅ Stream-based API implementation - **Completed & Tested**
- 🔄 Auto-caching system - **Currently in Development**
- ⏳ UI/UX refinements - **Upcoming**
- ⏳ Additional features - **Planned**

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.4.0
  flutter_riverpod: ^3.0.0-dev.16
  riverpod_annotation: ^3.0.0-dev.16
  async_wrapper: ^1.0.0
  cupertino_icons: ^1.0.8
  # Additional dependencies to be added as development progresses
```

## 🔗 API Documentation

This project uses the PokéAPI v2. For detailed API documentation, visit: [https://pokeapi.co/docs/v2](https://pokeapi.co/docs/v2)

## 📄 License

[License information to be added]

## 🤝 Contributing

[Contributing guidelines to be added]

---

*Stay tuned for updates as we continue to evolve Pokenav into the ultimate Pokémon companion app!*
