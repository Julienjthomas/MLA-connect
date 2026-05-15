## Context

`MlaHeroBanner` is a fixed-height (160px) card with a 110×128px photo stack (arc painter, dot grid, gradient blob), 20sp name, accent underline, and a two-line tagline. `HomeView` shows a 130px loading placeholder while MLA data loads. Product feedback: the banner dominates the home viewport (~⅓ on common phones) and should read as a small identity strip, not a hero section.

Existing specs (`shell-navigation`) require photo + name only on the home banner but do not cap vertical footprint. MLA detail retains the full collapsing hero.

## Goals / Non-Goals

**Goals:**

- Reduce home MLA banner to a compact horizontal strip (~72–88px total height including margins).
- Preserve tap → MLA detail, photo, and full name (single line with ellipsis).
- Keep visual continuity with app palette (light lavender surface, primary accent) at smaller scale.
- Match loading placeholder height to the compact banner.

**Non-Goals:**

- Redesigning MLA detail hero, quick actions, updates feed, or app bar.
- Removing MLA branding entirely or hiding the banner when data is loaded.
- Changing MLA data APIs or navigation routes.

## Decisions

1. **Compact row layout (not mini-card with tagline)**  
   Use a single horizontal row: small circular avatar (48–56px) + name. Drop the home tagline and decorative underline to save height.  
   *Alternative:* keep tagline below name — rejected; adds ~32px and defeats “very small.”

2. **Target dimensions**  
   - Container height: **80px** (clamp 72–88 if needed for text scale).  
   - Horizontal padding: 12px; corner radius: 14px.  
   - Avatar: 48px circle (no separate 110×128 stack).  
   - Name: **15sp**, `FontWeight.w700`, `maxLines: 1`.  
   *Alternative:* avatar-only chip — rejected; name is required by `shell-navigation`.

3. **Simplify decoration**  
   Remove `_DotGrid`, gradient blob, and `_ArcPainter` from the home banner (or gate behind a `compact: true` constructor). Detail page keeps rich treatment.  
   *Alternative:* scale decorations proportionally — rejected; still reads busy at 80px.

4. **Shared constant for height**  
   Add `MlaHeroBanner.compactHeight` (or `kCompactMlaBannerHeight`) used by both the widget and `HomeView` loading placeholder to avoid drift.

5. **Viewport budget**  
   Quick actions now use intrinsic height; no dynamic grid math in `home_view.dart`. Document ~80px hero reserve in `responsive-action-grid` delta for any future budget logic and for QA expectations (more room above Updates).

## Risks / Trade-offs

- **[Risk] Long MLA names truncate** → Single-line ellipsis; full name on detail page.  
- **[Risk] Less “premium” feel on home** → Acceptable trade-off; detail page retains rich hero.  
- **[Risk] Text scale > 1.3 overflows 80px** → Allow height to grow slightly (max ~96px) or reduce padding; test with accessibility settings.

## Migration Plan

Single Flutter UI change; no migrations. Ship in next app release. Rollback: revert `mla_hero_banner.dart` and placeholder height.

## Open Questions

- None blocking; constituency subtitle on home remains out of scope per `shell-navigation`.
