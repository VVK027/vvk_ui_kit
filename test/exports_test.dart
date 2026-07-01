// Compile-time guarantee that each focused entry point re-exports the public
// symbols host apps are expected to import from it. Referencing a symbol that a
// barrel stops exporting makes this test fail to compile (and therefore fail in
// `flutter analyze` / `flutter test`), catching accidental export regressions.

import 'package:flutter_test/flutter_test.dart';

import 'package:vvk_ui_kit/theme.dart' as theme;
import 'package:vvk_ui_kit/buttons.dart' as buttons;
import 'package:vvk_ui_kit/inputs.dart' as inputs;
import 'package:vvk_ui_kit/layout.dart' as layout;
import 'package:vvk_ui_kit/dialogs.dart' as dialogs;
import 'package:vvk_ui_kit/feedback.dart' as feedback;
import 'package:vvk_ui_kit/navigation.dart' as navigation;
import 'package:vvk_ui_kit/media.dart' as media;
import 'package:vvk_ui_kit/widgets.dart' as widgets;
import 'package:vvk_ui_kit/core.dart' as core;
import 'package:vvk_ui_kit/vvk_ui_kit.dart' as full;

void main() {
  group('entry points export expected symbols', () {
    test('theme.dart', () {
      final symbols = <Type>[
        theme.UIAppTheme,
        theme.UIThemePalette,
        theme.UIThemeColors,
        theme.UIThemeExtension,
        theme.UIMetrics,
        theme.UIInputTheme,
        theme.UIButtonTheme,
        theme.UIGlassMetrics,
        theme.UIButtonMetrics,
        theme.UIInputMetrics,
      ];
      expect(theme.buildUIKitTheme, isNotNull);
      expect(symbols, everyElement(isNotNull));
    });

    test('buttons.dart', () {
      final symbols = <Type>[
        buttons.UIStyledButton,
        buttons.UIStyledButtonStyle,
        buttons.UIIconButton,
        buttons.UISplitButton,
        buttons.UIGradientButton,
        buttons.UIGlassButton,
      ];
      expect(symbols, everyElement(isNotNull));
    });

    test('inputs.dart', () {
      final symbols = <Type>[
        inputs.UITextFormField,
        inputs.UIInputOTP,
        inputs.UISlider,
        inputs.UIPillSwitch,
        inputs.UITagInput,
        inputs.UINumberField,
      ];
      expect(symbols, everyElement(isNotNull));
    });

    test('layout.dart', () {
      final symbols = <Type>[
        layout.UIPageScaffold,
        layout.UIPortal,
        layout.UIKeyboardToolbar,
        layout.UIDashedDivider,
        layout.UICenteredTextDivider,
      ];
      expect(symbols, everyElement(isNotNull));
    });

    test('dialogs.dart', () {
      final symbols = <Type>[
        dialogs.UICustomMessageDialog,
        dialogs.UISheet,
        dialogs.UIAlertPanel,
      ];
      expect(symbols, everyElement(isNotNull));
    });

    test('feedback.dart', () {
      final symbols = <Type>[
        feedback.UIEmptyState,
        feedback.UIErrorInfo,
        feedback.UITourController,
        feedback.UIPopover,
      ];
      expect(symbols, everyElement(isNotNull));
    });

    test('navigation.dart', () {
      final symbols = <Type>[
        navigation.UIAppBar,
        navigation.UIBottomNavyBar,
        navigation.UITreeView,
        navigation.UIBreadcrumb,
        navigation.UITabBar,
      ];
      expect(symbols, everyElement(isNotNull));
    });

    test('media.dart', () {
      final symbols = <Type>[
        media.UIImage,
        media.UIImageScope,
        media.UIImagePreviewFrame,
      ];
      expect(symbols, everyElement(isNotNull));
    });

    test('widgets.dart', () {
      final symbols = <Type>[
        widgets.UICard,
        widgets.UIText,
        widgets.UIRatingBar,
        widgets.UIGlassSurface,
        widgets.UIListTileSelect,
      ];
      expect(symbols, everyElement(isNotNull));
    });

    test('core.dart', () {
      final symbols = <Type>[
        core.JsonHelper,
        core.Mapper,
        core.NavigationUtil,
        core.StringUtils,
      ];
      expect(symbols, everyElement(isNotNull));
    });

    test('full barrel re-exports flagship widgets', () {
      final symbols = <Type>[
        full.UIStyledButton,
        full.UITextFormField,
        full.UIAppBar,
        full.UICard,
        full.UIAppTheme,
      ];
      expect(symbols, everyElement(isNotNull));
    });
  });
}
