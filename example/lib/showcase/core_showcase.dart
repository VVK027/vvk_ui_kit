import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import 'common.dart';
import 'showcase_scaffold.dart';

class CoreShowcase extends StatelessWidget {
  const CoreShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    const sample = 'hello world';
    const email = 'user@example.com';

    return ShowcaseScaffold(
      title: 'Core utilities',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ShowcaseSection(
            title: 'Extensions',
            child: ShowcaseTile(
              name: 'StringExtension',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'capitalizeFirstLetter: ${sample.capitalizeFirstLetter()}',
                  ),
                  Text(
                    'equalsIgnoreCase: ${sample.equalsIgnoreCase('HELLO WORLD')}',
                  ),
                  Text('toDouble: ${'3.14'.toDouble()}'),
                ],
              ),
            ),
          ),
          ShowcaseSection(
            title: 'Extensions',
            child: ShowcaseTile(
              name: 'DoubleExtension',
              child: Text(
                'roundToDecimal: ${3.14159.roundToDecimal(places: 2)}',
              ),
            ),
          ),
          ShowcaseSection(
            title: 'StringUtils',
            child: ShowcaseTile(
              name: 'StringUtils',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('validEmail($email): ${StringUtils.validEmail(email)}'),
                  Text(
                    'isValidBasicEmail: ${StringUtils.isValidBasicEmail(email)}',
                  ),
                  Text(
                    'getShortNamedString: ${StringUtils.getShortNamedString('John Michael Doe')}',
                  ),
                ],
              ),
            ),
          ),
          ShowcaseSection(
            title: 'UIDateTimeUtil',
            child: ShowcaseTile(
              name: 'UIDateTimeUtil',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'getFormattedDate: ${DateTimeUtil.getFormattedDate(now)}',
                  ),
                  Text(
                    'getCurrentHourMin: ${DateTimeUtil.getCurrentHourMin()}',
                  ),
                  Text(
                    'formatDuration: ${DateTimeUtil.formatDuration(const Duration(hours: 1, minutes: 5))}',
                  ),
                ],
              ),
            ),
          ),
          ShowcaseSection(
            title: 'Widget helpers',
            child: Column(
              children: [
                ShowcaseTile(
                  name: 'textStyle / textSpan',
                  child: RichText(
                    text: TextSpan(
                      children: [
                        textSpan(
                          'Tap me',
                          Colors.blue,
                          FontWeight.w600,
                          14,
                          onTap: () {},
                        ),
                        const TextSpan(text: ' or '),
                        textSpan('ignore', Colors.grey, FontWeight.normal, 14),
                      ],
                    ),
                  ),
                ),
                ShowcaseTile(
                  name: 'buildUILabel',
                  child: buildUILabel(
                    'Default label',
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    size: 14,
                  ),
                ),
                ShowcaseTile(
                  name: 'getMaxLines / getTextHeight',
                  child: Builder(
                    builder: (context) {
                      const text = 'Multiline layout helper demo text';
                      final style = Theme.of(context).textTheme.bodyMedium!;
                      const width = 160.0;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Lines: ${getMaxLines(text, style, width)}'),
                          Text(
                            'Height: ${getTextHeight(context, text, style, width, 2).toStringAsFixed(1)}',
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          ShowcaseSection(
            title: 'Translations',
            child: ShowcaseTile(
              name: 'Translations / TranslationCache',
              child: Builder(
                builder: (context) {
                  final t = Translations({
                    'greeting': 'Hello, {name}!',
                    'items': 'You have {count} items.',
                  });
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.tr('greeting', namedArgs: {'name': 'World'})),
                      Text(t.tr('items', namedArgs: {'count': '3'})),
                      Text(t.tr('missing_key')),
                    ],
                  );
                },
              ),
            ),
          ),
          ShowcaseSection(
            title: 'JsonHelper / Mapper',
            child: ShowcaseTile(
              name: 'JsonHelper / Mapper contracts',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UserDto JSON: ${_DemoUserDto(name: 'Ada', email: 'ada@example.com').toJson()}',
                  ),
                  Text(
                    'Mapped entity: ${_DemoUserMapper(_DemoUserDto(name: 'Ada', email: 'ada@example.com')).toEntity()}',
                  ),
                ],
              ),
            ),
          ),
          ShowcaseSection(
            title: 'JsonUtils',
            child: ShowcaseTile(
              name: 'JsonUtils',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('asInt("42"): ${JsonUtils.asInt("42")}'),
                  Text('asBool("true"): ${JsonUtils.asBool("true")}'),
                  Text(
                    'asMap keys: ${JsonUtils.asMap({"a": 1}).keys.join(", ")}',
                  ),
                ],
              ),
            ),
          ),
          ShowcaseSection(
            title: 'Typography',
            child: ShowcaseTile(
              name: 'UITypography',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Heading 1',
                    style: UITypography.h1(
                      Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'Body text',
                    style: UITypography.body(
                      Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'Muted',
                    style: UITypography.muted(
                      Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ShowcaseSection(
            title: 'Theme palettes',
            child: ShowcaseTile(
              name: 'UIAppTheme.zinc / slate / stone',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _PaletteSwatch(
                    label: 'Zinc',
                    color: UIThemePalettes.zincLight.accent,
                  ),
                  _PaletteSwatch(
                    label: 'Slate',
                    color: UIThemePalettes.slateLight.accent,
                  ),
                  _PaletteSwatch(
                    label: 'Stone',
                    color: UIThemePalettes.stoneLight.accent,
                  ),
                  _PaletteSwatch(
                    label: 'Teal',
                    color: UIThemePalettes.tealLight.accent,
                  ),
                ],
              ),
            ),
          ),
          ShowcaseSection(
            title: 'UIThemeContext',
            child: ShowcaseTile(
              name: 'context.uiTheme',
              child: Container(
                padding: const EdgeInsets.all(12),
                color: context.uiTheme.chartBackground,
                child: Text(
                  'Subtitle color: ${context.uiTheme.subtitleColor}',
                  style: TextStyle(color: context.uiTheme.subtitleColor),
                ),
              ),
            ),
          ),
          ShowcaseSection(
            title: 'NavigationUtil',
            child: Column(
              children: [
                ShowcaseTile(
                  name: 'NavigationUtil.pushPage',
                  child: UIPrimaryTextButton(
                    text: 'Push demo page',
                    onPressed: () {
                      NavigationUtil.pushPage(
                        context,
                        Scaffold(
                          appBar: AppBar(title: const Text('Pushed page')),
                          body: Center(
                            child: UIPrimaryTextButton(
                              text: 'Pop',
                              onPressed: () => NavigationUtil.pop(context),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ShowcaseTile(
                  name: 'NavigationUtil.pushPageWithEntrance',
                  child: UIPrimaryTextButton(
                    text: 'Entrance transition',
                    onPressed: () {
                      NavigationUtil.pushPageWithEntrance(
                        context,
                        Scaffold(
                          appBar: AppBar(title: const Text('Entrance')),
                          body: Center(
                            child: UIPrimaryTextButton(
                              text: 'Pop',
                              onPressed: () => NavigationUtil.pop(context),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ShowcaseTile(
                  name: 'NavigationUtil.pushPageWithDrillIn',
                  child: UIPrimaryTextButton(
                    text: 'Drill-in transition',
                    onPressed: () {
                      NavigationUtil.pushPageWithDrillIn(
                        context,
                        Scaffold(
                          appBar: AppBar(title: const Text('Drill in')),
                          body: Center(
                            child: UIPrimaryTextButton(
                              text: 'Pop',
                              onPressed: () => NavigationUtil.pop(context),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaletteSwatch extends StatelessWidget {
  const _PaletteSwatch({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            boxShadow: UIShadows.sm,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _DemoUserDto implements JsonHelper {
  const _DemoUserDto({required this.name, required this.email});

  final String name;
  final String email;

  @override
  Map<String, dynamic>? toJson() => {'name': name, 'email': email};
}

class _DemoUserMapper implements Mapper<String> {
  const _DemoUserMapper(this.dto);

  final _DemoUserDto dto;

  @override
  String toEntity() => '${dto.name} <${dto.email}>';
}
