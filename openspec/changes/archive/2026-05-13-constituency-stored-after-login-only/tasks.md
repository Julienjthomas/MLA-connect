## 1. Remove pre-auth prefs write

- [x] 1.1 In `lib/features/onboarding/views/constituency_view.dart`, delete the `await ConstituencyPrefs.save(id: c.id, name: c.name);` line inside the `_isPreAuth` branch (keep `Get.toNamed(Routes.phone)`)

## 2. Verification

- [ ] 2.1 Select constituency in picker, kill app, cold-launch → splash shows "MLA Connect" (not constituency name)
- [ ] 2.2 Full onboarding flow: select constituency → phone → OTP → profile save → constituency appears on home/splash normally
- [ ] 2.3 Existing logged-in user: cold-launch → constituency still shown (profile hydration path unaffected)
- [x] 2.4 Run `flutter analyze` — no errors
