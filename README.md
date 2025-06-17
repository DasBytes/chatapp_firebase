💬 Flutter & Firebase Group Chat App
A full-featured Group Chat App built with Flutter and Firebase, designed as a complete guide for beginners to advanced developers. This project walks you through building a modern messaging app from scratch, covering everything from authentication to real-time messaging using the latest Flutter SDK and Firebase services.

⚠️ This version supports group chat. One-to-one (private) chat will be added in a future update.

📱 Features
🔐 Email/Password Authentication
Secure user sign-up and login with Firebase Authentication.

📤 Real-time Messaging
Send and receive messages in real time using Firebase Firestore and StreamBuilder.

📁 CRUD Operations
Perform Create, Read, Update, and Delete operations on chat data.

🧠 Error Handling
Graceful error messages and state management for a smooth user experience.

🔍 Search Functionality
Search through chat messages and users (using Firestore queries).

💬 Group Chat Support
Users can chat in shared group rooms.

📱 Cross-Platform
Works on both Android and iOS.

🛠️ Tech Stack
Flutter (Latest Stable)

Firebase Authentication

Cloud Firestore

Firebase Core

StreamBuilder

Provider / State Management

Dart

🚀 Getting Started
1. Clone the repository
bash
Copy
Edit
git clone https://github.com/your-username/flutter-group-chat-app.git
2. Open the project in VS Code or Android Studio
3. Install dependencies
bash
Copy
Edit
flutter pub get
4. Set up Firebase
Create a Firebase project at console.firebase.google.com

Add Android/iOS app to the Firebase project

Download and place the google-services.json (Android) or GoogleService-Info.plist (iOS) into the respective directories

Enable Email/Password authentication and Firestore in Firebase Console

5. Run the app
bash
Copy
Edit
flutter run
📁 Folder Structure
bash
Copy
Edit
lib/
├── screens/           # UI screens
├── services/          # Firebase functions
├── models/            # Data models
├── widgets/           # Reusable components
├── utils/             # Constants, helpers
└── main.dart          # App entry point
📌 Upcoming Features
🔒 One-to-One (Private) Chat

📸 Image Sharing

✅ Message Read Status

🔔 Push Notifications

