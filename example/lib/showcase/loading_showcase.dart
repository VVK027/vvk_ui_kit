import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import 'common.dart';
import 'showcase_scaffold.dart';

class _DemoItem {
  const _DemoItem(this.id, this.title);
  final int id;
  final String title;
}

class LoadingShowcase extends StatefulWidget {
  const LoadingShowcase({super.key});

  @override
  State<LoadingShowcase> createState() => _LoadingShowcaseState();
}

class _LoadingShowcaseState extends State<LoadingShowcase> {
  bool _overlayVisible = false;

  Future<(List<_DemoItem>, int)> _loadData(int page, int limit) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final start = (page - 1) * limit;
    final items = List.generate(
      limit,
      (i) => _DemoItem(start + i + 1, 'Item ${start + i + 1}'),
    );
    return (items, 20);
  }

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      title: 'Loading',
      child: Column(
        children: [
          ShowcaseTile(
            name: 'UILoadingIndicator',
            child: const UILoadingIndicator(),
          ),
          ShowcaseTile(
            name: 'UILoadingIndicator.compact',
            child: const UILoadingIndicator.compact(),
          ),
          ShowcaseTile(
            name: 'UILoadingOverlay',
            child: SizedBox(
              height: 120,
              child: UILoadingOverlay(
                visible: _overlayVisible,
                child: Center(
                  child: UIPrimaryTextButton(
                    text: _overlayVisible ? 'Loading…' : 'Toggle overlay',
                    onPressed: () {
                      setState(() => _overlayVisible = !_overlayVisible);
                      if (_overlayVisible) {
                        Future<void>.delayed(const Duration(seconds: 2), () {
                          if (mounted) setState(() => _overlayVisible = false);
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIShimmer',
            child: UIShimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                children: List.generate(
                  3,
                  (_) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Container(height: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIShimmerBase',
            child: Column(
              children: [
                UIShimmerBase.image(width: double.infinity, height: 60),
                const SizedBox(height: 8),
                UIShimmerBase.atv(size: 48),
                const SizedBox(height: 8),
                UIShimmerBase.title(lines: 2),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UIShimmerPageLoading',
            child: const SizedBox(height: 200, child: UIShimmerPageLoading()),
          ),
          ShowcaseTile(
            name: 'UIListViewShimmerLoading',
            child: const SizedBox(
              height: 160,
              child: UIListViewShimmerLoading(),
            ),
          ),
          ShowcaseTile(
            name: 'UIGripShimmerLoading',
            child: const SizedBox(height: 120, child: UIGripShimmerLoading()),
          ),
          ShowcaseTile(
            name: 'UIPostLoading.postListView',
            child: SizedBox(height: 160, child: UIPostLoading.postListView()),
          ),
          ShowcaseTile(
            name: 'UIPostLoading.postInfo / comments',
            child: Column(
              children: [
                SizedBox(height: 100, child: UIPostLoading.postInfo()),
                const SizedBox(height: 8),
                SizedBox(height: 80, child: UIPostLoading.comments()),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UILoadMoreContainer',
            child: SizedBox(
              height: 220,
              child: UILoadMoreContainer<_DemoItem>(
                limit: 5,
                onLoadData: _loadData,
                itemBuilder: (_, item, index) =>
                    ListTile(title: Text(item.title)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
