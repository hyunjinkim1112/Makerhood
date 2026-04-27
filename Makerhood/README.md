# Makerhood

**Makerhood** is an iOS application that connects makers with local makerspaces. The app allows users to discover makerspaces on an interactive map, view detailed profiles, and join a community of creators. Organizations can also create accounts to manage their makerspace profiles and connect with potential members.

Built with SwiftUI and Firebase, Makerhood provides a seamless experience for exploring creative spaces in your area, complete with real-time location services, user authentication, and community features.

---

## 🚀 Key Technologies

- **SwiftUI** - Modern declarative UI framework for iOS
- **Firebase Authentication** - Secure user and organization account management
- **Firebase Firestore** - Real-time NoSQL database for makerspaces, users, and community data
- **MapKit** - Interactive map with custom annotations and location-based features
- **Core Location** - User location tracking and geolocation services
- **Swift Concurrency** - Async/await patterns for efficient data fetching
- **Combine Framework** - Reactive programming for state management

---

## 📱 Screenshots

> **Note:** Add your app screenshots here. Recommended layout:

| Home Screen | Map View | Makerspace Details | Profile |
|------------|----------|-------------------|---------|
| ![Home](path/to/home.png) | ![Map](path/to/map.png) | ![Details](path/to/details.png) | ![Profile](path/to/profile.png) |

*Replace `path/to/*.png` with actual paths to your screenshot images*

---

## 🎥 Demo Video

Click the thumbnail below to watch a 60-second demonstration of Makerhood in action:

[![Makerhood Demo Video](https://img.youtube.com/vi/YOUR_VIDEO_ID/maxresdefault.jpg)](https://www.youtube.com/watch?v=YOUR_VIDEO_ID)

> **Instructions:** Replace `YOUR_VIDEO_ID` with your actual YouTube video ID. You can find this in your YouTube URL: `https://www.youtube.com/watch?v=YOUR_VIDEO_ID`
>
> **Alternative format** if you prefer a custom thumbnail:
> ```markdown
> [![Watch the demo](path/to/your/custom-thumbnail.png)](https://www.youtube.com/watch?v=YOUR_VIDEO_ID)
> ```

---

## ✨ Features

### For Users
- 🗺️ **Interactive Map** - Discover makerspaces on a dynamic map with custom markers
- 📍 **Location Services** - Find makerspaces near you with real-time location tracking
- 🔍 **Detailed Profiles** - View comprehensive information about each makerspace
- 👤 **User Profiles** - Manage your personal account and preferences
- 🏠 **Home Dashboard** - Quick access to nearby spaces and recommendations

### For Organizations
- 🏢 **Makerspace Management** - Create and edit your makerspace profile
- 📝 **Custom Information** - Add descriptions, addresses, images, and coordinates
- 🌐 **Online Presence** - Include website links and contact information
- 📊 **Community Engagement** - Connect with potential members and showcase your space

---

## 🏗️ Project Structure

```
Makerhood/
├── Models/              # Data models (Makerspace, User, etc.)
├── Views/               # SwiftUI views
│   ├── Map/            # Map-related views
│   ├── Profile/        # User and makerspace profiles
│   └── Authentication/ # Login and signup flows
├── ViewModels/          # Business logic and state management
├── Services/            # Firebase, location, and API services
└── Utils/              # Helper functions and extensions
```

---

## 🛠️ Setup Instructions

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0+ deployment target
- CocoaPods or Swift Package Manager
- Firebase account

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/makerhood.git
   cd makerhood
   ```

2. **Install dependencies**
   
   If using CocoaPods:
   ```bash
   pod install
   open Makerhood.xcworkspace
   ```
   
   If using Swift Package Manager, dependencies should resolve automatically in Xcode.

3. **Configure Firebase**
   - Create a new Firebase project at [firebase.google.com](https://firebase.google.com)
   - Add an iOS app to your Firebase project
   - Download `GoogleService-Info.plist` and add it to your Xcode project
   - Enable Firebase Authentication (Email/Password provider)
   - Create a Firestore database

4. **Set up Firestore collections**
   
   Create the following collections in Firestore:
   - `users` - User profiles
   - `makerspaces` - Makerspace information

5. **Configure location permissions**
   
   The app requires location permissions. These are already configured in `Info.plist`:
   - `NSLocationWhenInUseUsageDescription`
   - `NSLocationAlwaysAndWhenInUseUsageDescription`

6. **Build and run**
   ```bash
   # Select your target device or simulator
   # Press Cmd+R to build and run
   ```

---

## 📋 Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+
- Active internet connection for Firebase services

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Authors

- **Hyunjin Kim** - *Initial work*

---

## 🙏 Acknowledgments

- MapKit for providing powerful mapping capabilities
- Firebase for backend infrastructure
- The maker community for inspiration

---

## 📧 Contact

For questions or feedback, please reach out through the repository's issue tracker.

---

**Made with ❤️ for the maker community**
