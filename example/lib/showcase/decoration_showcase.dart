import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import 'common.dart';
import 'showcase_scaffold.dart';

class DecorationShowcase extends StatelessWidget {
  const DecorationShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.tertiary,
      ],
    );

    return ShowcaseScaffold(
      title: 'Decoration',
      child: Column(
        children: [
          ShowcaseTile(
            name: 'UIGradientBox',
            child: UIGradientBox(
              gradient: gradient,
              child: const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Gradient box',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIGradientText',
            child: UIGradientText(
              'Gradient text',
              gradient: gradient,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          ShowcaseTile(
            name: 'UIGradientSvgIcon',
            child: Center(
              child: UIGradientSvgIcon(
                assetName: kSampleSvgAsset,
                gradient: gradient,
                width: 64,
                height: 64,
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIDottedBorder',
            child: UIDottedBorder(
              radius: 12,
              padding: const EdgeInsets.all(24),
              child: const Text('Dotted outline container'),
            ),
          ),
          ShowcaseTile(
            name: 'UIGlassCard',
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.tertiary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Positioned.fill(
                  child: UIGlassCard.fromTheme(
                    context,
                    child: const UIText(
                      'Frosted glass card',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UIGlassSurface + UIGlassTheme',
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(gradient: gradient),
                ),
                Positioned.fill(
                  child: UIGlassSurface(
                    theme: UIGlassTheme.fromTheme(context),
                    margin: const EdgeInsets.all(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow
                            .withValues(alpha: 0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    padding: const EdgeInsets.all(16),
                    child: const UIText(
                      'Themed glass surface',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UICornerRibbon',
            child: UICornerRibbon(
              message: 'NEW',
              location: UICornerRibbonLocation.topEnd,
              child: Container(
                width: double.infinity,
                height: 100,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                alignment: Alignment.center,
                child: const Text('Product card'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
