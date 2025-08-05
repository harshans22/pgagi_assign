# StartupHub - AI-Powered Startup Ideas Platform

<div align="center">
  <h3>🚀 Share, Rate, and Discover Amazing Startup Ideas</h3>
  <p>A Flutter app that lets entrepreneurs submit startup ideas, get AI-powered feedback, and compete on a community leaderboard</p>
</div>

---
## 🎬 Video Demo

https://private-user-images.githubusercontent.com/127718826/474692385-92f88f3c-ba67-4217-bd75-78dacc7b728c.mp4?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NTQ0MjM2MTYsIm5iZiI6MTc1NDQyMzMxNiwicGF0aCI6Ii8xMjc3MTg4MjYvNDc0NjkyMzg1LTkyZjg4ZjNjLWJhNjctNDIxNy1iZDc1LTc4ZGFjYzdiNzI4Yy5tcDQ_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwODA1JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDgwNVQxOTQ4MzZaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1kN2YxZGY5MDliYTIwMjk1NTlhMjBlM2YyMWFhNmY4MDNkOTYzMjU4ZmMyMGI2MGRkN2Y5MGRlYjVkMmVhNmNkJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.sJB21t7ZyXKXgianjs-a2UI0oB8Tep7gLtWLwaYG_KM


## 📱 App Description

StartupHub is a comprehensive Flutter application designed for entrepreneurs and innovators to share their startup ideas with a community. The app features an intelligent AI rating system that analyzes submitted ideas and provides instant feedback, while allowing users to vote on their favorite concepts. Ideas are showcased on an interactive leaderboard, creating a competitive and engaging environment for innovation.

**Key Highlights:**
- 🤖 AI-powered idea analysis and rating (1-100 scale)
- 🗳️ Community voting system with vote tracking
- 🏆 Dynamic leaderboard with ranking system
- 🔍 Advanced search and filtering capabilities
- 🌓 Dark/Light theme support
- 📱 Responsive design for all screen sizes

---

## 🛠️ Tech Stack

### **Frontend Framework**
- **Flutter** - Cross-platform mobile development framework
- **Dart** - Programming language

### **State Management**
- **Flutter BLoC** - Business Logic Component pattern for state management
- **Equatable** - Simplifying equality comparisons

### **Navigation**
- **GoRouter** - Declarative routing solution

### **Local Storage**
- **SharedPreferences** - Persistent local data storage

### **UI & Design**
- **Google Fonts** - Custom typography (Poppins font family)
- **Flutter Animate** - Smooth animations and transitions
- **Flutter ScreenUtil** - Responsive design utilities
- **Lottie** - Vector animations
- **Material Design 3** - Modern UI components

### **Utilities**
- **UUID** - Unique identifier generation
- **FlutterToast** - User feedback notifications
- **Share Plus** - Social sharing functionality

### **Development Tools**
- **Flutter Lints** - Code quality and style enforcement

---

## ✨ Features Implemented

### 🎯 **Core Features**

#### 1. **Idea Submission**
- Form validation with character limits
- Real-time input feedback
- AI processing simulation with loading states
- Success confirmation with AI rating display

#### 2. **AI Rating System**
- Intelligent scoring algorithm (1-100 scale)
- Rating categories: Exceptional, Excellent, Good, Average, Needs Work
- Simulated AI processing delay for realistic experience
- Color-coded rating badges

#### 3. **Community Voting**
- One-vote-per-idea limitation
- Vote tracking and persistence
- Real-time vote count updates
- Visual feedback for voted ideas

#### 4. **Interactive Leaderboard**
- Top 10 ideas ranking
- Sort by votes or AI rating
- Gradient backgrounds for top 3 positions (🥇🥈🥉)
- Statistics display (total ideas, total votes)

### 🔧 **Advanced Features**

#### 5. **Search & Filter System**
- Real-time search across name, tagline, and description
- Multiple sorting options:
  - Most Recent (default)
  - Highest AI Rating
  - Most Votes
- Search result counters

#### 6. **Detailed Idea Views**
- Expandable idea cards
- Full-screen detail pages
- Social sharing integration
- Rank display for leaderboard items

#### 7. **User Experience**
- Smooth page transitions and animations
- Loading states and error handling
- Empty state illustrations
- Pull-to-refresh functionality
- Toast notifications for user feedback

#### 8. **Theme System**
- Light and dark mode support
- Consistent color schemes
- Theme persistence across sessions
- Smooth theme transitions

#### 9. **Responsive Design**
- Adaptive layouts for different screen sizes
- Consistent spacing and typography
- Touch-friendly interactive elements

### 📊 **Data Management**
- Local data persistence
- Vote history tracking
- Theme preference storage
- Data validation and error handling

---

## 🚀 How to Run Locally

### **Prerequisites**
- Flutter SDK (version 3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- iOS Simulator (for iOS development) or Android Emulator

### **Installation Steps**

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd pgagi_assign
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   # For development
   flutter run
   
   # For specific platform
   flutter run -d android
   flutter run -d ios
   ```

### **Build for Production**

#### **Android APK**
```bash
# Debug APK
flutter build apk

# Release APK
flutter build apk --release

# Split APKs by architecture
flutter build apk --split-per-abi
```

#### **iOS**
```bash
flutter build ios --release
```

#### **Web**
```bash
flutter build web
```

**APK Location:** `build/app/outputs/flutter-apk/app-release.apk`

---

## 📱 Installation Guide

### **Option 1: Install from APK (Android)**
1. Download the APK file from the releases section
2. Enable "Install from Unknown Sources" in Android settings
3. Open the APK file and follow installation prompts

### **Option 2: Development Installation**
1. Connect your device via USB
2. Enable Developer Options and USB Debugging
3. Run `flutter devices` to verify device connection
4. Execute `flutter run` to install and launch

---

## 🏗️ Project Structure

```
lib/
├── blocs/              # BLoC state management
├── constants/          # App constants and themes
├── models/            # Data models
├── repositories/      # Data layer
├── screens/           # UI screens
├── services/          # Business services
├── utils/             # Utility functions
├── widgets/           # Reusable UI components
└── main.dart          # App entry point
```

---


### App Walkthrough
See StartupHub in action! This comprehensive demo showcases all the key features including idea submission, AI rating, community voting, and the interactive leaderboard.

**Video File:** `assets/videos/startup_hub.mp4`

**What you'll see in the demo:**
- 📝 Complete idea submission flow with form validation
- 🤖 AI rating system in action (scoring 1-100)
- 🗳️ Community voting with real-time updates
- 🏆 Dynamic leaderboard with top ideas
- 🔍 Search and filtering capabilities
- 🌓 Dark/Light theme switching
- 📱 Responsive design across different screen sizes

**Demo Highlights:**
- ⚡ Smooth animations and transitions
- 🎯 User-friendly interface navigation
- 💡 Real-time feedback and interactions
- 🏅 Complete user journey from idea creation to leaderboard ranking

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Developer

**Harsh Singh**
- GitHub: [@harshsingh](https://github.com/harshsingh)

---
<!-- 
<div align="center">
  <p>Made with ❤️ using Flutter</p>
  <p>🚀 <strong>StartupHub - Where Ideas Take Flight!</strong> 🚀</p>
</div> -->
