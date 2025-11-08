# Onboarding Screens

This folder contains all the onboarding-related screens for the BillKeep app.

## Screens

### 1. OnboardingCoordinator
**File:** `onboarding_coordinator.dart`

The coordinator that determines which screen to show based on authentication state. This should be the initial route of your app.

**Route:** `/` or `/onboarding`

### 2. WelcomeCarouselScreen
**File:** `welcome_carousel_screen.dart`

A full-screen carousel that showcases the app's features. Each slide displays:
- An icon representing the feature category
- A title and description
- A list of key features with checkmarks
- Page indicators showing progress through the carousel
- A "Get Started" or "Next" button

**Route:** `/onboarding/welcome`

**Features:**
- 4 slides showcasing different aspects of the app
- Swipeable carousel navigation
- Skip button to jump directly to auth
- Auto-animated page indicators

### 3. AuthScreen
**File:** `auth_screen.dart`

A combined signup/login screen with toggle functionality.

**Route:** `/auth`

**Features:**
- Toggle between signup and login modes
- Email validation
- Password visibility toggle
- Username field (signup only)
- Form validation
- Error message display
- Loading state during API calls

**Navigation:**
- On **signup success** → Navigate to `/onboarding/config` (InitialConfigScreen)
- On **login success** → Navigate to `/main` (MainNavigationScreen)

### 4. InitialConfigScreen
**File:** `initial_config_screen.dart`

A 3-step wizard for initial account configuration (new users only).

**Route:** `/onboarding/config`

**Steps:**

1. **Currency Selection**
   - Automatically suggests currency based on device locale
   - List of popular fiat and crypto currencies
   - Radio button selection

2. **Create First Wallet**
   - Wallet name input
   - Wallet type dropdown (cash, bank, credit card, crypto, other)
   - Initial balance input
   - Form validation

3. **Create First Project**
   - Project name input (required)
   - Project description (optional)
   - Form validation

**Features:**
- Visual step progress indicator
- Back navigation between steps
- Form validation at each step
- Loading state during setup completion
- Automatic currency suggestion based on locale

**Navigation:**
- On **completion** → Navigate to `/main` (MainNavigationScreen)

## Integration Guide

### 1. Update your main.dart routes:

```dart
MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => const OnboardingCoordinator(),
    '/onboarding/welcome': (context) => const WelcomeCarouselScreen(),
    '/auth': (context) => const AuthScreen(),
    '/onboarding/config': (context) {
      final user = ModalRoute.of(context)!.settings.arguments as User;
      return InitialConfigScreen(user: user);
    },
    '/main': (context) => const MainNavigationScreen(),
  },
);
```

### 2. Dependencies Required:

All dependencies are already in `pubspec.yaml`:
- `intl` - For locale-based currency suggestion
- Services from `lib/services/auth_service.dart`
- Models from `lib/models/user_model.dart`

### 3. Flow Diagram:

```
App Start
    ↓
OnboardingCoordinator
    ↓
Is Authenticated?
    ├─ Yes → MainNavigationScreen
    └─ No → WelcomeCarouselScreen
                ↓
            AuthScreen
                ↓
            Is Signup?
                ├─ Yes → InitialConfigScreen → MainNavigationScreen
                └─ No (Login) → MainNavigationScreen
```

## Customization

### Modifying Welcome Slides

Edit the `_slides` list in `WelcomeCarouselScreen`:

```dart
final List<OnboardingSlide> _slides = [
  OnboardingSlide(
    title: 'Your Title',
    description: 'Your description',
    features: ['Feature 1', 'Feature 2', ...],
    icon: Icons.your_icon,
    color: Colors.yourColor,
  ),
  // Add more slides...
];
```

### Modifying Currency List

Edit the `_currencies` map in `InitialConfigScreen`:

```dart
final Map<String, String> _currencies = {
  'CODE': 'Symbol - Name',
  // Add more currencies...
};
```

### Modifying Locale to Currency Mapping

Edit the `currencyMap` in the `_suggestCurrency()` method:

```dart
final currencyMap = {
  'CountryCode': 'CurrencyCode',
  // Add more mappings...
};
```

## API Integration Notes

The screens use the following services that need to be implemented in your backend:

1. **AuthService** (`lib/services/auth_service.dart`):
   - `signup(email, username, password)` → Returns `AuthResponse` with token and user
   - `login(email, password)` → Returns `AuthResponse` with token and user
   - `isAuthenticated()` → Returns boolean

2. **Initial Configuration APIs** (to be implemented in `_completeSetup()` method):
   - Create currency preference
   - Create first wallet
   - Create first project

## TODO

- [ ] Implement forgot password functionality in AuthScreen
- [ ] Add social login options (Google, Apple, etc.)
- [ ] Implement API calls in `InitialConfigScreen._completeSetup()`
- [ ] Add analytics tracking for onboarding completion
- [ ] Add skip option for initial configuration (optional)
- [ ] Implement email verification flow
- [ ] Add biometric authentication option
- [ ] Implement terms of service and privacy policy links

## Troubleshooting

**Issue:** Currency suggestion not working
- **Solution:** Ensure the device locale is properly set. The app falls back to USD if detection fails.

**Issue:** Navigation doesn't work
- **Solution:** Ensure all routes are properly registered in `main.dart` and route names match exactly.

**Issue:** User argument is null in InitialConfigScreen
- **Solution:** Ensure the User object is passed correctly through route arguments from AuthScreen.
