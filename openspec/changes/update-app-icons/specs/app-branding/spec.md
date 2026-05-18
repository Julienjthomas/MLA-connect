## ADDED Requirements

### Requirement: App launcher icon

The app SHALL display the new MLA Connect brand launcher icon on both Android and iOS at all required densities/sizes.

#### Scenario: Android launcher icon present at all densities
- **WHEN** the app is installed on an Android device
- **THEN** `mipmap-mdpi`, `mipmap-hdpi`, `mipmap-xhdpi`, `mipmap-xxhdpi`, and `mipmap-xxxhdpi` each contain the new `ic_launcher.png`
- **AND** the launcher displays the new icon without scaling artifacts

#### Scenario: iOS app icon present at all required slots
- **WHEN** the app is installed on iPhone or iPad
- **THEN** every filename referenced in `ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json` resolves to the new brand PNG at correct pixel dimensions
- **AND** the home-screen icon, Settings icon, Spotlight icon, and App Store marketing icon all render the new brand

#### Scenario: Asset catalog unchanged
- **WHEN** the icon swap is complete
- **THEN** `Contents.json` is byte-identical to its previous version
- **AND** no Xcode project file (`project.pbxproj`) changes are required
