# Migration Guide

How to upgrade between `vvk_ui_kit` versions and adopt new APIs.

## 1.3.x → 1.4.x

### DWM tab helpers (non-breaking)

Day / Week / Month tab utilities are now part of the public API:

```dart
import 'package:vvk_ui_kit/tabs.dart'; // or vvk_ui_kit.dart

final tabs = buildDwmTabs(dayLabel: 'Day', weekLabel: 'Week', monthLabel: 'Month');
final tabBar = buildDwmTabBar(context, tabs: tabs);
```

Remove any local copies of these helpers from host apps.

### `UILoadingOverlay.scoped` (non-breaking)

For blocking overlays without underlying content:

```dart
UILoadingOverlay.scoped(
  visible: isLoading,
  message: 'Please wait…',
)
```

### Dark theme contrast (behavior fix)

`buildUIKitTheme` now derives `onPrimary` / `onSecondary` from accent luminance
instead of reusing `textPrimary` in dark mode. Primary buttons and FABs should
meet WCAG contrast expectations without per-app overrides.

### API naming consistency (non-breaking deprecations)

| Deprecated | Replacement | Removed in |
|------------|-------------|------------|
| `SegmentOrder` | `UISegmentOrder` | 2.0.0 |
| `BatteryIndicatorStyle` | `UIBatteryIndicatorStyle` | 2.0.0 |
| `settingsMaterialIconLeading` | `UISettingsTiles.materialIconLeading` | 2.0.0 |

### App bar typedefs (non-breaking)

```dart
UIAppBar.accent(title: 'Details', accentColor: color); // preferred
// UIAccentAppBar is a typedef alias for discoverability
```

---

## Migrating from `flutter_ui_kit`

If you previously used the older `flutter_ui_kit` package (unprefixed widget
names and product-specific theme types), adopt these replacements:

| Old (`flutter_ui_kit`) | New (`vvk_ui_kit`) |
|------------------------|-------------------|
| `BandFitTheme` / `AppTheme` wrapper | `UIAppTheme` |
| `BandFitColors` | `UIThemePalette` or app `ThemeExtension` via `extraExtensions` |
| `BandFitThemeExtension` | `UIThemeExtension` / `context.uiTheme` |
| `StatusBanner` | `UIStatusBanner` |
| `LoadingOverlay` | `UILoadingOverlay` |
| `ScopedLoadingOverlay` | `UILoadingOverlay.scoped` |
| `AccentAppBar` / `BrandAppBar` | `UIAppBar.accent` / `UIAppBar.brand` |
| `buildDwmTabs` (local copy) | `buildDwmTabs` from `package:vvk_ui_kit/tabs.dart` |
| `convertBandReadableCalender` | `DateTimeUtil.convertDateTimeYearMonthDay` |
| `parseBandReadableCalender` | `DateTimeUtil.parseCalenderToDateTime` |

Host apps should keep product-specific wrappers (e.g. `VitalStatCard`) in the
app layer — do not expect domain widgets in the kit. See
[IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md#host-app-adapters).

---

## 1.1.x → 1.2.x

### `buildUIKitTheme` picks the extension by brightness (behavior fix)

`buildUIKitTheme`'s `extension` parameter is now optional. When omitted it
resolves to `UIThemeExtension.dark` for dark themes and `UIThemeExtension.light`
otherwise. If you called `buildUIKitTheme(brightness: Brightness.dark, ...)`
without passing `extension`, dark themes now correctly use the dark surface /
chart tokens instead of the light ones. Pass `extension:` explicitly to keep the
old value.

### Register app tokens with `extraExtensions` (non-breaking)

```dart
// Before
final base = buildUIKitTheme(brightness: brightness, colors: appColors);
final theme = base.copyWith(extensions: [...base.extensions.values, appColors]);

// After
final theme = buildUIKitTheme(
  brightness: brightness,
  colors: appColors,
  extraExtensions: [appColors],
);
```

Also available on `UIAppTheme.custom(..., extraExtensions: [...])` and
`UIAppTheme.fromSeed(..., extraExtensions: [...])`.

### Theme-first carousels (non-breaking)

```dart
// Derive controls colors from the theme instead of wiring each field.
UISectionCarousel.fromTheme(context, pageCount: n, pageHeight: h, pageBuilder: ...);
// or
UICarouselControls(colors: UICarouselControlsColors.fromTheme(context), ...);
```

### `imagePreviewImage` signature (breaking)

`imagePreviewImage` is now routed through `UIImage` and no longer accepts
`cacheWidth` / `cacheHeight` — cache dimensions are derived automatically. Its
color parameters (and those of `UIImagePreviewFrame` / `imagePreviewPlaceholder`)
are now optional and resolve from the theme when omitted. Remove any
`cacheWidth:` / `cacheHeight:` arguments at call sites.

---

## 1.0.x → 1.1.x

### Minimum Flutter version

The `flutter` constraint is now `>=3.32.0` (matching the required Dart SDK
`^3.8.0`). This reflects the real minimum — the kit already relied on APIs such
as `Color.withValues` and `CardThemeData`. Upgrade Flutter if you are on an
older channel.

### Seed-based and high-contrast theming (non-breaking additions)

```dart
// Generate a full palette from one brand color.
theme: UIAppTheme.fromSeed(const Color(0xFF6750A4)),
darkTheme: UIAppTheme.fromSeed(const Color(0xFF6750A4), brightness: Brightness.dark),

// Or opt into high-contrast accessibility palettes.
theme: UIAppTheme.highContrast(Brightness.light),
darkTheme: UIAppTheme.highContrast(Brightness.dark),
```

No changes are required to existing themes.

### Modular imports (non-breaking)

You can keep using the full barrel:

```dart
import 'package:vvk_ui_kit/vvk_ui_kit.dart';
```

Or import focused entry points:

```dart
import 'package:vvk_ui_kit/theme.dart';
import 'package:vvk_ui_kit/buttons.dart';
import 'package:vvk_ui_kit/inputs.dart';
```

No code changes required when staying on the main barrel.

### Test asset path (package maintainers only)

If you forked tests that referenced `test/assets/sample.svg`, use a published asset instead:

```dart
import '../test_assets.dart'; // kTestSvgAsset
```

---

## Deprecated APIs (remove in 2.0.0)

| Deprecated | Replacement | Since |
|------------|-------------|-------|
| `UIExpansionAccordTile` | `UIExpansionTile` | 0.0.4 |
| `UIAppBar.primary` | `UIAppBar.accent` | 0.0.3 |
| `UIAppBar.secondary` | `UIAppBar.brand` | 0.0.3 |
| `UICustomMessageDialog.show` | `UICustomMessageDialog.simple` | 0.0.3 |
| `StringUtils.removeTrailingDot` | `StringUtils.removeTrailingDots` | 0.0.2 |
| `SegmentOrder` | `UISegmentOrder` | 1.4.0 |
| `BatteryIndicatorStyle` | `UIBatteryIndicatorStyle` | 1.4.0 |
| `settingsMaterialIconLeading` | `UISettingsTiles.materialIconLeading` | 1.4.0 |

Search your codebase:

```bash
rg "UIExpansionAccordTile|UIAppBar\.primary|UIAppBar\.secondary|UICustomMessageDialog\.show|removeTrailingDot" lib/
```

---

## Theming migration

### From raw Material `ThemeData`

```dart
// Before
MaterialApp(theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)))

// After
MaterialApp(
  theme: UIAppTheme.light,
  darkTheme: UIAppTheme.dark,
)
```

### Custom brand colors

```dart
MaterialApp(
  theme: UIAppTheme.custom(
    brightness: Brightness.light,
    colors: UIThemePalette(
      scaffold: Color(0xFFF8FAFC),
      surface: Colors.white,
      // ... all UIThemeColors fields
    ),
  ),
)
```

Access semantic tokens in widgets:

```dart
final colors = Theme.of(context).extension<UIThemeExtension>();
// or
context.uiTheme
```

---

## Image loading migration

### Before (default network + built-in SVG)

```dart
UIImage('https://cdn.example.com/photo.png')
```

### After (recommended for production)

Wrap your app once:

```dart
UIImageScope(
  networkImageBuilder: (context, url, {width, height, fit}) =>
      CachedNetworkImage(imageUrl: url, width: width, height: height, fit: fit),
  svgBuilder: (context, asset, {width, height, color}) =>
      SvgPicture.asset(asset, width: width, height: height, colorFilter: ...),
  child: MaterialApp(...),
)
```

See [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md#optional-image-scope).

---

## Design token overrides (non-breaking)

Per-variant button metrics, input metrics, and glass metrics are now theme
extensions, so you can restyle every widget from the theme:

```dart
UIAppTheme.custom(
  brightness: Brightness.light,
  colors: myColors,
).copyWith(
  extensions: [
    const UIButtonMetrics(primaryHeight: 52, primaryRadius: 12),
    const UIGlassMetrics(performanceMode: UIGlassPerformanceMode.staticTint),
  ],
);
```

`UIStyledButtonStyle.primary/outlined/elevated/text` and `UIGlassSurface` read
these tokens when the corresponding parameter is left unset, so existing call
sites are unaffected.

For low-end devices, set `UIGlassMetrics.performanceMode` to
`UIGlassPerformanceMode.staticTint` to swap the live `BackdropFilter` blur for a
cheaper solid tint. Keep to **one glass layer per screen** for best performance.

---

## Reporting migration pain

Open an issue with the `migration` label: https://github.com/VVK027/vvk_ui_kit/issues/new
