# Manual Testing Guide

## Prerequisites
- Flutter device connected or emulator running
- Internet connection active

## How to Run

```bash
flutter run
```

Or for specific device:
```bash
flutter devices  # List available devices
flutter run -d <device-id>
```

## Test Scenarios

### 1. Initial Load
**Steps:**
1. Launch the app
2. Observe the home screen

**Expected:**
- Shimmer loading skeleton appears
- After 1-2 seconds, list of Rick & Morty characters loads
- Each card shows: image, name, and status/species
- Smooth fade-in animation for each card

### 2. Infinite Scroll / Pagination
**Steps:**
1. Scroll down through the list
2. Continue scrolling to the bottom
3. Observe behavior

**Expected:**
- Loading indicator appears at bottom when reaching ~80% of scroll
- New items load automatically
- No duplicates in the list
- Smooth scrolling experience

### 3. Pull to Refresh
**Steps:**
1. Pull down from the top of the list
2. Release

**Expected:**
- Refresh indicator appears
- List reloads from page 1
- Previous items are replaced
- Scroll position resets to top

### 4. Search Functionality
**Steps:**
1. Tap the search bar at the top
2. Type "rick" slowly
3. Observe behavior
4. Clear the search

**Expected:**
- Debounce works (doesn't search on every keystroke)
- Results appear after 500ms of typing stop
- Clear button (X) appears when typing
- Tapping clear button removes search and shows full list

### 5. Search - No Results
**Steps:**
1. Type "zzzzzzzzz" in search bar

**Expected:**
- "No results found" message with icon
- Clean empty state UI

### 6. Navigation to Detail
**Steps:**
1. Tap any character card from the list
2. Observe the transition

**Expected:**
- Hero animation: image smoothly transitions from card to detail
- Slide transition for the page
- Detail screen loads with expanded image in AppBar
- Back button visible in top-left

### 7. Detail Screen Content
**Steps:**
1. On detail screen, scroll down
2. Observe the information displayed

**Expected:**
- Character name at top
- Status and species description
- Additional information cards showing:
  - Status
  - Species
  - Gender
  - Origin
  - Location
  - Episode count
  - Created date
- All information formatted nicely
- SliverAppBar collapses when scrolling

### 8. Navigation Back
**Steps:**
1. From detail screen, tap back button
2. Or swipe from left edge (iOS gesture)

**Expected:**
- Smooth slide transition back
- Returns to same scroll position in list
- No lag or stutter

### 9. Scroll to Top Button
**Steps:**
1. Scroll down more than 500px in the list
2. Observe bottom-right corner
3. Tap the FAB button

**Expected:**
- FAB appears after scrolling past 500px
- Has upward arrow icon
- Tapping smoothly scrolls to top
- FAB disappears when near top

### 10. Error Handling - No Internet
**Steps:**
1. Turn off WiFi/mobile data
2. Force close and restart app
3. Or pull to refresh

**Expected:**
- Error message appears
- "Try Again" button visible
- Tapping retry attempts to reload
- Clear error messaging

### 11. Theme Support
**Steps:**
1. Check device system theme
2. Change device to dark mode
3. Return to app (or restart)

**Expected:**
- App respects system theme
- Colors adapt appropriately
- All text remains readable
- Smooth theme transitions

## Testing Different APIs

### Test Rick & Morty API (Default)
**File:** `lib/presentation/providers/items_provider.dart`
```dart
return RickAndMortyDataSource(client);
```
**Expected Results:**
- Characters with images
- Names like "Rick Sanchez", "Morty Smith"
- Status, species information

### Test Dog API
**Change line 14 to:**
```dart
return DogApiDataSource(client);
```
**Hot Restart** (R key or restart button)

**Expected Results:**
- Different dog breeds
- Names like "Affenpinscher", "Akita", "Bulldog"
- Dog breed images
- Description shows breed name

### Test Cat API
**Change line 14 to:**
```dart
return CatApiDataSource(client);
```
**Hot Restart** (R key or restart button)

**Expected Results:**
- Cat breeds
- Images of cats
- Breed information in detail
- Temperament and origin data

## Visual Quality Checks

### Spacing & Layout
- [ ] Consistent padding (16dp default)
- [ ] Cards have proper spacing
- [ ] No overlapping elements
- [ ] Touch targets >= 48dp

### Typography
- [ ] Titles are bold and prominent
- [ ] Body text is readable
- [ ] Consistent font sizes
- [ ] Good contrast ratios

### Images
- [ ] Load properly with placeholder
- [ ] Cached (second load faster)
- [ ] Error states show gracefully
- [ ] Aspect ratios maintained

### Animations
- [ ] Smooth 60fps
- [ ] No jank or stuttering
- [ ] Appropriate durations
- [ ] Natural feeling

### Colors
- [ ] Primary color (Indigo) used consistently
- [ ] Good contrast on all backgrounds
- [ ] Error states in red
- [ ] Loading states clear

## Performance Checks

### Memory
- [ ] No memory leaks
- [ ] Smooth scrolling even with many items
- [ ] Images don't cause crashes

### Network
- [ ] Images are cached
- [ ] Search is debounced
- [ ] Pagination loads efficiently
- [ ] No unnecessary API calls

### Responsiveness
- [ ] App works on different screen sizes
- [ ] Landscape mode (if applicable)
- [ ] No UI overflow
- [ ] Adaptive layouts

## Edge Cases

### Empty List
**Steps:** Use API that returns empty results
**Expected:** Empty state message shown

### Single Item
**Steps:** Modify API to return one item
**Expected:** List shows single item properly

### Very Long Names
**Expected:** Text truncates with ellipsis

### Missing Images
**Expected:** Placeholder or error icon shown

### Slow Network
**Expected:** Loading states shown, no crashes

### API Down
**Expected:** Error message with retry option

## Regression Tests

After any code changes, verify:
- [ ] App launches successfully
- [ ] List loads
- [ ] Search works
- [ ] Navigation works
- [ ] No new linter errors
- [ ] No console errors

## Device Testing Matrix

| Device Type | Screen Size | Android Version | Status |
|-------------|-------------|-----------------|--------|
| Phone       | Small       | 9.0+           | ✅     |
| Phone       | Medium      | 10.0+          | ✅     |
| Phone       | Large       | 11.0+          | ✅     |
| Tablet      | 7"          | 10.0+          | ✅     |
| Tablet      | 10"         | 11.0+          | ✅     |

## Common Issues & Solutions

### Issue: White screen on launch
**Solution:** Check internet connection, restart app

### Issue: Images not loading
**Solution:** Verify API endpoints, check HTTPS

### Issue: Search not working
**Solution:** Wait 500ms after typing

### Issue: Infinite scroll not triggering
**Solution:** Scroll to at least 80% of the list

## Automated Testing (Future)

To add in the future:
- Unit tests for repositories
- Unit tests for providers
- Widget tests for screens
- Integration tests for flows
- Golden tests for UI

## Reporting Bugs

When reporting bugs, include:
1. Steps to reproduce
2. Expected behavior
3. Actual behavior
4. Screenshots/video
5. Device info
6. Console logs

## Sign-off Checklist

- [ ] All test scenarios passed
- [ ] No visual glitches
- [ ] Performance is smooth
- [ ] All APIs tested
- [ ] Error states handled
- [ ] Loading states shown
- [ ] Animations smooth
- [ ] No crashes
- [ ] No linter errors
- [ ] Documentation reviewed

---

**Testing Status:** ✅ Ready for Testing
**Last Updated:** Implementation Complete

