import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/loading/ui_shimmer_widget.dart';

/// A shimmer-based page loading skeleton.
class UIShimmerPageLoading extends StatelessWidget {
  /// Creates a [UIShimmerPageLoading].
  const UIShimmerPageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          UIShimmerBase.image(width: double.infinity, height: 30),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                UIShimmerBase.title(lines: 1, height: 12),
                UIShimmerBase.title(
                  width: double.infinity * 0.5,
                  lines: 1,
                  height: 12,
                ),
                Row(
                  children: [
                    UIShimmerBase.title(width: 80, lines: 2, height: 8),
                    const Spacer(),
                    UIShimmerBase.title(width: 80, lines: 1, height: 8),
                  ],
                ),
              ],
            ),
          ),
          ..._item(),
          ..._item(),
          ..._item(),
        ],
      ),
    );
  }

  List<Widget> _item() {
    return [
      const Divider(height: 4, thickness: 6),
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            UIShimmerBase.atv(size: 40),
            const SizedBox(width: 8),
            UIShimmerBase.title(width: 80, lines: 2, height: 8),
          ],
        ),
      ),
      UIShimmerBase.image(width: double.infinity, height: 150),
      Padding(
        padding: const EdgeInsets.all(16).copyWith(top: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            UIShimmerBase.title(width: 40, lines: 1, height: 8),
            UIShimmerBase.title(width: 40, lines: 1, height: 8),
          ],
        ),
      ),
    ];
  }
}

/// A list view skeleton using shimmers.
class UIListViewShimmerLoading extends StatelessWidget {
  /// Creates a [UIListViewShimmerLoading].
  const UIListViewShimmerLoading({super.key, this.item});

  /// Optional item to use instead of the default shimmer item.
  final Widget? item;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.all(0), //none
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (p1, p0) => const Divider(thickness: 2, height: 1),
      itemCount: 20,
      itemBuilder: (_, _) {
        if (item != null) return item!;
        return Padding(
          padding: const EdgeInsets.all(16).copyWith(top: 4, bottom: 4),
          child: Row(
            children: [
              UIShimmerBase.atv(size: 44),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UIShimmerBase.title(width: 80, lines: 1, height: 8),
                    UIShimmerBase.title(
                      width: double.infinity * 0.5,
                      lines: 1,
                      height: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  UIShimmerBase.atv(size: 4),
                  UIShimmerBase.atv(size: 4),
                  UIShimmerBase.atv(size: 4),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
        );
      },
    );
  }
}

/// A grid view skeleton using shimmers.
class UIGripShimmerLoading extends StatelessWidget {
  /// Creates a [UIGripShimmerLoading].
  const UIGripShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 171 / 130,
      ),
      itemCount: 30,
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          children: [
            UIShimmerBase.image(
              width: double.infinity,
              height: double.infinity,
            ),
            UIShimmerBase.title(width: 80, lines: 1, height: 8),
          ],
        );
      },
    );
  }
}

/// Static helpers for common loading skeletons.
class UIPostLoading {
  /// Builds a list view loading skeleton for posts.
  static Widget postListView() {
    return UIListViewShimmerLoading(
      item: Container(
        // height: 150,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UIShimmerBase.atv(size: 44),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UIShimmerBase.title(width: 80, lines: 1, height: 8),
                      UIShimmerBase.title(
                        width: double.infinity * 0.5,
                        lines: 1,
                        height: 8,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    UIShimmerBase.atv(size: 6),
                    UIShimmerBase.atv(size: 6),
                    UIShimmerBase.atv(size: 6),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            UIShimmerBase.title(
              width: double.infinity * 0.5,
              lines: 1,
              height: 12,
            ),
            UIShimmerBase.title(
              width: double.infinity * 0.8,
              lines: 2,
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a detailed post information loading skeleton.
  static Widget postInfo() {
    return _PostInfoLoading();
  }

  /// Builds a comment section loading skeleton.
  static Widget comments() {
    return UIListViewShimmerLoading(
      item: Container(
        // height: 150,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UIShimmerBase.atv(size: 44),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          UIShimmerBase.title(width: 40, lines: 1, height: 8),
                          const SizedBox(width: 8),
                          UIShimmerBase.title(width: 80, lines: 1, height: 8),
                        ],
                      ),
                      const SizedBox(height: 8),
                      UIShimmerBase.title(
                        width: double.infinity * 0.5,
                        lines: 2,
                        height: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PostInfoLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          height: 20,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 12,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 12, backgroundColor: Colors.white),
            const CircleAvatar(radius: 12, backgroundColor: Colors.white),
            const CircleAvatar(radius: 12, backgroundColor: Colors.white),
            const SizedBox(width: 8),
            Container(
              height: 12,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(color: Colors.white, child: const ListTile()),
        const SizedBox(height: 4),
        Container(color: Colors.white, child: const ListTile()),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                height: 24,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 24,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
