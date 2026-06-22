# movie-app

## Leírás
A `movie-app` egy iOS alkalmazás, amely SwiftUI segítségével lehetővé teszi filmek és sorozatok böngészését, keresését, részletes megtekintését, kedvencek kezelését és értékelések megjelenítését. Az alkalmazás a The Movie Database (TMDb) API-t használja a tartalmak lekéréséhez, valamint helyi cache-elést is alkalmaz a jobb offline élmény érdekében.

## Főbb funkciók
- Filmek és sorozatok megtekintése kategóriák szerint
- Keresés a filmek között
- Részletes oldal filmekhez, szereplőkhez és hasonló tartalmakhoz
- Kedvencek mentése és kezelése
- Nyelv- és téma beállítások
- Analitikai és hibajelentési támogatás Firebase segítségével

## Használt technológiák
- **SwiftUI** – felhasználói felület
- **Combine** – események és adatfolyamok kezelése
- **Moya** – hálózati API hívások
- **Swinject** – dependency injection
- **Realm** – helyi adatbázis / cache
- **SDWebImageSwiftUI** – képek letöltése és megjelenítése
- **Lottie** – animációk
- **Firebase Analytics / Crashlytics** – elemzés és hibakövetés
- **XCTest / UITest** – tesztek

## Előfeltételek
- Xcode (ajánlott verzió: aktuális stabil kiadás)
- iOS Simulator vagy fizikai iPhone/iPad
- TMDb API kulcs
- Firebase konfigurációs fájlok

## Telepítés és beállítás
1. Klónozd a projektet:
   ```bash
   git clone <repo-url>
   cd movie-app
   ```
2. Nyisd meg az Xcode-ban a projektet:
   ```bash
   open movie-app.xcodeproj
   ```
3. Készítsd el a szükséges konfigurációs fájlokat:
   - `Config.plist` tartalmazza a következőket:
     - `API_TOKEN`
     - `ACCOUNT_ID`
   - `GoogleService-Info.plist` a Firebase beállításokhoz
4. Xcode-ban futtasd a Swift packageek újraoldását (ha szükséges), majd válaszd ki a megfelelő scheme-t.

> Fontos: az alkalmazás futtatásához szükséges a TMDb hitelesítési adatok beállítása, különben a hálózati kérések nem lesznek sikeresek.

## Futtatás
Az alkalmazás közvetlenül Xcode-ból indítható:

```bash
open movie-app.xcodeproj
```

Vagy parancssorból buildeléshez:

```bash
xcodebuild -project movie-app.xcodeproj -scheme "movie-app DEV" -destination 'platform=iOS Simulator,name=iPhone 15' build
```

## Tesztek
A projekt tartalmaz egységteszteket és UI teszteket. Futtatásukhoz:

```bash
xcodebuild test -project movie-app.xcodeproj -scheme "movie-app DEV" -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Projekt struktúra
- `movie-app/` – az alkalmazás forráskódja
- `movie-appTests/` – egységtesztek
- `movie-appUITests/` – UI tesztek
- `movie-app.xcodeproj/` – Xcode projektfájl

## Kiegészítő megjegyzés
A projekt jól használható példaként SwiftUI + MVVM + hálózati réteg + helyi cache kombinációjára iOS alkalmazások fejlesztéséhez.
