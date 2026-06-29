import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import 'common.dart';
import 'showcase_scaffold.dart';

class FeedbackShowcase extends StatefulWidget {
  const FeedbackShowcase({super.key});

  @override
  State<FeedbackShowcase> createState() => _FeedbackShowcaseState();
}

class _FeedbackShowcaseState extends State<FeedbackShowcase> {
  bool _shimmerLoading = true;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _shimmerLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      title: 'Feedback',
      child: Column(
        children: [
          ShowcaseTile(
            name: 'UISnackbar.show',
            child: Row(
              children: [
                Expanded(
                  child: UIPrimaryTextButton(
                    text: 'Success',
                    onPressed: () => UISnackbar.show(
                      context: context,
                      message: 'Saved successfully',
                      style: snackbarStyle(context),
                      type: UISnackbarType.success,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: UIPrimaryTextButton(
                    text: 'Error',
                    hasBorder: true,
                    onPressed: () => UISnackbar.show(
                      context: context,
                      message: 'Something went wrong',
                      style: snackbarStyle(context),
                      type: UISnackbarType.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UIEmptyState',
            child: UIEmptyState(
              icon: Icons.inbox_outlined,
              message: 'No items yet',
            ),
          ),
          ShowcaseTile(
            name: 'UISkeletonPlaceholder',
            child: const UISkeletonPlaceholder(
              width: double.infinity,
              height: 80,
            ),
          ),
          ShowcaseTile(
            name: 'UIBadge',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                UIBadge.text(context, label: 'Primary'),
                const UIBadge.secondary(child: Text('Secondary')),
                const UIBadge.outline(child: Text('Outline')),
                const UIBadge.destructive(child: Text('Error')),
                const UIBadge.live(child: Text('LIVE')),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UIAlert',
            child: Column(
              children: const [
                UIAlert(
                  title: 'Update available',
                  description: 'A new version is ready to install.',
                ),
                SizedBox(height: 8),
                UIAlert.destructive(
                  title: 'Delete account',
                  description: 'This action cannot be undone.',
                ),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UIPopover',
            child: _PopoverDemo(),
          ),
          ShowcaseTile(
            name: 'UITourController',
            child: _TourDemo(),
          ),
          ShowcaseTile(
            name: 'UITooltip',
            child: UITooltip(
              message: 'Tooltip via UIPortal',
              child: UIPrimaryTextButton(
                text: 'Long press me',
                onPressed: () {},
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UILiveBadge',
            child: UILiveBadge(style: liveBadgeStyle(context), label: 'LIVE'),
          ),
          ShowcaseTile(
            name: 'UINoteList',
            child: UINoteList(
              title: 'Notes',
              notes: const [
                UIText('First note item'),
                UIText('Second note item'),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UIShimmerLoadingContainer',
            child: UIShimmerLoadingContainer(
              type: UIShimmerLoadingType.list,
              isLoading: _shimmerLoading,
              child: const ListTile(
                title: Text('Loaded content'),
                subtitle: Text('Shimmer hides after 3 seconds'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PopoverDemo extends StatefulWidget {
  @override
  State<_PopoverDemo> createState() => _PopoverDemoState();
}

class _TourDemo extends StatefulWidget {
  @override
  State<_TourDemo> createState() => _TourDemoState();
}

class _TourDemoState extends State<_TourDemo> {
  final _searchKey = GlobalKey();
  final _filterKey = GlobalKey();

  void _startTour() {
    final tour = UITourController.fromTheme(
      context,
      steps: [
        UITourStep(
          key: _searchKey,
          title: 'Search',
          description: 'Look up items quickly from here.',
          showPulse: true,
        ),
        UITourStep(
          key: _filterKey,
          title: 'Filters',
          description: 'Narrow results with filters.',
          isLast: true,
          preferredPosition: UITourTooltipPosition.top,
        ),
      ],
      onComplete: () => UISnackbar.show(
        context: context,
        message: 'Tour complete',
        style: snackbarStyle(context),
      ),
    );
    tour.start();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: UIPrimaryTextButton(
                key: _searchKey,
                text: 'Search',
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: UIPrimaryTextButton(
                key: _filterKey,
                text: 'Filters',
                hasBorder: true,
                onPressed: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        UIPrimaryTextButton(
          text: 'Start product tour',
          onPressed: _startTour,
        ),
      ],
    );
  }
}

class _PopoverDemoState extends State<_PopoverDemo> {
  final _controller = UIAnchoredOverlayController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UIPopover.fromTheme(
      context,
      controller: _controller,
      showScrim: true,
      showCloseButton: true,
      content: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          UIText('Coach mark', fontWeight: FontWeight.w700),
          SizedBox(height: 4),
          UIText('Rich popover with arrow and scrim.'),
        ],
      ),
      child: UIPrimaryTextButton(
        text: 'Show popover',
        onPressed: _controller.show,
      ),
    );
  }
}
