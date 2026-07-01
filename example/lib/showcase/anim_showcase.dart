import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import 'common.dart';
import 'showcase_scaffold.dart';

class AnimShowcase extends StatelessWidget {
  const AnimShowcase({super.key});

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
          ShowcaseTile(
            name: 'Staggered list entrance',
            child: UIAnimationLimiter(
              child: Column(
                children: UIAnimationConfiguration.toStaggeredList(
                  childAnimationBuilder: (child) => UIFadeInAnimation(
                    child: UISlideInAnimation(verticalOffset: 24, child: child),
                  ),
                  children: items,
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
            name: 'UIAvatarGlow',
            child: Center(
              child: UIAvatarGlow(
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
            child: UIAnimationConfiguration.synchronized(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  UIFlipAnimation(
                    child: Icon(
                      Icons.credit_card,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  UIScaleInAnimation(
                    child: Icon(
                      Icons.notifications,
                      size: 48,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ],
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
