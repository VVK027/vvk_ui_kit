import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import 'common.dart';
import 'showcase_scaffold.dart';

/// Showcase for glassmorphism components.

class GlassShowcase extends StatefulWidget {
  const GlassShowcase({super.key});

  @override
  State<GlassShowcase> createState() => _GlassShowcaseState();
}

class _GlassShowcaseState extends State<GlassShowcase> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      title: 'Glassmorphism UI',
      child: Column(
        children: [
          ShowcaseTile(
            name: 'UIGlassSurface',
            child: Container(
              height: 180,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blueAccent, Colors.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: UIGlassSurface(
                  width: 260,
                  height: 100,
                  borderRadius: 16,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.blur_on_rounded, color: Colors.white, size: 28),
                      SizedBox(height: 6),
                      UIText(
                        'Frosted Glass Surface',
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIGlassCard & UIGlassButton',
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepOrange, Colors.amber, Colors.redAccent],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: UIGlassCard.fromTheme(
                context,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const UIText(
                      'Glass Card Container',
                      size: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    const UIText(
                      'Subtle frosted backdrop suited for dark and vibrant gradient themes.',
                      color: Colors.white70,
                    ),
                    const SizedBox(height: 16),
                    UIGlassButton.fromTheme(
                      context,
                      label: 'Glass Action',
                      icon: const Icon(Icons.flash_on_rounded, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIGlassBottomNavBar',
            child: Container(
              height: 160,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.blue, Colors.cyan],
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: UIGlassBottomNavBar.fromTheme(
                    context,
                    currentIndex: _navIndex,
                    onTap: (index) => setState(() => _navIndex = index),
                    items: const [
                      UIGlassBottomNavBarItem(
                        icon: Icon(Icons.dashboard_outlined),
                        label: 'Home',
                      ),
                      UIGlassBottomNavBarItem(
                        icon: Icon(Icons.explore_outlined),
                        label: 'Explore',
                      ),
                      UIGlassBottomNavBarItem(
                        icon: Icon(Icons.person_outline),
                        label: 'Profile',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIGlassScaffold & UIGlassAppBar',
            child: UIPrimaryTextButton(
              text: 'Launch Full Glass Screen',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (ctx) => UIGlassScaffold.fromTheme(
                      ctx,
                      appBar: UIGlassAppBar.fromTheme(
                        ctx,
                        title: 'Glass Screen Preview',
                      ),
                      body: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.deepPurple, Colors.blueAccent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: UIGlassCard.fromTheme(
                              ctx,
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.auto_awesome,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 12),
                                  const UIText(
                                    'Full Screen Glass Scaffold',
                                    size: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 16),
                                  UIPrimaryTextButton(
                                    text: 'Close Demo',
                                    onPressed: () => Navigator.of(ctx).pop(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
