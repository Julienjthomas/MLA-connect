## ADDED Requirements

### Requirement: Language toggle button in home app bar
The home screen app bar SHALL display a language toggle icon button between the notification icon and the chat icon. The button SHALL show the current locale as a text label (`EN` or `ML`). Tapping SHALL switch the locale to the other language, persist it via SharedPreferences, and update the entire app UI via `Get.updateLocale()`.

#### Scenario: Toggle from English to Malayalam
- **WHEN** current locale is `en` and user taps the language toggle button
- **THEN** locale changes to `ml`, app UI re-renders in Malayalam, and `ml` is written to SharedPreferences

#### Scenario: Toggle from Malayalam to English
- **WHEN** current locale is `ml` and user taps the language toggle button
- **THEN** locale changes to `en`, app UI re-renders in English, and `en` is written to SharedPreferences

#### Scenario: Locale persists across app restarts
- **WHEN** user has previously selected `ml` and restarts the app
- **THEN** app SHALL launch in Malayalam locale without reverting to device locale

#### Scenario: Button label reflects current locale
- **WHEN** current locale is `en`
- **THEN** button SHALL display `ML` (the language the button will switch to, as a hint)

#### Scenario: Button label reflects current locale (Malayalam active)
- **WHEN** current locale is `ml`
- **THEN** button SHALL display `EN`
