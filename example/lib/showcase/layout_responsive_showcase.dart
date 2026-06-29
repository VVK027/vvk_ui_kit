import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import 'common.dart';
import 'showcase_scaffold.dart';

class LayoutResponsiveShowcase extends StatelessWidget {
  const LayoutResponsiveShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.fromContext(context);

    return ShowcaseScaffold(
      title: 'Layout & responsive',
      child: Column(
        children: [
          ShowcaseTile(
            name: 'UIDivider',
            child: UIDivider(color: Theme.of(context).dividerColor),
          ),
          ShowcaseTile(
            name: 'UIDashedDivider + UICenteredTextDivider',
            child: Column(
              children: [
                const UIDashedDivider(),
                const SizedBox(height: 12),
                UICenteredTextDivider(
                  text: 'OR',
                  lineColor: Theme.of(context).colorScheme.outline,
                ),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UISeparatedRow + UISeparatedColumn',
            child: Column(
              children: [
                UISeparatedRow(
                  separatorBuilder: (_, _) => const UISpacing.horizontal(8),
                  children: const [
                    Chip(label: Text('Flutter')),
                    Chip(label: Text('Dart')),
                    Chip(label: Text('UI Kit')),
                  ],
                ),
                const SizedBox(height: 12),
                UISeparatedColumn(
                  separatorBuilder: (_, _) => const Divider(height: 16),
                  children: const [
                    ListTile(title: Text('First')),
                    ListTile(title: Text('Second')),
                    ListTile(title: Text('Third')),
                  ],
                ),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UIKeyboardToolbar',
            child: const UIKeyboardToolbarHost(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Focus to see toolbar (on device)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIKeyboardDismissArea',
            child: UIKeyboardDismissArea(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Tap outside to dismiss keyboard',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIFixedSectionListView',
            child: SizedBox(
              height: 160,
              child: UIFixedSectionListView(
                sections: const [
                  ListTile(title: Text('Section item 1')),
                  ListTile(title: Text('Section item 2')),
                  ListTile(title: Text('Section item 3')),
                ],
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIPageScaffold',
            child: UIPrimaryTextButton(
              text: 'Open page scaffold',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => UIPageScaffold(
                    appBar: AppBar(title: const Text('Page scaffold')),
                    maxContentWidth: 480,
                    body: Column(
                      children: List.generate(
                        8,
                        (i) => ListTile(title: Text('Centered item $i')),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIExpandableFloatingPanel',
            child: Align(
              alignment: Alignment.centerRight,
              child: UIExpandableFloatingPanel.fromTheme(
                context,
                title: const UIText('Quick actions', fontWeight: FontWeight.w700),
                toggleIconBuilder: (expanded) => Icon(
                  expanded ? Icons.close_rounded : Icons.add_rounded,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(Icons.share_outlined),
                      title: Text('Share'),
                    ),
                    ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Edit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIGlassScaffold',
            child: SizedBox(
              height: 280,
              child: UIGlassScaffold.fromTheme(
                context,
                appBar: UIGlassAppBar.fromTheme(context, title: 'Glass screen'),
                body: const Center(
                  child: UIText('Content over gradient background'),
                ),
                bottomNavigationBar: const SizedBox(
                  height: 56,
                  child: Center(child: UIText('Glass bottom chrome')),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIScrollableScreen',
            child: SizedBox(
              height: 200,
              child: UIScrollableScreen(
                child: Column(
                  children: List.generate(
                    5,
                    (i) => ListTile(title: Text('Scrollable item $i')),
                  ),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'Responsive.fromContext',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Width: ${responsive.size.width.toStringAsFixed(0)}'),
                Text('isMobile: ${responsive.isMobile}'),
                Text('isTablet: ${responsive.isTablet}'),
                Text('isDesktop: ${responsive.isDesktop}'),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'ResponsiveLayout',
            child: ResponsiveLayout(
              mobile: const _LayoutChip(label: 'Mobile'),
              tablet: const _LayoutChip(label: 'Tablet'),
              desktop: const _LayoutChip(label: 'Desktop'),
            ),
          ),
          ShowcaseTile(
            name: 'ResponsiveProvider',
            child: ResponsiveProvider(
              child: Builder(
                builder: (context) {
                  final data = Responsive.of(context);
                  return Text('Via provider — mobile: ${data.isMobile}');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LayoutChip extends StatelessWidget {
  const _LayoutChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}
