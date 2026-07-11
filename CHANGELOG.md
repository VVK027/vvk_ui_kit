## 1.3.0

* **`TranslationCache.translationsFor(locale)`** — returns a ready-to-use
  [Translations] instance from the cache (reduces `get` + `Translations(map)`
  boilerplate in Riverpod providers).
* **`TranslationCache.preload` path customization** — restored/fixed:
  `pathBuilder`, `basePath`, `assetPrefix`, and `fileExtension` parameters
  (plus docs clarifying `TranslationCache._()` is the static-only guard).
* **`DialogUtil.showAnchoredPopup`** — lightweight popup anchored at an
  `Offset` (transparent barrier, configurable elevation/radius/alignment) for
  menus and pickers positioned relative to a tapped widget.
* **`UIThemeTokens` `ThemeExtension`** — typed extended color slots (app-bar
  background, gradient, selected/unselected, status colors, text colors) plus
  an `extra` map for arbitrary named colors, with `ThemeData.withThemeTokens(...)`
  / `ThemeData.themeTokens` helpers so apps can attach a custom palette to the
  theme beyond [ColorScheme]. (Introduced as `UIBrandTokens` during 1.3.0
  development; renamed before release.)
* **`UIInputFormatters`** — ready-made `TextInputFormatter`s (`name`,
  `alphanumeric`, `phone`, `phoneWithCountryCode`, `denySpecialChars`,
  `decimal(...)`).
* **`UIImage.allowExtensionlessUrl`** — opt-in flag to treat network URLs
  without a recognized image extension (API/CDN URLs) as raster images.
* **`LogUtil` is now exported** — the debug logger (`logDefaultMsg`, `logMsg`)
  is part of the public API instead of an internal-only utility.

## 1.2.0

* **Theme-aware carousels** — `UICarouselControlsColors.fromTheme(context)`
  derives nav/indicator colors from the ambient `Theme`, and
  `UISectionCarousel.fromTheme(context, ...)` applies them automatically, so
  carousels match the rest of the kit's theme-first widgets in light and dark
  mode.
* **`buildUIKitTheme` extension auto-selection (fix)** — when `extension` is
  omitted, the matching `UIThemeExtension` (light/dark) is now chosen from
  `brightness`. Previously dark themes built via `buildUIKitTheme` inherited
  light surface/chart tokens. `UIAppTheme.custom` already did this; the builder
  now mirrors it.
* **`extraExtensions` on theme builders** — `buildUIKitTheme`,
  `UIAppTheme.custom`, and `UIAppTheme.fromSeed` accept `extraExtensions` to
  register app-specific `ThemeExtension`s (e.g. a semantic brand palette)
  without a manual `copyWith(extensions: [...])` merge.
* **Carousel layout helper** — new `carouselPageHeightForCards(...)` and public
  `kUICarouselControlsFooterHeight` constant reduce the "card + footer +
  controls" page-height boilerplate common in card carousels.
* **Theme-aware image previews** — `UIImagePreviewFrame`, `imagePreviewImage`,
  and `imagePreviewPlaceholder` now resolve their colors from the `Theme` when
  overrides are omitted. `imagePreviewImage` is routed through `UIImage`, so it
  inherits the kit's caching, `UIImageScope` builders, and error handling.
* **Docs** — documented the "custom palette + custom extension" recipe, focused
  (modular) import guidance for compile times, and `UISvgAssetIcon`'s scope as a
  lightweight SVG renderer vs. `UIImage` + `UIImageScope`.

### Breaking

* `imagePreviewImage` no longer accepts `cacheWidth` / `cacheHeight`; `UIImage`
  now derives memory cache dimensions automatically.

## 1.1.1

* **Form System Enhancements** — `UIForm` now supports advanced validation logic:
  * **Auto-Focus on Error** — `validate()` now automatically identifies the first field with an error and requests focus (scrolling it into view).
  * **Error Tracking** — New `errors` map in `UIFormState` providing instant access to all active validation messages.
  * **Imperative Control** — Added `getFieldValue<T>()`, `resetField(name)`, and improved `reset()` to recapture initial state.
* **Smart Glass Performance** — `UIGlassSurface` now intelligently detects device state in `auto` mode. It automatically falls back to `staticTint` if "Reduce Motion" or "Accessibility Navigation" is enabled at the OS level, ensuring smooth performance on all devices.
* **Animation Wrapper** — New `UIAnimateWrapper` utility to easily apply professional staggered entrance animations (Slide + Fade + Scale) to any widget.
* **Skeleton Loading** — Enhanced `UISkeletonPlaceholder` with dark-mode support and new convenience features:
  * `UISkeletonPlaceholder.line()` and `UISkeletonPlaceholder.circle()` factories.
  * `UISkeletonList` — A pre-built widget for displaying professional skeleton list loading states.
* **Global Overlays** — New `UIOverlayUtil` for showing non-blocking global overlays (toasts, banners, etc.) without needing a `Navigator` context in every call.
* **Accessibility & Contrast** — Added a built-in contrast ratio validator in the theme constructor. It now warns in the console during development if chosen palette colors (e.g., `primary` vs `onPrimary`) don't meet WCAG accessibility standards.
* **Design Consistency** — Standardized all button metrics to an 8dp grid (56dp height, 12dp radius) and replaced hardcoded white text defaults with theme-aware `onPrimary` colors.

## 1.1.0

* **Theming ergonomics** — new `UIAppTheme.fromSeed(Color)` and
  `UIThemePalette.fromSeed(Color, {brightness})` generate a full semantic
  palette from a single seed color via Material 3's `ColorScheme.fromSeed`.
  Added high-contrast accessibility presets: `UIThemePalette.highContrastLight`
  / `highContrastDark` and `UIAppTheme.highContrast(Brightness)`.
* **Design tokens** — new `UIButtonMetrics` / `UIInputMetrics` (aliases of
  `UIButtonTheme` / `UIInputTheme`) and a new `UIGlassMetrics` theme extension.
  `UIStyledButtonStyle.primary/outlined/elevated/text` and `UIGlassSurface` now
  resolve heights, radii, blur, and opacity from the theme when the matching
  parameter is left unset (defaults unchanged, so this is backwards compatible).
* **Glass performance** — `UIGlassPerformanceMode` (`fullBlur` / `staticTint` /
  `auto`) lets you swap the live `BackdropFilter` blur for a cheap static tint on
  low-end devices; `UIGlassSurface` optionally wraps its blur in a
  `RepaintBoundary`.
* **Accessibility** — added `semanticsLabel` / `semanticsHint` (and tooltips
  where relevant) to `UIStyledButton`, `UIIconButton`, `UISplitButton`, and a
  custom `semanticsLabel` on `UIRatingBar`; `UILoadingOverlay` and `UISnackbar`
  now expose live-region semantics. New shared `UISemanticsProps`.
* **Adaptive Cupertino** — `UIPillSwitch` gains `adaptive` / `forceCupertino` /
  `forceMaterial` to render a native `CupertinoSwitch` on Apple platforms.
* **Theme-first APIs** — added `UISnackbarStyle.fromTheme(context)`.
* **i18n** — replaced hardcoded English strings in several widgets with
  overridable parameters (defaults unchanged, so behavior is backwards
  compatible):
  * `UIHierarchySearchableDropdown` — `searchHintText` (`'Search here...'`) and
    `clearSearchTooltip` (`'Clear search'`); the clear button now has a tooltip.
  * `UISearchBar` — `clearTooltip`, `ascendingTooltip`, `descendingTooltip`,
    `filterTooltip`; the clear button now has a tooltip.
  * `UIKeyboardToolbar` — `previousLabel` and `nextLabel`.
  * `UITourProgressIndicator` — `labelBuilder` and `compactLabelBuilder` for
    the step text.
  * `UIDropdown` — `requiredMarker` (`' *'`) and `showRequiredMarker`.
* **a11y** — added tooltips / semantic labels to icon buttons that previously
  had none, so they are now announced by screen readers and show hover/long-press
  hints:
  * Back buttons in `UIAppBar` (new `backTooltip`), `UISettingsPageScaffold`
    (`backTooltip`), and `UITabbedDetailScaffold` (`backTooltip`) — when the
    param is null they fall back to the locale-aware
    `MaterialLocalizations.backButtonTooltip`.
  * `UICalendar` month arrows — `previousMonthTooltip` / `nextMonthTooltip`
    (fall back to the matching `MaterialLocalizations` values).
  * `UIPopover` close button — `closeButtonTooltip` (falls back to
    `MaterialLocalizations.closeButtonTooltip`).
  * `UIDetailDateNavigator` — `previousTooltip` / `nextTooltip`.
  * `UINumberField` — `decrementTooltip` / `incrementTooltip`.
  * `UIExpandableFloatingPanel` & `UITreeView` — `expandTooltip` /
    `collapseTooltip`.
  * `UITextFormField` — `showPasswordTooltip` / `hidePasswordTooltip` on the
    password visibility toggle.
  * `UITourTooltipCard` skip and previous buttons now expose tooltips from
    `UITourStep.skipButtonLabel` / `previousButtonLabel`.
* **Fixes** — `UIIconButton` now inherits its color from the ambient `IconTheme`
  (was hardcoded to `Colors.black`, breaking dark mode) and is genuinely
  disabled when `onPressed` is `null` (previously always tappable).
  `DateTimeUtil.getFormattedDate` and `getFormatDayMonthYearHourMinSec` now log
  parse/format failures in debug instead of silently swallowing them.
* **pub.dev metadata** — declared supported `platforms` (android, ios, web,
  macos, windows, linux) and added `screenshots` for visual previews.
* **Tooling** — tightened the `flutter` SDK constraint to `>=3.32.0` to match
  the required Dart SDK and modern APIs (`Color.withValues`, `CardThemeData`).
  Enabled the `prefer_relative_imports` lint and normalized all intra-package
  imports under `lib/src` to relative paths. Raised `public_member_api_docs`
  from `info` to `warning` so missing public docs fail analysis. CI now runs
  `dart pub publish --dry-run`; added a compile-time export guard
  (`test/exports_test.dart`) and accessibility tests. Migrated legacy
  `MediaQuery.of(context).size` usages to `MediaQuery.sizeOf(context)` in
  `UIDivider`, `UITitleWithBorderedLine`, `UILabeledTextFormField`, and widget
  helpers.
* **Maintenance** — decomposed the 1,830-line
  `ui_hierarchy_searchable_dropdown.dart` into focused `part` files
  (header / panel / tree) with no public API change.

## 1.0.0

* **Stable release** — first production-ready version of `vvk_ui_kit` with a complete public API exported from `package:vvk_ui_kit/vvk_ui_kit.dart`.
* **Widget test suite** — 301 tests across 30 test files covering the full component library:
  * **Core** — extensions, theme tokens, `NavigationUtil`, `DialogUtil`, `JsonUtils`, `Translations`, and widget helpers.
  * **Buttons** — `UIStyledButton`, split/glass/slider/social auth, and all button variants.
  * **Accordion, cards & clips** — expansion accordions, `UICard`, `UIAnimatedFlipCard`, ticket/coupon clips, hexagon, and sharp corners.
  * **Carousel & decoration** — carousels with indicators, gradient widgets, dotted borders, corner ribbons, and glass surfaces.
  * **Display & rating** — stat cards, banners, command bar, progress bars, animated counter, text avatar, stack badge, timer builder, and rating bars.
  * **Dialogs** — adaptive alert/action sheets, shell dialogs, Cupertino sheets, image picker, and bottom sheets.
  * **Feedback** — snackbars, badges, empty states, tooltips, popover, skeleton placeholders, and product tour (`UITourController`, spotlight overlay).
  * **Inputs** — form fields, `UIForm`, dropdowns, search bar, tag input, number field, color picker, OTP, sliders, calendar/date/time pickers, and settings tiles.
  * **Layout & responsive** — dividers, page scaffold, expandable panel, dynamic overflow, keyboard dismiss/toolbar, portal, glass scaffold, and `Responsive` helpers.
  * **Lists, loading & media** — swipe action tile, shimmer/overlay/load-more helpers, `UIImage`, and `UIImageScope`.
  * **Navigation & tabs** — app bars, bottom bars, menu bar, tree view, breadcrumbs, context menu, side menu, settings scaffolds, and tab bars.
  * **Selection, states & text** — list tile select, pill switch, radio group, rounded checkbox, error info, rich/read-more/marquee text, and SVG icons.
* **Documentation** — updated `README.md`, `doc/IMPLEMENTATION_GUIDE.md`, and example app catalog to match the current API.

## 0.0.9

* **Glass** — `UIGlassSurface`, `UIGlassCard`, `UIGlassButton`, `UIGlassAppBar`, `UIGlassBottomNavBar`, `UIGlassScaffold`, `UIGlassTheme`.
* **Product tours** — `UITourController`, `UITourStep`, `UISpotlightOverlay`, `UITourTooltipCard`, `UITourProgressIndicator`.
* **Feedback** — `UIPopover`.

## 0.0.8

* **Coupon clips** — `UICouponClip`, `UICouponCard`, `UICouponClipper`, `UICouponDecorationPainter`.
* **Adaptive dialogs** — `showUIAdaptiveAlertDialog`, `showUIAdaptiveActionSheet` with shared platform selection.
* **Core** — `UIPageRoute` transitions (`UIEntrancePageTransition`, `UIDrillInPageTransition`, `UIHorizontalSlidePageTransition`).
* **Maintenance** — removed dead `loading/shimmer.dart` re-export; consolidated adaptive platform helper and context-menu item mapping; expanded example showcase coverage.

## 0.0.7

* **Buttons** — `UISplitButton`.
* **Display** — `UICommandBar`.
* **Inputs** — `UISearchBar`, `UITagInput`, `UINumberField`, `UIColorPicker`.

## 0.0.6

* **Layout** — `UIPageScaffold`, `UIExpandableFloatingPanel`, `UIDynamicOverflow`.
* **Lists** — `UISwipeActionTile`.
* **Navigation** — `UIBottomNavyBar`, `UIFloatingBottomBar`, `UIMenuBar`, `UITreeView`.
* **Cards** — `UIAnimatedFlipCard`.

## 0.0.5

* **Loading** — `UIShimmer`, `UIShimmerLoadingContainer`, `UIShimmerBase`, `UIShimmerPageLoading`, `UILoadingOverlay`, `UILoadMoreContainer`, `UILoadingIndicator`.
* Interactive example app catalog covering all exported widgets and utilities.
* Implementation guide at `doc/IMPLEMENTATION_GUIDE.md`.

## 0.0.4

* **Accordion, cards & clips** — `UIExpansionAccord`, `UIExpansionAccordItem`, `UIExpansionTile`, `UICard`, `UICardTopContainer`, `UIHexagon`, `UISharpCorners`, `UITicketClip`.
* **Carousel** — `UICarouselWithIndicator`, `UISectionCarousel`, `UICarouselControls`, `UICarouselRowPage`, `UICarouselNavButton`, `UICarouselPageIndicators`.
* **Decoration** — `UIGradientBox`, `UIGradientText`, `UIGradientSvgIcon`, `UIDottedBorder`, `UICornerRibbon`.

## 0.0.3

* **Display** — `UIStatSummaryCard`, `UIStatusBanner`, `UIBatteryIndicator`, `UISegmentedBar`, `UISummaryGrid`, `UIMetricListTile`, `UIIconBadge`, `UIAnimatedCounter`, `UITextAvatar`, `UIStackBadge`, `UITimerBuilder`, and related display widgets.
* **Dialogs** — `UICustomMessageDialog`, `UIShellDialog`, `UIAlertPanel`, `UIListDialog`, `UIImagePickerDialog`, `showUISheet`, `showUICupertinoActionSheet`.
* **Feedback** — `UISnackbar`, `UIEmptyState`, `UIBadge`, `UILiveBadge`, `UINoteList`, `UISkeletonPlaceholder`, `UITooltip`.
* **Inputs** — `UITextFormField`, `UILabeledField`, `UILabeledTextFormField`, `UIForm` with named fields, `UIDropdown`, `UIOverlayDropdown`, `UIPasswordStrengthIndicator`, `UIRangeSlider`, `NoLeadingSpaceFormatter`, `NoSpaceFormatter`, and settings tile widgets.

## 0.0.2

* **Selection & states** — `UIListTileSelect`, `UIRoundedCheckbox`, `UIRadioGroup`, `UIErrorInfo`.
* **Tabs** — `UITabBar`, `UISegmentedTabBar`, `UIButtonsTab`.
* **Text & icons** — `UIText`, `UIRichText`, `UIReadMoreText`, `UIMarquee`, `UITextRow`, `UISvgImage`, `UISvgAssetIcon`, `UISocialAuthIcon` with a lightweight built-in SVG path parser; widget helpers `buildUILabel`, `textStyle`, `textSpan`, `getMaxLines`, `getTextHeight`.
* **Core utilities** — `NavigationUtil`, `DialogUtil`, `DateTimeUtil`, `JsonUtils`, `JsonHelper`, `Mapper`, `Translations`, `TranslationCache`, `StringUtils`, `StringExtension`, `DoubleExtension`.

## 0.0.1

* Initial release of `vvk_ui_kit`.
* **Theming** — `UIAppTheme` with `UIThemePalette` light/dark presets, `UIThemeExtension` semantic tokens, and `UIMetrics` layout values.
* **Buttons** — `UIStyledButton` with style variants, `UIPrimaryTextButton`, `UITextButton`, `UIElevatedButton`, `UIIconButton`, `UIElevatedIconButton`, `UIImageButton`, `UIImageTextButton`, `UICupertinoTextButton`, `UICustomOutlinedButton`, `UITabTextButton`, `UIGradientButton`, `UISliderButton`, and `UISocialAuthButton`.
* **Layout & responsive** — `UIDivider`, `UIDashedDivider`, `UICenteredTextDivider`, `UIFixedSectionListView`, `UIScrollableScreen`, `UISeparatedRow`, `UISeparatedColumn`, `UISpacing`, `UIKeyboardDismissArea`, `Responsive`, `ResponsiveProvider`, `ResponsiveLayout`.
* **Media** — `UIImage` for assets, network URLs, SVG, and base64 via `UIImageScope` builder injection.
* **Navigation** — `UIAppBar`, `UISideMenu`, `UISettingsPageScaffold`, `UITabbedDetailScaffold`, `UIThemeToggleButton`, `UIDoubleBackToExit`.
