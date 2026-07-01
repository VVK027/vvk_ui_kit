import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import 'common.dart';
import 'showcase_scaffold.dart';

class CarouselShowcase extends StatefulWidget {
  const CarouselShowcase({super.key});

  @override
  State<CarouselShowcase> createState() => _CarouselShowcaseState();
}

class _CarouselShowcaseState extends State<CarouselShowcase> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const items = ['One', 'Two', 'Three'];

    return ShowcaseScaffold(
      title: 'Carousel',
      child: Column(
        children: [
          ShowcaseTile(
            name: 'UICarouselWithIndicator',
            child: SizedBox(
              height: 140,
              child: UICarouselWithIndicator(
                itemCount: items.length,
                selectedIndicatorColor: colors.primary,
                unSelectedIndicatorColor: colors.outline,
                onPageChange: (i) => setState(() => _page = i),
                builder: (context, index, selectedIndex) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        items[index],
                        style: TextStyle(
                          fontWeight: index == selectedIndex
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UICarouselControls',
            child: Column(
              children: [
                UICarouselControls(
                  pageCount: items.length,
                  currentPage: _page,
                  onPrevious: () => setState(
                    () => _page = (_page - 1).clamp(0, items.length - 1),
                  ),
                  onNext: () => setState(
                    () => _page = (_page + 1).clamp(0, items.length - 1),
                  ),
                  onPageSelected: (i) => setState(() => _page = i),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UICarouselNavButton(
                      icon: Icons.chevron_left,
                      enabled: _page > 0,
                      highlighted: _page > 0,
                      onPressed: _page > 0
                          ? () => setState(() => _page -= 1)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    UICarouselPageIndicators(
                      pageCount: items.length,
                      currentPage: _page,
                      onPageSelected: (i) => setState(() => _page = i),
                    ),
                    const SizedBox(width: 16),
                    UICarouselNavButton(
                      icon: Icons.chevron_right,
                      enabled: _page < items.length - 1,
                      highlighted: _page < items.length - 1,
                      onPressed: _page < items.length - 1
                          ? () => setState(() => _page += 1)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UISectionCarousel',
            child: UISectionCarousel(
              pageCount: items.length,
              pageHeight: 120,
              pageBuilder: (context, index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: colors.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text('Page ${items[index]}')),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UICarouselRowPage + helpers',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('carouselPageCount(5, 2) = ${carouselPageCount(5, 2)}'),
                Text(
                  'itemsPerPageForWidth(800) = ${itemsPerPageForWidth(800)}',
                ),
                const SizedBox(height: 8),
                UICarouselRowPage<String>(
                  items: const ['A', 'B'],
                  itemsPerPage: 2,
                  gap: 8,
                  itemBuilder: (_, item) => Container(
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.outline),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(item),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
