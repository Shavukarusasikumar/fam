# Contextual Cards App

This project is a Flutter-based application that dynamically displays contextual cards. The design and functionality adhere to the requirements provided in the assignment, ensuring modularity, reusability, and a user-friendly interface.

## 🚀 Features

- **Dynamic Card Rendering**: Renders cards dynamically based on the API response, supporting multiple card types like HC1, HC3, HC5, HC6, and HC9.
- **Swipe to Refresh**: Implements a pull-to-refresh mechanism for updating content.
- **Card Interactions**:
  - Long press on HC3 cards to reveal "Remind Later" and "Dismiss Now" actions.
  - "Remind Later" retains the card for the next session.
  - "Dismiss Now" permanently removes the card.
- **Deep Link Handling**: Supports all deeplink actions, including buttons (CTAs) and clickable text entities.
- **Loading and Error States**: Gracefully handles loading states with shimmer effects and displays error messages when needed.
- **Reusable Components**: Built with modular, reusable components for seamless integration across screens.

## 🛠️ Tech Stack

- **Framework**: Flutter
- **State Management**: Flutter Bloc
- **Data Storage**: Shared Preferences
- **Networking**: HTTP Client
- **Animations**: Shimmer Effects
- **Utilities**: URL Launcher
- **Version**: 3.24.3


## 🧰 Installation & Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/Shavukarusasikumar/fam.git
   cd contextual-cards-app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## 📦 Folder Structure

```
lib/
├── core/
│   └── constants/
│       └── api_constants.dart         # API endpoint constants
├── data/
│   ├── models/
│   │   ├── card_cta.dart              # Call-to-action model
│   │   ├── card_group.dart            # Group model for cards
│   │   └── card_item.dart             # Card item model
│   └── repositories/
│       ├── card_repository.dart       # Repository interface
│       └── card_repository_impl.dart  # Repository implementation
├── domain/
│   └── entities/
│       └── formatted_text_entity.dart # Formatted text entity
├── presentation/
│   ├── bloc/card/                     # Bloc for card-related state management
│   │   ├── card_bloc.dart
│   │   ├── card_event.dart
│   │   └── card_state.dart
│   ├── screens/home/                  # Home screen implementation
│   │   ├── home_screen.dart
│   │   └── widgets/
│   │       ├── big_display_card.dart
│   │       ├── card_group_widget.dart
│   │       ├── dynamic_width_card.dart
│   │       ├── image_card.dart
│   │       ├── small_card_with_arrow.dart
│   │       └── small_display_card.dart
│   └── widgets/                       # Reusable widgets
│       ├── formatted_text.dart
│       └── loading_shimmer.dart
├── app.dart                           # App initialization and routing
└── main.dart                          # Entry point of the application

```

## 🎨 Design Reference

The UI design adheres closely to the specifications outlined in the Figma design:
[Design Specifications](https://www.figma.com/file/AvK2BRGwMTv4kQab5ymJ0K/AAL3-Android-assignment-Design-Specs)

## 📜 Assignment Details

The full details of the internship assignment, API schema, and design requirements are documented [here](https://fampay.notion.site/Flutter-Assignment-14ca06dce86080c4a7c8e8e2f2d911d0).

## 📂 Deliverables

1. **APK**: The Android APK is available in the `build/outputs/apk/` folder.
2. **Recordings**: Demonstration recordings for iOS and Android are provided in the repository.
3. **Git Commit Messages**: Clear and concise commit messages for better readability.
4. **Code Comments**: Inline comments explaining complex logic.

## 🤝 Contribution

Feel free to fork the repository, make enhancements, and submit a pull request.

## 📧 Contact

For queries regarding the submission, contact:
- **Email**: [shavukarusasikumar@gmail.com](mailto:shavukarusasikumar@gmail.com)

---