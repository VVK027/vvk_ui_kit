import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

const kSampleNetworkImage =
    'https://picsum.photos/seed/flutter-ui-kit/200/200.jpg';
const kSampleSvgAsset = 'assets/icons/sample.svg';

UIExpansionTileStyle expansionStyle(BuildContext context) {
  final theme = Theme.of(context);
  return UIExpansionTileStyle(
    borderColor: theme.dividerColor,
    titleStyle: theme.textTheme.titleMedium!,
    iconColor: theme.iconTheme.color ?? theme.colorScheme.onSurface,
  );
}

UISnackbarStyle snackbarStyle(BuildContext context) {
  final theme = Theme.of(context);
  return UISnackbarStyle(
    backgroundColor: theme.colorScheme.inverseSurface,
    textStyle: theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.onInverseSurface,
    ),
    successColor: Colors.green,
    errorColor: theme.colorScheme.error,
    closeIconColor: theme.colorScheme.onInverseSurface,
  );
}

UIOverlayDropdownStyle overlayDropdownStyle(BuildContext context) {
  final theme = Theme.of(context);
  return UIOverlayDropdownStyle(
    backgroundColor: theme.colorScheme.surface,
    borderColor: theme.dividerColor,
    focusedBorderColor: theme.colorScheme.primary,
    labelStyle: theme.textTheme.bodyMedium!,
    itemStyle: theme.textTheme.bodyMedium!,
    selectedBackgroundColor: theme.colorScheme.primaryContainer,
    selectedBorderColor: theme.colorScheme.primary,
    menuBackgroundColor: theme.colorScheme.surface,
    menuBorderColor: theme.dividerColor,
  );
}

UIAlertPanelStyle alertPanelStyle(BuildContext context) {
  final theme = Theme.of(context);
  return UIAlertPanelStyle(
    backgroundColor: theme.colorScheme.surface,
    titleStyle: theme.textTheme.titleLarge!,
    descriptionStyle: theme.textTheme.bodyMedium!,
    closeButtonColor: theme.colorScheme.surfaceContainerHighest,
    closeIconColor: theme.colorScheme.onSurface,
    scrimColor: Colors.black54,
  );
}

UIShellDialogStyle shellDialogStyle(BuildContext context) {
  final theme = Theme.of(context);
  return UIShellDialogStyle(
    backgroundColor: theme.colorScheme.surface,
    titleStyle: theme.textTheme.titleLarge!,
    contentStyle: theme.textTheme.bodyMedium!,
    closeButtonColor: theme.colorScheme.surfaceContainerHighest,
    closeIconColor: theme.colorScheme.onSurface,
  );
}

UILiveBadgeStyle liveBadgeStyle(BuildContext context) {
  final theme = Theme.of(context);
  return UILiveBadgeStyle(
    backgroundColor: theme.colorScheme.errorContainer,
    textStyle: theme.textTheme.labelSmall!.copyWith(
      color: theme.colorScheme.onErrorContainer,
    ),
    dotColor: theme.colorScheme.error,
  );
}

class ShowcaseSection extends StatelessWidget {
  const ShowcaseSection({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class ShowcaseTile extends StatelessWidget {
  const ShowcaseTile({super.key, required this.name, required this.child});

  final String name;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              name,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontFamily: 'monospace'),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
