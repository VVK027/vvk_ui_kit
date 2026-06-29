import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import 'common.dart';
import 'showcase_scaffold.dart';

class SelectionStatesShowcase extends StatefulWidget {
  const SelectionStatesShowcase({super.key});

  @override
  State<SelectionStatesShowcase> createState() =>
      _SelectionStatesShowcaseState();
}

class _SelectionStatesShowcaseState extends State<SelectionStatesShowcase> {
  String? _radioValue = 'english';
  bool _checkboxValue = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ShowcaseScaffold(
      title: 'Selection & states',
      child: Column(
        children: [
          ShowcaseTile(
            name: 'UIRoundedCheckbox',
            child: UIRoundedCheckbox(
              value: _checkboxValue,
              label: 'Enable notifications',
              onChanged: (v) => setState(() => _checkboxValue = v),
            ),
          ),
          ShowcaseTile(
            name: 'UIRadioGroup',
            child: UIRadioGroup<String>(
              value: _radioValue,
              onChanged: (v) => setState(() => _radioValue = v),
              children: const [
                UIRadio<String>(value: 'english', label: 'English'),
                UIRadio<String>(value: 'spanish', label: 'Spanish'),
                UIRadio<String>(value: 'french', label: 'French'),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UIListTileSelect.copyWith',
            child: UIListTileSelect(
              title: 'Language',
              titleSelection: 'English',
              titleColor: theme.colorScheme.onSurface,
              subtitleColor: theme.colorScheme.outline,
              selectedTitleColor: theme.colorScheme.primary,
              unselectedTitleColor: theme.colorScheme.onSurface,
              arrowColor: theme.colorScheme.primary,
              showArrow: true,
              onSelectTap: () {},
            ).copyWith(listTile: const UIListTileProps(dense: true)),
          ),
          ShowcaseTile(
            name: 'UIListTileSelect',
            child: UIListTileSelect(
              title: 'Language',
              titleSelection: 'English',
              titleColor: theme.colorScheme.onSurface,
              subtitleColor: theme.colorScheme.outline,
              selectedTitleColor: theme.colorScheme.primary,
              unselectedTitleColor: theme.colorScheme.onSurface,
              arrowColor: theme.colorScheme.primary,
              showArrow: true,
              onSelectTap: () {},
            ),
          ),
          ShowcaseTile(
            name: 'UISwipeActionTile',
            child: _SwipeActionTileDemo(),
          ),
          ShowcaseTile(
            name: 'UIErrorInfo',
            child: SizedBox(
              height: 240,
              child: UIErrorInfo(
                title: 'Connection error',
                description: 'Please check your network and try again.',
                btnText: 'Retry',
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeActionTileDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return UISwipeActionTile(
      actions: [
        UISwipeAction(
          icon: Icons.archive_outlined,
          label: 'Archive',
          backgroundColor: scheme.primary,
          onTap: () {},
        ),
        UISwipeAction(
          icon: Icons.delete_outline,
          label: 'Delete',
          backgroundColor: scheme.error,
          onTap: () {},
        ),
      ],
      child: const ListTile(
        leading: Icon(Icons.mail_outline),
        title: UIText('Inbox message'),
        subtitle: UIText('Swipe left to reveal actions'),
      ),
    );
  }
}
