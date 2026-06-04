## ADDED Requirements

### Requirement: Horizontal pixel values use .w extension
All hardcoded horizontal pixel values in widget build methods SHALL be suffixed with `.w` (ScreenUtil width extension). This includes: explicit `width:` parameters on `SizedBox`, `Container`, `Row` children sizing, and the horizontal component of `EdgeInsets`.

#### Scenario: SizedBox horizontal spacing
- **WHEN** a `SizedBox` specifies a `width` with a raw number (e.g., `SizedBox(width: 8)`)
- **THEN** the value MUST be replaced with the `.w` extension (e.g., `SizedBox(width: 8.w)`)

#### Scenario: Horizontal padding
- **WHEN** `EdgeInsets.symmetric` specifies `horizontal:` with a raw number
- **THEN** the value MUST be replaced with `.w` (e.g., `EdgeInsets.symmetric(horizontal: 16.w)`)

#### Scenario: Container explicit width
- **WHEN** a `Container` or `SizedBox` specifies `width:` with a raw number
- **THEN** the value MUST be replaced with `.w`

### Requirement: Vertical pixel values use .h extension
All hardcoded vertical pixel values in widget build methods SHALL be suffixed with `.h` (ScreenUtil height extension). This includes: explicit `height:` parameters on `SizedBox`, `Container`, and the vertical component of `EdgeInsets`.

#### Scenario: SizedBox vertical spacing
- **WHEN** a `SizedBox` specifies a `height` with a raw number (e.g., `SizedBox(height: 24)`)
- **THEN** the value MUST be replaced with `.h` (e.g., `SizedBox(height: 24.h)`)

#### Scenario: Vertical padding
- **WHEN** `EdgeInsets.symmetric` specifies `vertical:` with a raw number
- **THEN** the value MUST be replaced with `.h`

### Requirement: Font sizes use .sp extension
All hardcoded `fontSize` values in `TextStyle` declarations within widget build methods SHALL be suffixed with `.sp` (ScreenUtil scaled pixel extension).

#### Scenario: Inline TextStyle fontSize
- **WHEN** a `TextStyle` contains `fontSize:` with a raw number (e.g., `fontSize: 14`)
- **THEN** the value MUST be replaced with `.sp` (e.g., `fontSize: 14.sp`)

### Requirement: Radii and icon sizes use .r extension
All `BorderRadius.circular()` values, icon `size:` values, and uniform square container dimensions SHALL use the `.r` extension. Uniform `EdgeInsets.all()` values SHALL also use `.r`.

#### Scenario: BorderRadius
- **WHEN** `BorderRadius.circular()` contains a raw number (e.g., `BorderRadius.circular(12)`)
- **THEN** the value MUST be replaced with `.r` (e.g., `BorderRadius.circular(12.r)`)

#### Scenario: Icon size
- **WHEN** an `Icon` widget or similar specifies `size:` with a raw number
- **THEN** the value MUST be replaced with `.r`

#### Scenario: Square container dimensions
- **WHEN** a widget sets equal `width:` and `height:` (e.g., an avatar container of `44×44`)
- **THEN** both values MUST use `.r` to keep the square proportional

#### Scenario: Uniform padding
- **WHEN** `EdgeInsets.all()` contains a raw number
- **THEN** the value MUST be replaced with `.r`

### Requirement: Non-spatial values remain unchanged
Values that are not spatial pixel measurements SHALL NOT be converted to ScreenUtil extensions.

#### Scenario: double.infinity unchanged
- **WHEN** a dimension is `double.infinity`
- **THEN** it MUST remain `double.infinity` with no ScreenUtil extension

#### Scenario: BoxShadow offsets and blur unchanged
- **WHEN** a `BoxShadow` specifies `blurRadius`, `spreadRadius`, or `Offset` components
- **THEN** those values MUST remain as raw numbers

#### Scenario: Opacity and ratio values unchanged
- **WHEN** a value represents opacity (e.g., `alpha: 0.04`), letter spacing, or other non-pixel ratio
- **THEN** it MUST remain as a raw number

### Requirement: ScreenUtil import present in all migrated files
Every file that uses any ScreenUtil extension (`.w`, `.h`, `.sp`, `.r`, `.sw`, `.sh`) SHALL contain the import `package:flutter_screenutil/flutter_screenutil.dart`.

#### Scenario: Import added when extensions used
- **WHEN** a file gains one or more ScreenUtil extension usages
- **THEN** `import 'package:flutter_screenutil/flutter_screenutil.dart';` MUST appear in its import block

#### Scenario: No duplicate imports
- **WHEN** a file already contains the ScreenUtil import
- **THEN** the import MUST NOT be duplicated
