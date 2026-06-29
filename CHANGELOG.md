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
