import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import 'common.dart';
import 'showcase_scaffold.dart';

class MediaShowcase extends StatelessWidget {
  const MediaShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      title: 'Media',
      child: Column(
        children: [
          ShowcaseTile(
            name: 'UIImage.copyWith',
            child: UIImage(
              kSampleNetworkImage,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ).copyWith(borderRadius: BorderRadius.circular(24)),
          ),
          ShowcaseTile(
            name: 'UIImage (network)',
            child: UIImage(
              kSampleNetworkImage,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          ShowcaseTile(
            name: 'UIImage (SVG asset)',
            child: UIImage(
              kSampleSvgAsset,
              isAsset: true,
              width: 64,
              height: 64,
            ),
          ),
          ShowcaseTile(
            name: 'UISvgAssetIcon',
            child: UISvgAssetIcon(
              assetPath: kSampleSvgAsset,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          ShowcaseTile(
            name: 'UISvgImage.asset',
            child: UISvgImage.asset(
              source: kSampleSvgAsset,
              width: 64,
              height: 64,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          ShowcaseTile(
            name: 'UIImagePreviewFrame',
            child: UIImagePreviewFrame(
              child: imagePreviewImage(
                kSampleNetworkImage,
                fallbackTitle: 'Preview',
              ),
            ),
          ),
          ShowcaseTile(
            name: 'imagePreviewPlaceholder',
            child: UIImagePreviewFrame(
              child: imagePreviewPlaceholder(context, 'No image'),
            ),
          ),
          ShowcaseTile(
            name: 'UIImageScope',
            child: Text(
              'App root is wrapped with UIImageScope in main app.\n'
              'Network images use Image.network via injected builder.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
