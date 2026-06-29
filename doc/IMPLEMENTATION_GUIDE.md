# Implementation Guide

This guide explains how to integrate `vvk_ui_kit` into a host Flutter app or package.

## Installation

```yaml
dependencies:
  vvk_ui_kit: ^0.0.2
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

### New input widgets

| Widget | Use when |
| :--- | :--- |
| `UISearchBar` | Themed search field with sort/filter affordances |
| `UITagInput` | Chip-based multi-value text input |
| `UINumberField` | Numeric entry with stepper controls |
| `UIColorPicker` | HSV/spectrum color selection |

### Layout

- `UISeparatedRow` / `UISeparatedColumn` — insert separators between children
- `UIPageScaffold` — centered max-width page with `UIScrollableScreen`
- `UIDynamicOverflow` — toolbar overflow (used by `UICommandBar`)
- `UIExpandableFloatingPanel` — collapsible FAB-style action panel

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

### Lists

`UISwipeActionTile` — custom swipe-to-reveal actions with drag animation.

## Social auth icons

Bundled at `packages/vvk_ui_kit/assets/icons/social/`. Use `UISocialAuthProvider` with `UISocialAuthButton` or `UISocialAuthIcon`.

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

### Internal-only (not exported)

`ui_button_helpers.dart`, `ui_rating_layout.dart`, `ui_svg_network_loader*.dart`, `log_util.dart`, `adaptive_platform_util.dart`

## Public API additions (0.0.2)

Glass, tour, coupon clips, adaptive dialogs, split button, command bar, search/tag/number/color inputs, swipe tiles, tree view, menu bar, bottom bars, page scaffold, expandable panel, animated flip card, popover, and page transitions.
