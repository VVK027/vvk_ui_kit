# VVK UI Kit

A feature-rich Flutter UI kit built to speed up app development with Material 3 theming, reusable widgets, shimmer loaders, SVG icons, unified image handling, navigation helpers, responsive layout utilities, glass surfaces, product tours, and full light/dark theme support. All public APIs are exported through `package:vvk_ui_kit/vvk_ui_kit.dart`.

See [doc/IMPLEMENTATION_GUIDE.md](doc/IMPLEMENTATION_GUIDE.md) for integration patterns, composition conventions, and migration notes.

## Features

- **Theming** — `UIAppTheme` with semantic color tokens (`UIThemePalette`, `UIThemeExtension`, `UIMetrics`) and built-in light/dark presets (teal, zinc, slate, stone).
- **Buttons** — `UIStyledButton` with variants, plus primary/elevated/icon/image buttons, `UIGradientButton`, `UISliderButton`, `UISplitButton`, `UIGlassButton`, and `UISocialAuthButton`.
- **Accordion, cards & clips** — expansion accordions, `UICard`, `UIAnimatedFlipCard`, `UIHexagon`, `UISharpCorners`, `UITicketClip`, `UICouponClip`, `UICouponCard`.
- **Carousel** — `UICarouselWithIndicator`, `UISectionCarousel`, `UICarouselControls`, nav buttons, and page indicators.
- **Decoration & glass** — gradient widgets, dotted borders, corner ribbons, and frosted `UIGlassSurface` / `UIGlassCard` / `UIGlassScaffold` family.
- **Display & rating** — stat cards, banners, progress bars, `UICommandBar`, `UIAnimatedCounter`, `UITextAvatar`, `UIStackBadge`, `UITimerBuilder`, and `UIRatingBar`.
- **Dialogs** — shell dialogs, adaptive alert/action sheets, Cupertino sheets, image picker, and bottom sheets.
- **Feedback** — snackbars, badges, empty states, tooltips, `UIPopover`, and guided `UITourController` with spotlight overlay.
- **Forms & inputs** — form fields, `UIForm`, dropdowns, `UISearchBar`, `UITagInput`, `UINumberField`, `UIColorPicker`, OTP, sliders, calendar/date/time pickers, and settings tiles.
- **Layout & responsive** — dividers, separated rows/columns, `UIPageScaffold`, `UIExpandableFloatingPanel`, `UIDynamicOverflow`, keyboard toolbar, `Responsive` helpers.
- **Lists** — `UISwipeActionTile` with custom drag actions.
- **Loading** — shimmer containers, overlays, page loading, and load-more helpers.
- **Media** — `UIImage` for assets, network, SVG, and base64 via `UIImageScope`.
- **Navigation** — app bars, side menu, bottom bars (`UIBottomNavyBar`, `UIFloatingBottomBar`, `UIGlassBottomNavBar`), `UIMenuBar`, `UITreeView`, settings scaffolds, breadcrumbs.
- **Selection & states** — list tile select, pill switch, rounded checkbox, radio groups, error states.
- **Tabs** — `UITabBar`, `UISegmentedTabBar`, `UIButtonsTab`.
- **Text & icons** — `UIText`, rich/read-more/marquee text, SVG rendering, social auth icons, and text helpers.
- **Utilities** — `NavigationUtil`, `DialogUtil`, `DateTimeUtil`, `JsonUtils`, `JsonHelper`, `Mapper`, `Translations`, `TranslationCache`, and Dart extensions.

## Getting started

### Example app

Browse every widget and utility in the interactive catalog:

```bash
cd example
flutter run
```

Showcase sections: Core utilities, Buttons, Animation, Accordion/cards/clips, Carousel, Decoration, Display, Rating, Dialogs, Feedback, Inputs, Layout & responsive, Loading, Media, Navigation, Selection & states, Tabs, and Text & icons.

### Installation

```yaml
dependencies:
  vvk_ui_kit: ^1.0.0
```

### Theme setup

```dart
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

MaterialApp(
  theme: UIAppTheme.light,
  darkTheme: UIAppTheme.dark,
  themeMode: ThemeMode.system,
  home: const HomeScreen(),
)
```

Use `UIAppTheme.custom` when you need a custom `UIThemeColors` palette while keeping kit component styling.

### Image scope (optional)

Wrap your app with `UIImageScope` for custom network/SVG builders (`cached_network_image`, `flutter_svg`, etc.). Without it, `UIImage` uses Flutter's built-in network loader and the kit's lightweight `UISvgImage` renderer.

## Usage examples

### Buttons

```dart
UIStyledButton(
  style: UIStyledButtonStyle.primary(context),
  onPressed: () {},
  child: const Text('Get Started'),
)

UISplitButton.fromTheme(
  context,
  label: 'Save',
  onPressed: save,
  menuItems: [UISplitButtonMenuItem(label: 'Discard', onTap: discard)],
)
```

### Glass surfaces

```dart
UIGlassCard.fromTheme(
  context,
  child: const Padding(
    padding: EdgeInsets.all(16),
    child: Text('Frosted card'),
  ),
)
```

### Product tour

```dart
final tour = UITourController(
  steps: [
    UITourStep(
      targetKey: _fabKey,
      title: 'Quick actions',
      description: 'Tap here to create a new item.',
    ),
  ],
);
```

### Forms

```dart
UIForm(
  child: Column(
    children: [
      UIFormTextField(name: 'email', label: 'Email'),
      UISearchBar.fromTheme(context, hintText: 'Search…', onChanged: filter),
      UIFormCheckboxField(name: 'terms', label: 'Accept terms'),
    ],
  ),
)
```

### Navigation

```dart
NavigationUtil.pushPage(context, const ProfileScreen());
```

## Testing

The package includes a comprehensive widget test suite. Run all tests from the package root:

```bash
flutter test
```

Tests are organized under `test/` by category — buttons, inputs, dialogs, feedback, glass, navigation, loading, media, and more — mirroring the public widget groups in `lib/vvk_ui_kit.dart`. As of 1.0.0, the suite covers **301 tests** across **30 test files**.

## Component overview

| Category | Key components |
| :--- | :--- |
| **Theming** | `UIAppTheme`, `UIThemePalette`, `UIThemeExtension`, `UIMetrics` |
| **Buttons** | `UIStyledButton`, `UISplitButton`, `UIGlassButton`, `UISocialAuthButton` |
| **Cards & clips** | `UICard`, `UIAnimatedFlipCard`, `UICouponCard`, `UITicketClip` |
| **Glass** | `UIGlassSurface`, `UIGlassCard`, `UIGlassScaffold`, `UIGlassAppBar` |
| **Display & rating** | `UICommandBar`, `UIAnimatedCounter`, `UIRatingBar`, `UITextAvatar` |
| **Feedback** | `UITourController`, `UIPopover`, `UIBadge`, `UISkeletonPlaceholder` |
| **Dialogs** | `showUIAdaptiveAlertDialog`, `showUIAdaptiveActionSheet`, `showUISheet` |
| **Inputs** | `UISearchBar`, `UITagInput`, `UINumberField`, `UIColorPicker`, `UIForm` |
| **Layout** | `UIPageScaffold`, `UISeparatedRow`, `UIExpandableFloatingPanel` |
| **Navigation** | `UIBottomNavyBar`, `UIMenuBar`, `UITreeView`, `UIDoubleBackToExit` |
| **Lists** | `UISwipeActionTile` |
| **Utilities** | `NavigationUtil`, `JsonUtils`, `JsonHelper`, `Mapper`, `Translations` |

## Public API

All public symbols are exported from `package:vvk_ui_kit/vvk_ui_kit.dart`. Internal helpers under `lib/src/` are not part of the stable API.

See [doc/IMPLEMENTATION_GUIDE.md](doc/IMPLEMENTATION_GUIDE.md) for detailed integration guidance.

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
