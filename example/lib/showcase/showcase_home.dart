import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import 'accordion_cards_clips_showcase.dart';
import 'anim_showcase.dart';
import 'buttons_showcase.dart';
import 'carousel_showcase.dart';
import 'core_showcase.dart';
import 'decoration_showcase.dart';
import 'dialogs_showcase.dart';
import 'display_showcase.dart';
import 'feedback_showcase.dart';
import 'inputs_showcase.dart';
import 'layout_responsive_showcase.dart';
import 'loading_showcase.dart';
import 'media_showcase.dart';
import 'navigation_showcase.dart';
import 'rating_showcase.dart';
import 'selection_states_showcase.dart';
import 'tabs_showcase.dart';
import 'text_icons_showcase.dart';

class ShowcaseHome extends StatelessWidget {
  const ShowcaseHome({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    final entries = <_ShowcaseEntry>[
      _ShowcaseEntry(
        'Core utilities',
        Icons.build_outlined,
        const CoreShowcase(),
      ),
      _ShowcaseEntry(
        'Buttons',
        Icons.smart_button_outlined,
        const ButtonsShowcase(),
      ),
      _ShowcaseEntry(
        'Animation',
        Icons.animation_outlined,
        const AnimShowcase(),
      ),
      _ShowcaseEntry(
        'Accordion, cards & clips',
        Icons.view_agenda_outlined,
        const AccordionCardsClipsShowcase(),
      ),
      _ShowcaseEntry(
        'Carousel',
        Icons.view_carousel_outlined,
        const CarouselShowcase(),
      ),
      _ShowcaseEntry(
        'Decoration',
        Icons.gradient_outlined,
        const DecorationShowcase(),
      ),
      _ShowcaseEntry(
        'Display',
        Icons.dashboard_outlined,
        const DisplayShowcase(),
      ),
      _ShowcaseEntry('Rating', Icons.star_outline, const RatingShowcase()),
      _ShowcaseEntry(
        'Dialogs',
        Icons.chat_bubble_outline,
        const DialogsShowcase(),
      ),
      _ShowcaseEntry(
        'Feedback',
        Icons.feedback_outlined,
        const FeedbackShowcase(),
      ),
      _ShowcaseEntry('Inputs', Icons.input_outlined, const InputsShowcase()),
      _ShowcaseEntry(
        'Layout & responsive',
        Icons.view_quilt_outlined,
        const LayoutResponsiveShowcase(),
      ),
      _ShowcaseEntry(
        'Loading',
        Icons.hourglass_bottom_outlined,
        const LoadingShowcase(),
      ),
      _ShowcaseEntry('Media', Icons.image_outlined, const MediaShowcase()),
      _ShowcaseEntry(
        'Navigation',
        Icons.navigation_outlined,
        NavigationShowcase(
          themeMode: themeMode,
          onThemeModeChanged: onThemeModeChanged,
        ),
      ),
      _ShowcaseEntry(
        'Selection & states',
        Icons.checklist_outlined,
        const SelectionStatesShowcase(),
      ),
      _ShowcaseEntry('Tabs', Icons.tab_outlined, const TabsShowcase()),
      _ShowcaseEntry(
        'Text & icons',
        Icons.text_fields_outlined,
        const TextIconsShowcase(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('VVK UI Kit'),
        actions: [
          UIThemeToggleButton(
            themeMode: themeMode,
            onThemeModeChanged: onThemeModeChanged,
            tooltipLightMode: 'Light mode',
            tooltipDarkMode: 'Dark mode',
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: entries.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final entry = entries[index];
          return Card(
            child: ListTile(
              leading: Icon(entry.icon),
              title: Text(entry.title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute<void>(builder: (_) => entry.page)),
            ),
          );
        },
      ),
    );
  }
}

class _ShowcaseEntry {
  const _ShowcaseEntry(this.title, this.icon, this.page);

  final String title;
  final IconData icon;
  final Widget page;
}
