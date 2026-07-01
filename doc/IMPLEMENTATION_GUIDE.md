# Implementation Guide

This guide explains how to integrate `vvk_ui_kit` into a host Flutter app or package.

## Installation

```yaml
dependencies:
  vvk_ui_kit: ^1.0.0
```

```dart
import 'package:vvk_ui_kit/vvk_ui_kit.dart';
```

Do **not** import files under `lib/src/` directly — those paths are internal and may change.

## Theme setup

```dart
MaterialApp(
  theme: UIAppTheme.light,
  darkTheme: UIAppTheme.dark,
  themeMode: ThemeMode.system,
  home: const HomeScreen(),
)
```

Access semantic tokens via `context.uiTheme` or `Theme.of(context).extension<UIThemeExtension>()`.

The `UITypography` class provides a consistent type scale (`h1`, `h2`, `h3`, `h4`, `body`, `small`, etc.) that uses the kit's semantic colors.

Glass widgets read blur/tint values from `UIGlassTheme` / `UIGlassTheme.of(context)`.

## Optional: image scope

Wrap your app in `UIImageScope` when using `cached_network_image` or `flutter_svg` for production image loading.

## Widget composition patterns

### Buttons

`UIStyledButton` is the canonical button. Convenience wrappers delegate to shared internal helpers (`ui_button_helpers.dart`).

- `UISplitButton` — primary action + overflow menu via `UIContextMenuItem`
- `UIGlassButton` — frosted button built on `UIGlassSurface`
- `UISocialAuthButton` — bundled OAuth SVG icons via `UISocialAuthAssets`

### Labeled fields & forms

- `UILabeledField` — generic label wrapper
- `UITextFormField` — labeled field with formatters (`trimLeadingSpace`, `disallowSpaces`)
- `UIForm` — named field tracking with `UIFormTextField`, date/time/textarea/checkbox fields

### Input widgets

| Widget | Use when |
| :--- | :--- |
| `UISearchBar` | Themed search field with sort/filter affordances |
| `UITagInput` | Chip-based multi-value text input |
| `UINumberField` | Numeric entry with stepper controls |
| `UIColorPicker` | HSV/spectrum color selection |
| `UIHierarchySearchableDropdown` | Searchable tree dropdown for hierarchical data |
| `UIInputOTP` | One-time password / verification code entry |
| `UICalendar` / `UIDatePickerField` / `UITimePickerField` | Date and time selection |

### Layout

- `UISeparatedRow` / `UISeparatedColumn` — insert separators between children
- `UIPageScaffold` — centered max-width page with `UIScrollableScreen`
- `UIDynamicOverflow` — toolbar overflow (used by `UICommandBar`)
- `UIExpandableFloatingPanel` — collapsible FAB-style action panel
- `UIPortal` — overlay portal host (used by `UIPopover`)
- `UIKeyboardToolbar` — accessory toolbar above the keyboard

### Clips & cards

- `UITicketClip` — circular edge notches (ticket/coupon stub)
- `UICouponClip` / `UICouponCard` — curved tear-line coupon shape
- `UIAnimatedFlipCard` — 3D flip animation between front/back faces

### Glass family

All glass widgets compose on `UIGlassSurface`:

```
UIGlassSurface → UIGlassCard, UIGlassButton, UIGlassAppBar, UIGlassBottomNavBar, UIGlassScaffold
```

Apply a gradient or image behind glass surfaces for best visual effect.

### Feedback & tours

- `UIPopover` — anchored popover with arrow (uses `UIPortal`)
- `UITourController` — multi-step product tour with `UISpotlightOverlay` and tooltip card
- `UIBadge` / `UILiveBadge` — prefer `UIBadge.live` over the `UILiveBadge` wrapper when possible

### Dialogs & sheets

| API | Platform behavior |
| :--- | :--- |
| `showUIAdaptiveAlertDialog` | Cupertino on iOS/macOS, Material elsewhere |
| `showUIAdaptiveActionSheet` | Cupertino sheet or Material bottom sheet |
| `showUICupertinoActionSheet` | Force Cupertino style |
| `showUISheet` | Material bottom sheet with kit styling |

Platform selection is centralized in `useAdaptiveCupertino()` (internal).

### Navigation

- `UIBottomNavyBar` — expanding pill bottom nav
- `UIFloatingBottomBar` — center FAB bottom bar
- `UIGlassBottomNavBar` — frosted tab bar
- `UIMenuBar` — desktop-style menu bar with flyouts
- `UITreeView` — hierarchical expand/select tree
- `UIDoubleBackToExit` — Android-style double-back confirmation
- `UIPageRoute` — custom page transitions (`UIEntrancePageTransition`, `UIDrillInPageTransition`, `UIHorizontalSlidePageTransition`)

### Lists

`UISwipeActionTile` — custom swipe-to-reveal actions with drag animation.

## Social auth icons

Bundled at `packages/vvk_ui_kit/assets/icons/social/`. Use `UISocialAuthProvider` with `UISocialAuthButton` or `UISocialAuthIcon`.

## Extensions & Utilities

The package provides a set of extensions and utilities to simplify common tasks.

### Extensions

- **String**: `isEmail`, `isUrl`, `capitalize`, `toCamelCase`, `toSnakeCase`, etc.
- **Color**: `darken`, `lighten`, `toHex`, `withOpacity`, etc.
- **Iterable/List**: `groupBy`, `distinctBy`, `firstOrNull`, etc.
- **Numbers**: `toCurrency`, `toFileSize`, `toPercentage`.
- **Context**: `context.uiTheme`, `context.isDarkMode`, `context.screenWidth`, `context.mediaQuery`.

### Utilities

- **NavigationUtil**: Simplified navigation with `pushPage`, `pushReplacement`, `pop`, and named routes support.
- **DialogUtil**: Easy access to show adaptive dialogs and sheets.
- **DateTimeUtil**: Helpers for formatting dates, calculating time differences, and handling timezones.
- **JsonUtils**: Safe JSON parsing and type conversion.
- **SystemUIUtils**: Manage status bar and navigation bar styles.

## Best Practices

1. **Theme Consistency**: Always use `UIAppTheme` as your base. Avoid hardcoding colors; use `context.uiTheme.colors` or semantic tokens.
2. **Component Composition**: Prefer using the provided widgets like `UIPageScaffold` and `UICard` to maintain a consistent look and feel across the app.
3. **Adaptive UI**: Use `showUIAdaptiveAlertDialog` and `showUIAdaptiveActionSheet` to ensure your app feels native on both iOS and Android.
4. **Image Handling**: Use `UIImage` for all your image needs and wrap your app in `UIImageScope` to provide custom network and SVG loaders.
5. **Debouncing Taps**: Wrap critical buttons in `UITapGuard` to prevent accidental multiple triggers.
6. **Responsive Design**: Use `ResponsiveLayout` and `context.screenWidth` extensions to handle different screen sizes gracefully.

## JSON, mapping & translations

```dart
// JSON coercion
JsonUtils.asInt(payload['count']);

// DTO contract
class UserDto implements JsonHelper { ... }

// Domain mapping
class UserMapper implements Mapper<UserEntity> { ... }

// Simple i18n
final t = Translations({'welcome': 'Welcome, {name}!'});
t.tr('welcome', namedArgs: {'name': 'Ada'});

// ARB preload (host app must ship assets/translations/{locale}.arb)
await TranslationCache.preload(['en', 'es']);
```

## Testing

Run the full test suite from the package root:

```bash
flutter test
```

Tests live under `test/` and mirror the widget categories in `lib/vvk_ui_kit.dart`:

| Test directory | Coverage |
| :--- | :--- |
| `test/core/` | Extensions, theme, `NavigationUtil`, `DialogUtil`, `JsonUtils`, `Translations`, widget helpers |
| `test/icons/` | SVG path parser, `UISvgImage`, `UISvgAssetIcon`, `UISocialAuthIcon` |
| `test/widgets/buttons/` | All button variants including split, glass, slider, and social auth |
| `test/widgets/inputs/` | Form fields, dropdowns, search, tags, number, color, OTP, calendar, settings tiles |
| `test/widgets/dialogs/` | Adaptive dialogs, shell dialogs, sheets, image picker |
| `test/widgets/feedback/` | Badges, snackbars, empty state, popover, product tour |
| `test/widgets/navigation/` | App bars, bottom bars, menu bar, tree view, breadcrumbs, scaffolds |
| `test/widgets/layout/` | Dividers, page scaffold, expandable panel, portal, glass scaffold |
| `test/widgets/loading/` | Shimmer, overlays, load-more container |
| `test/widgets/display/` | Stat cards, banners, command bar, progress, animated counter |
| `test/widgets/decoration/` | Gradients, dotted border, corner ribbon, glass surface |
| `test/widgets/cards/` | `UICard`, `UIGlassCard`, `UIAnimatedFlipCard` |
| `test/widgets/clips/` | Ticket/coupon clips, hexagon, sharp corners |
| `test/widgets/carousel/` | Carousels with indicators and controls |
| `test/widgets/accordion/` | Expansion tile and accord |
| `test/widgets/selection/` | List tile select, pill switch, radio group, checkbox |
| `test/widgets/tabs/` | Tab bar, segmented tab bar, buttons tab |
| `test/widgets/text/` | Text, rich text, read-more, marquee |
| `test/widgets/media/` | `UIImage`, `UIImageScope`, preview frame |
| `test/widgets/rating/` | Rating bar and indicator |
| `test/widgets/lists/` | Swipe action tile |
| `test/widgets/anim/` | Tap guard, entrance animations, gesture detector |
| `test/widgets/responsive/` | `ResponsiveLayout`, `Responsive` |
| `test/widgets/states/` | Error info |

As of 1.0.0 the suite includes **301 tests** across **30 test files**.

## Example app

```bash
cd example
flutter run
```

Each showcase section in `example/lib/showcase/` maps to a category in `lib/vvk_ui_kit.dart`.

## Package structure

| Path | Purpose |
| :--- | :--- |
| `lib/vvk_ui_kit.dart` | Public barrel export |
| `lib/src/core/` | Theme, extensions, utilities |
| `lib/src/icons/` | SVG rendering and social icons |
| `lib/src/widgets/` | UI components by category |
| `assets/icons/social/` | Bundled OAuth brand SVGs |
| `test/` | Widget and unit tests by category |

### Internal-only (not exported)

`ui_button_helpers.dart`, `ui_rating_layout.dart`, `ui_svg_network_loader*.dart`, `log_util.dart`, `adaptive_platform_util.dart`

## Stable public API (1.0.0)

Version 1.0.0 marks the first stable release. The full public surface includes theming, buttons, accordion/cards/clips, carousel, decoration, glass, display, rating, dialogs, feedback, inputs, layout, lists, loading, media, navigation, selection, states, tabs, text, icons, animation helpers, and core utilities — all exported from `vvk_ui_kit.dart`.
