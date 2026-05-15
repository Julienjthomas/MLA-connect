## MODIFIED Requirements

### Requirement: Language toggle button in home app bar
The home screen app bar SHALL display a language toggle control between the notification icon and the chat icon. The control SHALL include a translate or language icon and a clear text label naming the language the user will switch to (`English` or `മലയാളം`, or localized equivalents). Tapping SHALL switch the locale to the other language, persist it via SharedPreferences or authenticated profile update, and update the entire app UI via `Get.updateLocale()`.

#### Scenario: Toggle from English to Malayalam
- **WHEN** current locale is `en` and user taps the language toggle control
- **THEN** locale changes to `ml`, app UI re-renders in Malayalam, and `ml` is persisted

#### Scenario: Toggle from Malayalam to English
- **WHEN** current locale is `ml` and user taps the language toggle control
- **THEN** locale changes to `en`, app UI re-renders in English, and `en` is persisted

#### Scenario: Locale persists across app restarts
- **WHEN** user has previously selected `ml` and restarts the app
- **THEN** app SHALL launch in Malayalam locale without reverting to device locale

#### Scenario: Control shows target language clearly
- **WHEN** current locale is `en`
- **THEN** the control SHALL show a translate or language icon and label indicating Malayalam as the switch target

#### Scenario: Control shows target language clearly (Malayalam active)
- **WHEN** current locale is `ml`
- **THEN** the control SHALL show a translate or language icon and label indicating English as the switch target
