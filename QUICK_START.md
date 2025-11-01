# Quick Start Guide

## Running the App

```bash
# Install dependencies
flutter pub get

# Run on your device/emulator
flutter run

# Or select a specific device
flutter devices
flutter run -d <device-id>
```

## Testing Different APIs

The app comes with 3 pre-configured APIs. To switch between them:

### 1. Rick and Morty API (Default)
Shows characters from the Rick and Morty series with images and details.

File: `lib/presentation/providers/items_provider.dart`
```dart
return RickAndMortyDataSource(client);
```

### 2. Dog API
Shows different dog breeds with images.

Change line 14 to:
```dart
return DogApiDataSource(client);
```

### 3. Cat API
Shows cat breeds with images and information.

Change line 14 to:
```dart
return CatApiDataSource(client);
```

After changing, just hot restart the app (press 'R' in the terminal or click restart in your IDE).

## Features to Test

1. **Home Screen**
   - List loads automatically on start
   - Scroll down to trigger pagination (loads more items)
   - Pull down to refresh the list

2. **Search**
   - Click the search bar at the top
   - Type to search (debounced, waits 500ms)
   - Clear button appears when typing
   - Shows search results instantly

3. **Detail Screen**
   - Tap any item card
   - Hero animation transitions the image
   - Shows complete item information
   - Swipe back or tap back button

4. **Animations**
   - Item cards fade in with scale animation
   - Hero animation on image transition
   - Shimmer loading skeletons
   - Smooth page transitions

5. **Scroll to Top**
   - Scroll down past 500px
   - FAB appears in bottom right
   - Tap to smoothly scroll to top

6. **Theme**
   - App respects system theme (light/dark)
   - Modern Material Design 3
   - Smooth color transitions

## Common Issues

### No items showing
- Check internet connection
- Verify the API is accessible
- Check console for error messages

### Images not loading
- Some APIs might have rate limits
- Check if the API endpoint is correct
- Try switching to a different API

### Build errors
- Run `flutter clean` then `flutter pub get`
- Make sure Flutter is up to date: `flutter upgrade`

## Architecture Overview

```
User Action → Provider → Repository → DataSource → ApiClient → API
                ↓
              Widget updates with new state
```

## Code Style

- All code in English
- Variables and functions are self-explanatory
- Minimal comments
- Clean architecture principles
- SOLID principles applied

## Performance Tips

- Images are cached automatically
- Search is debounced (reduces API calls)
- Pagination loads more items efficiently
- Shimmer effects for better perceived performance

## Development Workflow

1. Make changes to code
2. Save (hot reload happens automatically)
3. For major changes, hot restart (R key)
4. For dependency changes, stop and `flutter run` again

## Useful Commands

```bash
# Check for issues
flutter analyze

# Format code
flutter format lib/

# Clean build files
flutter clean

# Check Flutter setup
flutter doctor

# Update dependencies
flutter pub upgrade
```

## Next Steps

- Add unit tests
- Implement favorites with local storage
- Add more filter options
- Create custom animations
- Add share functionality
- Implement offline mode

Enjoy building! 🚀

