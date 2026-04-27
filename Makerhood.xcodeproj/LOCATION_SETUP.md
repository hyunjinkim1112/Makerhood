# Location Setup Guide for Makerhood

## What Was Done

### 1. Created LocationManager.swift
A dedicated location manager class that:
- ✅ Handles location permission requests
- ✅ Manages location updates
- ✅ Provides a Boston fallback location (42.3601, -71.0589)
- ✅ Properly handles authorization changes
- ✅ Uses @MainActor for thread safety

### 2. Updated MapView.swift
The Explore view now:
- ✅ Uses the LocationManager to get user location
- ✅ Starts with Boston as the default location
- ✅ Automatically updates the map when location is available
- ✅ Requests location permission when the view appears

## What You Need to Do in Xcode

### Add Location Permissions to Your Project

**Option A: Using Target Settings (Recommended)**

1. Open your project in Xcode
2. Select your target "Makerhood" in the project navigator (left sidebar)
3. Click on the "Info" tab
4. Look for "Custom iOS Target Properties" section
5. Click the "+" button to add new entries
6. Add these two keys:

   **First Key:**
   - Key: `Privacy - Location When In Use Usage Description`
   - Type: String
   - Value: `We need your location to show nearby makerspaces and help you find creative spaces near you.`

   **Second Key (Optional but recommended):**
   - Key: `Privacy - Location Always and When In Use Usage Description`
   - Type: String
   - Value: `We need your location to provide personalized makerspace recommendations.`

**Option B: If You Have Info.plist File**

If your project has an Info.plist file, add these entries:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to show nearby makerspaces and help you find creative spaces near you.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>We need your location to provide personalized makerspace recommendations.</string>
```

## How It Works

### First Launch
1. User opens the app and goes to the Explore tab
2. App requests location permission with your custom message
3. If user **allows**: Map centers on their location
4. If user **denies**: Map shows Boston area as default

### Location Updates
- Map starts at Boston (42.3601, -71.0589)
- When location permission is granted, map smoothly updates to user's location
- Shows nearby makerspaces based on current location

### Default Makerspaces in Boston Area
The app includes sample makerspaces in:
- MIT (Cambridge)
- Boston College (Chestnut Hill)
- South End (Boston)
- Innovation District (Boston)
- Central Square (Cambridge)

## Testing Location

### In Simulator
1. Run the app in Simulator
2. Go to: **Features → Location → Custom Location...**
3. Enter Boston coordinates:
   - Latitude: `42.3601`
   - Longitude: `--71.0589`
4. Or choose: **Features → Location → Apple** (Cupertino)

### On Device
1. Install the app on your iPhone
2. Go to Explore tab
3. You'll see a permission dialog
4. Tap "Allow While Using App"
5. Map will center on your actual location

## Privacy Notes

- ✅ Only requests "When In Use" permission (not background location)
- ✅ Location is only accessed when the Explore tab is active
- ✅ Falls back to Boston if permission is denied
- ✅ User can change permission anytime in Settings

## Next Steps

After adding the location permissions:
1. Clean build folder (Cmd + Shift + K)
2. Rebuild the app (Cmd + B)
3. Run on simulator or device
4. Test location permission flow
