import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import 'common.dart';
import 'showcase_scaffold.dart';

class AnimShowcase extends StatefulWidget {
  const AnimShowcase({super.key});

  @override
  State<AnimShowcase> createState() => _AnimShowcaseState();
}

class _AnimShowcaseState extends State<AnimShowcase> {
  int _animKey = 0;

  void _replay() {
    setState(() {
      _animKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = List.generate(
      4,
      (i) => Card(
        child: ListTile(
          leading: CircleAvatar(child: Text('${i + 1}')),
          title: Text('Staggered item ${i + 1}'),
        ),
      ),
    );

    return ShowcaseScaffold(
      title: 'Animation',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                UIElevatedIconButton(
                  icon: Icons.replay_rounded,
                  label: 'Replay',
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  onPressed: _replay,
                ),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'Staggered list entrance',
            child: KeyedSubtree(
              key: ValueKey('staggered_$_animKey'),
              child: UIAnimationLimiter(
                child: Column(
                  children: UIAnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 350),
                    childAnimationBuilder: (child) => UIFadeInAnimation(
                      child: UISlideInAnimation(
                        verticalOffset: 24,
                        child: child,
                      ),
                    ),
                    children: items,
                  ),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'AnimatedGestureDetector',
            child: AnimatedGestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Tap me'),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIRippleGlow',
            child: Center(
              child: UIRippleGlow(
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIFlipAnimation + UIScaleInAnimation',
            child: InkWell(
              onTap: _replay,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    KeyedSubtree(
                      key: ValueKey('flip_scale_$_animKey'),
                      child: UIAnimationConfiguration.synchronized(
                        duration: const Duration(milliseconds: 500),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                UIFlipAnimation(
                                  duration: const Duration(milliseconds: 500),
                                  flipAxis: UIFlipAxis.x,
                                  child: Icon(
                                    Icons.credit_card_rounded,
                                    size: 48,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const UIText('Flip X', size: 12),
                              ],
                            ),
                            Column(
                              children: [
                                UIFlipAnimation(
                                  duration: const Duration(milliseconds: 500),
                                  flipAxis: UIFlipAxis.y,
                                  child: Icon(
                                    Icons.style_rounded,
                                    size: 48,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const UIText('Flip Y', size: 12),
                              ],
                            ),
                            Column(
                              children: [
                                UIScaleInAnimation(
                                  duration: const Duration(milliseconds: 500),
                                  child: Icon(
                                    Icons.notifications_active_rounded,
                                    size: 48,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const UIText('Scale In', size: 12),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    UIPrimaryTextButton(
                      text: 'Tap to Replay Animations',
                      onPressed: _replay,
                    ),
                  ],
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UITapGuard',
            child: UITapGuard(
              onTap: () async {
                await Future<void>.delayed(const Duration(milliseconds: 800));
              },
              builder: (context, onTap) => UIPrimaryTextButton(
                text: 'Guarded async tap',
                onPressed: onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
