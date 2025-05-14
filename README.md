# CareTrace - Medical Application

CareTrace is a modern medical application built with Flutter that helps healthcare providers and patients manage medical records, appointments, and healthcare information efficiently.

## Features

- User Authentication (Firebase Auth)
- Medical Records Management
- Appointment Scheduling
- Patient Information Management
- Cross-platform Support (iOS, Android, Web, Windows, Linux, macOS)

## Getting Started

### Prerequisites

- Flutter SDK (^3.6.1)
- Dart SDK
- Firebase Account
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone [https://github.com/Gerges-Rezk/CareTrace]
cd CareTrace
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a new Firebase project
   - Add your Firebase configuration files
   - Enable Authentication in Firebase Console

4. Run the application:
```bash
flutter run
```

## Project Structure

```
lib/
├── assets/
│   └── image/
├── core/
│   └── utils/
├── features/
│   ├── auth/
│   ├── home/
│   ├── medical_records/
│   ├── profile/
│   └── settings/
└── main.dart
```

## Dependencies

- **State Management**: 
  - bloc: ^9.0.0
  - flutter_bloc: ^9.1.1

- **Navigation**:
  - go_router: ^15.1.1

- **Firebase**:
  - firebase_core: ^2.30.0
  - firebase_auth: ^4.17.4

- **Database**:
  - sqflite: ^2.4.2

- **UI Components**:
  - cupertino_icons: ^1.0.8
  - modal_progress_hud_nsn: ^0.5.1

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/exFeature`)
3. Commit your changes (`git commit -m 'Add some exFeature'`)
4. Push to the branch (`git push origin feature/exFeature`)
5. Open a Pull Request


Project Link: [https://github.com/Gerges-Rezk/CareTrace]
