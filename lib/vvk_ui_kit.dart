/// A Flutter UI kit with themed widgets, utilities, and Material 3 light/dark support.
///
/// Import this library to access the full public API:
///
/// ```dart
/// import 'package:vvk_ui_kit/vvk_ui_kit.dart';
/// ```
///
/// ## Getting started
///
/// Apply `UIAppTheme.light` and `UIAppTheme.dark` on `MaterialApp`, and optionally
/// wrap the app in `UIImageScope` for custom network/SVG image builders.
///
/// ## Package contents
///
/// * **Core** — navigation, dialog, date/time, string and translation utilities,
///   JsonHelper, Mapper, Translations, TranslationCache, JsonUtils; theme tokens,
///   palette presets (teal, zinc, slate, stone), typography, shadows, breakpoints,
///   page transitions, and extensions for strings, collections, numbers, colors,
///   alignment, and listenables.
/// * **Animation** — tap guard, avatar glow, gesture helpers, and staggered
///   list/grid entrance animations.
/// * **Buttons** — styled, primary, elevated, icon, image, slider confirm,
///   gradient, split, glass, social auth, and platform buttons.
/// * **Accordion, cards & clips** — expansion accordions, cards, animated flip
///   card, hexagon, ticket/coupon clips, and sharp-corner clips.
/// * **Carousel & decoration** — carousels with indicators, gradient widgets,
///   dotted borders, corner ribbons, and glass surfaces.
/// * **Display & rating** — stat cards, banners, command bar, snackbars, empty
///   states, shimmer, rating bars, text avatars, animated counters, timer
///   builders, stack badges, badges/alerts, tooltips, and progress bars.
/// * **Dialogs** — message dialogs, adaptive alert/action sheets, confirm
///   presets, shell dialogs, sheets, and Cupertino action sheets.
/// * **Feedback & tours** — popover, skeleton placeholders, and guided product
///   tours with spotlight overlay.
/// * **Glass** — frosted surface, card, button, app bar, bottom nav bar, and scaffold.
/// * **Inputs** — form fields, `UIForm` with named field tracking, dropdowns,
///   hierarchy searchable dropdown, calendar/date/time pickers, search bar, tag
///   input, number field, color picker, password strength, pill switch, rounded
///   checkboxes, textarea, OTP input, and value sliders.
/// * **Layout & loading** — responsive helpers, scroll screens, page scaffold,
///   expandable floating panel, dynamic overflow, keyboard dismiss, keyboard
///   toolbar host, portal overlays, separated rows/columns, dashed dividers,
///   centered text dividers, shimmer, overlays, and load-more helpers.
/// * **Lists** — swipe action tile with custom drag actions.
/// * **Text** — read-more text, marquee scrolling, and icon/text rows.
/// * **Media & icons** — unified `UIImage`, SVG rendering, and asset icons.
/// * **Navigation & tabs** — app bars, breadcrumbs, context menus, side menu,
///   bottom bars, menu bar, tree view, settings scaffolds, and tab bars.
/// * **Selection & states** — list tile select, pill switch, rounded checkbox,
///   radio groups, and error info.
library;

// Core
export 'src/core/extensions/alignment_extension.dart';
export 'src/core/extensions/bool_extension.dart';
export 'src/core/extensions/color_extension.dart';
export 'src/core/extensions/double_extension.dart';
export 'src/core/extensions/integer_extension.dart';
export 'src/core/extensions/iterable_extension.dart';
export 'src/core/extensions/list_extension.dart';
export 'src/core/extensions/listenable_extension.dart';
export 'src/core/extensions/map_extension.dart';
export 'src/core/extensions/number_extension.dart';
export 'src/core/extensions/object_extension.dart';
export 'src/core/extensions/round_up_extension.dart';
export 'src/core/extensions/set_extension.dart';
export 'src/core/extensions/string_extension.dart';
export 'src/core/helpers/json_helper.dart';
export 'src/core/helpers/mapper.dart';
export 'src/core/theme/ui_breakpoints.dart';
export 'src/core/theme/ui_component_themes.dart';
export 'src/core/theme/ui_shadows.dart';
export 'src/core/theme/ui_theme.dart';
export 'src/core/theme/ui_theme_palettes.dart';
export 'src/core/theme/ui_typography.dart';
export 'src/core/utils/date_time_util.dart';
export 'src/core/utils/dialog_util.dart';
export 'src/core/utils/json_utils.dart';
export 'src/core/utils/navigation_util.dart';
export 'src/core/navigation/ui_page_transitions.dart';
export 'src/core/utils/platform_util.dart';
export 'src/core/utils/string_util.dart';
export 'src/core/utils/system_ui_utils.dart';
export 'src/core/utils/translation_util.dart';

// Icons
export 'src/icons/ui_social_auth_assets.dart';
export 'src/icons/ui_social_auth_icon.dart';
export 'src/icons/ui_svg_asset_icon.dart';
export 'src/icons/ui_svg_image.dart';
export 'src/icons/ui_svg_path_parser.dart';

// Widgets — anim
export 'src/widgets/anim/animated_gesture_detector.dart';
export 'src/widgets/anim/ui_animation_configuration.dart';
export 'src/widgets/anim/ui_animation_limiter.dart';
export 'src/widgets/anim/ui_avatar_glow.dart';
export 'src/widgets/anim/ui_entrance_animations.dart';
export 'src/widgets/anim/ui_tap_guard.dart';

// Widgets — shared
export 'src/widgets/ui_widget_helpers.dart';
export 'src/widgets/ui_widget_props.dart';

// Widgets — accordion
export 'src/widgets/accordion/ui_expansion_accord.dart';
export 'src/widgets/accordion/ui_expansion_accord_item.dart';
export 'src/widgets/accordion/ui_expansion_tile.dart';

// Widgets — buttons
export 'src/widgets/buttons/ui_button_props.dart';
export 'src/widgets/buttons/ui_cupertino_text_button.dart';
export 'src/widgets/buttons/ui_custom_outlined_button.dart';
export 'src/widgets/buttons/ui_elevated_button.dart';
export 'src/widgets/buttons/ui_elevated_icon_button.dart';
export 'src/widgets/buttons/ui_gradient_button.dart';
export 'src/widgets/buttons/ui_icon_button.dart';
export 'src/widgets/buttons/ui_image_button.dart';
export 'src/widgets/buttons/ui_image_text_button.dart';
export 'src/widgets/buttons/ui_primary_text_button.dart';
export 'src/widgets/buttons/ui_slider_button.dart';
export 'src/widgets/buttons/ui_social_auth_button.dart';
export 'src/widgets/buttons/ui_social_auth_provider.dart';
export 'src/widgets/buttons/ui_split_button.dart';
export 'src/widgets/buttons/ui_styled_button.dart';
export 'src/widgets/buttons/ui_tab_text_button.dart';
export 'src/widgets/buttons/ui_text_button.dart';

// Widgets — cards & clips
export 'src/widgets/cards/ui_animated_flip_card.dart';
export 'src/widgets/cards/ui_card.dart';
export 'src/widgets/cards/ui_card_top_container.dart';
export 'src/widgets/clips/ui_coupon_card.dart';
export 'src/widgets/clips/ui_coupon_clip.dart';
export 'src/widgets/clips/ui_coupon_clipper.dart';
export 'src/widgets/clips/ui_coupon_decoration_painter.dart';
export 'src/widgets/clips/ui_hexagon.dart';
export 'src/widgets/clips/ui_sharp_corners.dart';
export 'src/widgets/clips/ui_ticket_clip.dart';

// Widgets — carousel
export 'src/widgets/carousel/ui_carousel_controls.dart';
export 'src/widgets/carousel/ui_carousel_layout.dart';
export 'src/widgets/carousel/ui_carousel_with_indicator.dart';
export 'src/widgets/carousel/ui_section_carousel.dart';

// Widgets — decoration
export 'src/widgets/decoration/ui_corner_ribbon.dart';
export 'src/widgets/decoration/ui_dotted_border.dart';
export 'src/widgets/decoration/ui_gradient_box.dart';
export 'src/widgets/decoration/ui_gradient_svg_icon.dart';
export 'src/widgets/decoration/ui_gradient_text.dart';

// Widgets — rating
export 'src/widgets/rating/ui_rating_bar.dart';
export 'src/widgets/rating/ui_rating_bar_indicator.dart';
export 'src/widgets/rating/ui_rating_widget.dart';

// Widgets — display
export 'src/widgets/display/ui_command_bar.dart';
export 'src/widgets/display/ui_animated_counter.dart';
export 'src/widgets/display/ui_battery_indicator.dart';
export 'src/widgets/display/ui_circle_progress_painter.dart';
export 'src/widgets/display/ui_icon_badge.dart';
export 'src/widgets/display/ui_icon_text_column.dart';
export 'src/widgets/display/ui_info_banner.dart';
export 'src/widgets/display/ui_metric_list_tile.dart';
export 'src/widgets/display/ui_primary_action_bar.dart';
export 'src/widgets/display/ui_progress_bar.dart';
export 'src/widgets/display/ui_segmented_bar.dart';
export 'src/widgets/display/ui_stack_badge.dart';
export 'src/widgets/display/ui_stat_card.dart';
export 'src/widgets/display/ui_status_banner.dart';
export 'src/widgets/display/ui_summary_grid.dart';
export 'src/widgets/display/ui_text_avatar.dart';
export 'src/widgets/display/ui_timer_builder.dart';

// Widgets — dialogs
export 'src/widgets/dialogs/ui_adaptive_action_sheet.dart';
export 'src/widgets/dialogs/ui_adaptive_dialog.dart';
export 'src/widgets/dialogs/ui_alert_dialog.dart';
export 'src/widgets/dialogs/ui_alert_panel.dart';
export 'src/widgets/dialogs/ui_cupertino_action_sheet.dart';
export 'src/widgets/dialogs/ui_custom_message_dialog.dart';
export 'src/widgets/dialogs/ui_confirm_dialog.dart';
export 'src/widgets/dialogs/ui_image_picker_dialog.dart';
export 'src/widgets/dialogs/ui_list_dialog.dart';
export 'src/widgets/dialogs/ui_shell_dialog.dart';
export 'src/widgets/dialogs/ui_sheet.dart';

// Widgets — feedback
export 'src/widgets/feedback/ui_alert.dart';
export 'src/widgets/feedback/ui_badge.dart';
export 'src/widgets/feedback/ui_empty_state.dart';
export 'src/widgets/feedback/ui_live_badge.dart';
export 'src/widgets/feedback/ui_note_list.dart';
export 'src/widgets/feedback/ui_popover.dart';
export 'src/widgets/feedback/ui_skeleton_placeholder.dart';
export 'src/widgets/feedback/ui_snackbar.dart';
export 'src/widgets/feedback/ui_spotlight_overlay.dart';
export 'src/widgets/feedback/ui_tooltip.dart';
export 'src/widgets/feedback/ui_tour_controller.dart';
export 'src/widgets/feedback/ui_tour_enums.dart';
export 'src/widgets/feedback/ui_tour_progress_indicator.dart';
export 'src/widgets/feedback/ui_tour_step.dart';
export 'src/widgets/feedback/ui_tour_tooltip_card.dart';

// Widgets — glass
export 'src/widgets/glass/ui_glass_app_bar.dart';
export 'src/widgets/glass/ui_glass_bottom_nav_bar.dart';
export 'src/widgets/glass/ui_glass_button.dart';
export 'src/widgets/glass/ui_glass_card.dart';
export 'src/widgets/glass/ui_glass_scaffold.dart';
export 'src/widgets/glass/ui_glass_surface.dart';
export 'src/widgets/glass/ui_glass_theme.dart';

// Widgets — inputs
export 'src/widgets/inputs/ui_color_picker.dart';
export 'src/widgets/inputs/ui_number_field.dart';
export 'src/widgets/inputs/ui_password_strength_indicator.dart';
export 'src/widgets/inputs/ui_calendar.dart';
export 'src/widgets/inputs/ui_date_picker.dart';
export 'src/widgets/inputs/ui_dropdown.dart';
export 'src/widgets/inputs/ui_form.dart';
export 'src/widgets/inputs/ui_form_fields.dart';
export 'src/widgets/inputs/ui_hierarchy_searchable_dropdown.dart';
export 'src/widgets/inputs/ui_input_otp.dart';
export 'src/widgets/inputs/ui_labeled_field.dart';
export 'src/widgets/inputs/ui_labeled_text_form_field.dart';
export 'src/widgets/inputs/ui_overlay_dropdown.dart';
export 'src/widgets/inputs/ui_picker_bottom_sheet.dart';
export 'src/widgets/inputs/ui_search_bar.dart';
export 'src/widgets/inputs/ui_tag_input.dart';
export 'src/widgets/inputs/ui_settings_tiles.dart';
export 'src/widgets/inputs/ui_slider.dart';
export 'src/widgets/inputs/ui_textarea.dart';
export 'src/widgets/inputs/ui_text_form_field.dart';
export 'src/widgets/inputs/ui_text_field_helper.dart';
export 'src/widgets/inputs/ui_time_picker.dart';

// Widgets — layout
export 'src/widgets/layout/ui_centered_text_divider.dart';
export 'src/widgets/layout/ui_keyboard_dismiss_area.dart';
export 'src/widgets/layout/ui_spacing.dart';
export 'src/widgets/layout/ui_keyboard_toolbar.dart';
export 'src/widgets/layout/ui_portal.dart';
export 'src/widgets/layout/ui_dashed_divider.dart';
export 'src/widgets/layout/ui_divider.dart';
export 'src/widgets/layout/ui_dynamic_overflow.dart';
export 'src/widgets/layout/ui_expandable_floating_panel.dart';
export 'src/widgets/layout/ui_fixed_section_list.dart';
export 'src/widgets/layout/ui_page_scaffold.dart';
export 'src/widgets/responsive/ui_responsive.dart';
export 'src/widgets/layout/ui_scrollable_screen.dart';
export 'src/widgets/layout/ui_separated_flex.dart';

// Widgets — lists
export 'src/widgets/lists/ui_swipe_action_tile.dart';

// Widgets — loading
export 'src/widgets/loading/ui_load_more_container.dart';
export 'src/widgets/loading/ui_loading_indicator.dart';
export 'src/widgets/loading/ui_loading_overlay.dart';
export 'src/widgets/loading/ui_page_loading.dart';
export 'src/widgets/loading/ui_shimmer.dart';
export 'src/widgets/loading/ui_shimmer_loading_container.dart';
export 'src/widgets/loading/ui_shimmer_widget.dart';

// Widgets — media
export 'src/widgets/media/ui_image.dart';
export 'src/widgets/media/ui_image_preview_frame.dart';
export 'src/widgets/media/ui_image_scope.dart';

// Widgets — navigation
export 'src/widgets/navigation/ui_app_bar.dart';
export 'src/widgets/navigation/ui_avatar_with_edit.dart';
export 'src/widgets/navigation/ui_bottom_navy_bar.dart';
export 'src/widgets/navigation/ui_floating_bottom_bar.dart';
export 'src/widgets/navigation/ui_breadcrumb.dart';
export 'src/widgets/navigation/ui_context_menu.dart';
export 'src/widgets/navigation/ui_detail_date_navigator.dart';
export 'src/widgets/navigation/ui_double_back_to_exit.dart';
export 'src/widgets/navigation/ui_settings_scaffold.dart';
export 'src/widgets/navigation/ui_menu_bar.dart';
export 'src/widgets/navigation/ui_side_menu.dart';
export 'src/widgets/navigation/ui_tabbed_detail_scaffold.dart';
export 'src/widgets/navigation/ui_tree_view.dart';
export 'src/widgets/navigation/ui_theme_toggle_button.dart';
export 'src/widgets/navigation/ui_title_with_bordered_line.dart';
export 'src/widgets/navigation/ui_title_with_switch.dart';

// Widgets — selection
export 'src/widgets/selection/ui_list_tile_select.dart';
export 'src/widgets/selection/ui_pill_switch.dart';
export 'src/widgets/selection/ui_radio_group.dart';
export 'src/widgets/selection/ui_rounded_checkbox.dart';

// Widgets — states
export 'src/widgets/states/ui_error_info.dart';

// Widgets — tabs
export 'src/widgets/tabs/ui_buttons_tab.dart';
export 'src/widgets/tabs/ui_segmented_tab_bar.dart';
export 'src/widgets/tabs/ui_tab_bar.dart';

// Widgets — text
export 'src/widgets/text/ui_marquee.dart';
export 'src/widgets/text/ui_read_more_text.dart';
export 'src/widgets/text/ui_text_row.dart';
export 'src/widgets/text/ui_rich_text.dart';
export 'src/widgets/text/ui_text.dart';
