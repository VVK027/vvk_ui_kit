import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/display/ui_info_banner.dart';
import 'package:vvk_ui_kit/src/widgets/navigation/ui_detail_date_navigator.dart';
import 'package:vvk_ui_kit/src/widgets/layout/ui_fixed_section_list.dart';
import 'package:vvk_ui_kit/src/widgets/inputs/ui_settings_tiles.dart';
import 'package:vvk_ui_kit/src/widgets/navigation/ui_app_bar.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Scaffold layout for settings screens with app bar and optional save FAB.
class UISettingsPageScaffold extends StatelessWidget {
  const UISettingsPageScaffold({
    super.key,
    this.title,
    this.titleChild,
    required this.body,
    this.onBack,
    this.floatingActionButton,
    this.onSave,
    this.saveFabTooltip,
    this.accentColor,
    this.appBarActions = const [],
  }) : assert(
         titleChild != null || title != null,
         'Either title or titleChild must be provided.',
       );

  final String? title;
  final Widget? titleChild;
  final Widget body;
  final VoidCallback? onBack;
  final Widget? floatingActionButton;
  final VoidCallback? onSave;
  final String? saveFabTooltip;
  final Color? accentColor;
  final List<Widget> appBarActions;

  UISettingsPageScaffold copyWith({
    Key? key,
    String? title,
    Widget? titleChild,
    Widget? body,
    VoidCallback? onBack,
    Widget? floatingActionButton,
    VoidCallback? onSave,
    String? saveFabTooltip,
    Color? accentColor,
    List<Widget>? appBarActions,
  }) {
    return UISettingsPageScaffold(
      key: key ?? this.key,
      title: title ?? this.title,
      titleChild: titleChild ?? this.titleChild,
      body: body ?? this.body,
      onBack: onBack ?? this.onBack,
      floatingActionButton: floatingActionButton ?? this.floatingActionButton,
      onSave: onSave ?? this.onSave,
      saveFabTooltip: saveFabTooltip ?? this.saveFabTooltip,
      accentColor: accentColor ?? this.accentColor,
      appBarActions: appBarActions ?? this.appBarActions,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = accentColor ?? theme.colorScheme.primary;
    final onBar = UIAppBar.contrastOn(accent);
    final fab =
        floatingActionButton ??
        (onSave != null
            ? UISettingsSaveFab(
                onPressed: onSave!,
                tooltip: saveFabTooltip ?? '',
              )
            : null);
    final titleWidget =
        titleChild ??
        UIText(
          title!,
          color: onBar,
          size: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: onBar, size: 20),
          onPressed: onBack ?? () => Navigator.of(context).pop(),
        ),
        title: titleWidget,
        foregroundColor: onBar,
        iconTheme: IconThemeData(color: onBar),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [accent, Color.lerp(accent, Colors.black, 0.12)!],
            ),
          ),
        ),
        backgroundColor: accent,
        actions: appBarActions,
      ),
      body: SafeArea(child: body),
      floatingActionButton: fab,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

/// Accent header label for detail activity screens.
class UIDetailActivityHeader extends StatelessWidget {
  const UIDetailActivityHeader({super.key, this.label, this.labelChild})
    : assert(
        labelChild != null || label != null,
        'Either label or labelChild must be provided.',
      );

  final String? label;
  final Widget? labelChild;

  UIDetailActivityHeader copyWith({
    Key? key,
    String? label,
    Widget? labelChild,
  }) {
    return UIDetailActivityHeader(
      key: key ?? this.key,
      label: label ?? this.label,
      labelChild: labelChild ?? this.labelChild,
    );
  }

  @override
  Widget build(BuildContext context) {
    return UIDetailInfoBanner(text: label, textChild: labelChild);
  }
}

/// Scrollable detail layout with activity header and tab content area.
class UIDetailScrollLayout extends StatelessWidget {
  const UIDetailScrollLayout({
    super.key,
    required this.activityLabel,
    required this.dateTitle,
    required this.isNextDisabled,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.chart,
    this.belowChart = const [],
    this.activityLabelChild,
    this.dateTitleChild,
  });

  final String activityLabel;
  final String dateTitle;
  final bool isNextDisabled;
  final VoidCallback onPreviousDay;
  final VoidCallback? onNextDay;
  final Widget chart;
  final List<Widget> belowChart;
  final Widget? activityLabelChild;
  final Widget? dateTitleChild;

  UIDetailScrollLayout copyWith({
    Key? key,
    String? activityLabel,
    String? dateTitle,
    bool? isNextDisabled,
    VoidCallback? onPreviousDay,
    VoidCallback? onNextDay,
    Widget? chart,
    List<Widget>? belowChart,
    Widget? activityLabelChild,
    Widget? dateTitleChild,
  }) {
    return UIDetailScrollLayout(
      key: key ?? this.key,
      activityLabel: activityLabel ?? this.activityLabel,
      dateTitle: dateTitle ?? this.dateTitle,
      isNextDisabled: isNextDisabled ?? this.isNextDisabled,
      onPreviousDay: onPreviousDay ?? this.onPreviousDay,
      onNextDay: onNextDay ?? this.onNextDay,
      chart: chart ?? this.chart,
      belowChart: belowChart ?? this.belowChart,
      activityLabelChild: activityLabelChild ?? this.activityLabelChild,
      dateTitleChild: dateTitleChild ?? this.dateTitleChild,
    );
  }

  @override
  Widget build(BuildContext context) {
    return UIFixedSectionListView(
      sections: [
        UIDetailActivityHeader(
          label: activityLabel,
          labelChild: activityLabelChild,
        ),
        UIDetailDateNavigator(
          dateTitle: dateTitle,
          dateTitleChild: dateTitleChild,
          isNextDisabled: isNextDisabled,
          onPrevious: onPreviousDay,
          onNext: onNextDay,
        ),
        RepaintBoundary(child: chart),
        ...belowChart,
      ],
    );
  }
}
