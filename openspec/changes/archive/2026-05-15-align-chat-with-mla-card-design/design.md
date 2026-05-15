## Context

`_ChatWithMlaCard` is a private widget inside `profile_view.dart`. It's a single, self-contained UI component — no shared state, no new dependencies, no data model changes. The redesign is purely visual: icon shape/type, trailing action style, and background tint.

Current implementation uses `Icons.chat_bubble_rounded` in a `BorderRadius.circular(12)` square container and `Icons.chevron_right_rounded` as the trailing affordance.

Target (snapshot): circular icon container with `Icons.account_balance_rounded`, and an `OutlinedButton.icon` labelled "Start Chat" on the trailing side.

## Goals / Non-Goals

**Goals**
- Match the snapshot: circular icon badge, "Start Chat" outlined button, light lavender card tint
- Keep full-card tap navigation to `Routes.chat`
- Update string constants to "MLA Office Support" / "Message the constituency office directly."

**Non-Goals**
- No changes to chat functionality, routing, or data layer
- No changes to `ChatView` itself
- No new dependencies

## Decisions

**1. Icon: `account_balance_rounded` (capitol building)**
Snapshot shows a parliament/capitol silhouette. `Icons.account_balance_rounded` is the closest built-in Flutter icon. Alternative `Icons.domain_rounded` is less recognizable. No custom SVG needed.

**2. Trailing: `OutlinedButton.icon` not `ElevatedButton`**
Snapshot shows an outlined (border-only) button with no fill. `OutlinedButton.icon` with `side: BorderSide(color: AppColors.primary)` and `foregroundColor: AppColors.primary` matches exactly. `ElevatedButton` would add fill and shadow — wrong.

**3. Card tap + button tap both navigate to chat**
The whole card remains tappable (`InkWell` / `GestureDetector`). The button also calls `Get.toNamed(Routes.chat)`. Consistent behavior regardless of tap target; no split-action needed.

**4. Icon container: `BoxShape.circle`**
Snapshot shows a perfect circle, not a rounded square. Switch from `BorderRadius.circular(12)` to `BoxShape.circle` on the container `BoxDecoration`.

**5. String constants updated in place**
`app_strings.dart` delegates to localizations. Update `chatWithYourMla` → "MLA Office Support" and `chatWithYourMlaSubtitle` → "Message the constituency office directly." in `app_localizations_en.dart` (and `app_localizations_ml.dart` equivalent).

## Risks / Trade-offs

- [String change visible app-wide] → Only profile view uses these strings (confirmed by grep), so no unintended visible change elsewhere.
- [Icon legibility at 44px] → `account_balance_rounded` at 22px inside a 44px circle is the same size as current; tested pattern in other parts of app.

## Migration Plan

No migration needed — UI-only change, no data or schema impact. Deploy with normal app release.

## Open Questions

None.
