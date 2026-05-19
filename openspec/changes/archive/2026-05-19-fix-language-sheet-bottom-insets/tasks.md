## 1. Fix Bottom Sheet Insets

- [x] 1.1 In `lib/features/profile/controllers/profile_controller.dart`, wrap the `Padding` widget inside `pickLanguage`'s `showModalBottomSheet` builder with `SafeArea(top: false, child: ...)`
- [x] 1.2 Change the bottom value in `EdgeInsets.fromLTRB(24, 16, 24, 32)` to `8` so the static padding no longer doubles up with the safe area inset

## 2. Verify

- [ ] 2.1 Test on Android device/emulator with gesture navigation — confirm language tiles are not obscured by nav bar
- [ ] 2.2 Test on Android device/emulator with 3-button nav — confirm no regression
- [ ] 2.3 Test on iOS simulator — confirm home indicator inset is respected
