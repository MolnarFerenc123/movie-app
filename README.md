# movie-app

## Description
A `movie-app` is an iOS application that uses SwiftUI to allow users to browse movies and TV series, search for content, view detailed information, manage favorites, and display reviews. The app uses The Movie Database (TMDb) API to fetch data and also applies local caching to improve the offline experience.

## Key Features
- Browse movies and TV series by category
- Search across movies
- Detailed screens for movies, cast members, and similar content
- Save and manage favorites
- Language and theme settings
- Analytics and crash reporting support via Firebase

## Technologies Used
- **SwiftUI** – user interface
- **Combine** – handling events and data flows
- **Moya** – network API requests
- **Swinject** – dependency injection
- **Realm** – local database / caching
- **SDWebImageSwiftUI** – downloading and displaying images
- **Lottie** – animations
- **Firebase Analytics / Crashlytics** – analytics and error tracking
- **XCTest / UITest** – testing

## Prerequisites
- Xcode (recommended: latest stable version)
- iOS Simulator or a physical iPhone/iPad
- TMDb API key
- Firebase configuration files

## Installation and Setup
1. Clone the project:
   ```bash
   git clone <repo-url>
   cd movie-app
   ```
2. Open the project in Xcode:
   ```bash
   open movie-app.xcodeproj
   ```
3. Create the required configuration files:
   - `Config.plist` should contain:
     - `API_TOKEN`
     - `ACCOUNT_ID`
   - `GoogleService-Info.plist` for Firebase setup
4. In Xcode, resolve the Swift packages if needed, then select the appropriate scheme.

> Important: To run the app successfully, the TMDb authentication details must be configured correctly; otherwise, network requests will not succeed.

## Running the Project
The application can be launched directly from Xcode:

```bash
open movie-app.xcodeproj
```

Or, to build from the command line:

```bash
xcodebuild -project movie-app.xcodeproj -scheme "movie-app DEV" -destination 'platform=iOS Simulator,name=iPhone 15' build
```

## Testing
The project includes unit tests and UI tests. To run them:

```bash
xcodebuild test -project movie-app.xcodeproj -scheme "movie-app DEV" -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Project Structure
- `movie-app/` – application source code
- `movie-appTests/` – unit tests
- `movie-appUITests/` – UI tests
- `movie-app.xcodeproj/` – Xcode project file

## Additional Note
This project is a good example of combining SwiftUI, MVVM, networking, and local caching for iOS application development.
