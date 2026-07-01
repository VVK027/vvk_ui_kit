import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import 'common.dart';
import 'showcase_scaffold.dart';

class AccordionCardsClipsShowcase extends StatelessWidget {
  const AccordionCardsClipsShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = expansionStyle(context);

    return ShowcaseScaffold(
      title: 'Accordion, cards & clips',
      child: Column(
        children: [
          ShowcaseTile(
            name: 'UIExpansionTile',
            child: UIExpansionTile(
              title: 'Expansion tile',
              style: style,
              children: const [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Expandable content goes here.'),
                ),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UIAccordion (multi-expand)',
            child: UIExpansionAccord(
              allowMultipleExpansion: true,
              style: style,
              items: [
                UIExpansionAccordItem(
                  title: 'Section A',
                  style: style,
                  content: const Text('Content for section A'),
                ),
                UIExpansionAccordItem(
                  title: 'Section B',
                  style: style,
                  content: const Text('Content for section B'),
                ),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UIAccordion',
            child: UIExpansionAccord(
              style: style,
              items: [
                UIExpansionAccordItem(
                  title: 'Section A',
                  style: style,
                  content: const Text('Content for section A'),
                ),
                UIExpansionAccordItem(
                  title: 'Section B',
                  style: style,
                  content: const Text('Content for section B'),
                ),
              ],
            ),
          ),
          ShowcaseTile(name: 'UIAnimatedFlipCard', child: _FlipCardDemo()),
          ShowcaseTile(
            name: 'UICard + UICardTopContainer',
            child:
                UICard(
                  elevation: 2,
                  child: Column(
                    children: [
                      UICardTopContainer(
                        title: 'Overview',
                        isViewAll: true,
                        viewAllLabel: 'View all',
                        iconData: Icons.insights,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: UIText('Card body content'),
                      ),
                    ],
                  ),
                ).copyWith(
                  card: const UICardProps(clipBehavior: Clip.antiAlias),
                  borderRadius: 12,
                ),
          ),
          ShowcaseTile(
            name: 'UIHexagon',
            child: Center(
              child: UIHexagon(
                width: 120,
                height: 120,
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: const Center(child: Icon(Icons.star)),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UISharpCorners',
            child: UISharpCorners(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: const Text('Diagonal corner cuts'),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UICouponCard',
            child: UICouponCard.fromTheme(
              context,
              height: 140,
              curvePosition: 56,
              firstChild: ColoredBox(
                color: theme.colorScheme.primaryContainer,
                child: Center(
                  child: UIText(
                    '23% OFF',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              secondChild: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    UIText(
                      'SUMMER23',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    UIText(
                      'Valid until Aug 31',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UICouponClip',
            child: UICouponClip(
              curvePosition: 72,
              child: Container(
                width: double.infinity,
                height: 120,
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: const Center(child: Text('Custom coupon clip only')),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UITicketClip',
            child: UITicketClip(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: const Text('Ticket / coupon shape'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FlipCardDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UIAnimatedFlipCard.fromTheme(
      context,
      front: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.credit_card, size: 40),
          SizedBox(height: 8),
          UIText('Tap to flip', textAlign: TextAlign.center),
        ],
      ),
      back: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline,
            size: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 8),
          const UIText('Back face', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
