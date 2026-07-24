import 'package:flutter/material.dart';

/// Vertical space `UISectionCarousel` reserves below its page area for the nav
/// buttons (44) plus the gap above them (20).
const double kUICarouselControlsFooterHeight = 44.0 + 20.0;

int carouselPageCount(int itemCount, int itemsPerPage) {
  if (itemCount == 0) return 0;
  return (itemCount / itemsPerPage).ceil();
}

List<T> carouselPageSlice<T>(List<T> items, int pageIndex, int itemsPerPage) {
  final start = pageIndex * itemsPerPage;
  if (start >= items.length) return const [];
  final end = (start + itemsPerPage).clamp(0, items.length);
  return items.sublist(start, end);
}

int itemsPerPageForWidth(
  double width, {
  int mobile = 1,
  int tablet = 2,
  int desktop = 2,
}) {
  if (width < 600) return mobile;
  if (width < 900) return tablet;
  return desktop;
}

/// Lays out a horizontal row of carousel items with optional trailing spacer.
class UICarouselRowPage<T> extends StatelessWidget {
  final List<T> items;
  final int itemsPerPage;
  final double gap;
  final Widget Function(BuildContext context, T item) itemBuilder;

  const UICarouselRowPage({
    super.key,
    required this.items,
    required this.itemsPerPage,
    required this.gap,
    required this.itemBuilder,
  });

  UICarouselRowPage<T> copyWith({
    Key? key,
    List<T>? items,
    int? itemsPerPage,
    double? gap,
    Widget Function(BuildContext context, T item)? itemBuilder,
  }) {
    return UICarouselRowPage<T>(
      key: key ?? this.key,
      items: items ?? this.items,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      gap: gap ?? this.gap,
      itemBuilder: itemBuilder ?? this.itemBuilder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: ClipRect(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) SizedBox(width: gap),
              Expanded(child: itemBuilder(context, items[i])),
            ],
            if (items.length == 1 && itemsPerPage > 1)
              const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}

double carouselCardWidth(
  double width, {
  required int itemsPerPage,
  double gap = 12,
  double pagePadding = 4,
  double cardPadding = 32,
}) {
  final totalGaps = gap * (itemsPerPage - 1);
  return (width - pagePadding - totalGaps) / itemsPerPage - cardPadding;
}

/// Total height a card-based `UISectionCarousel` page needs to show a card of
/// [cardBodyHeight] plus an optional [cardFooterHeight], leaving room for the
/// carousel's own controls ([controlsFooterHeight]).
///
/// Reduces the repeated "card height + footer + controls" boilerplate that
/// card carousels tend to compute locally.
///
/// ```dart
/// UISectionCarousel(
///   pageHeight: carouselPageHeightForCards(
///     cardBodyHeight: 320,
///     cardFooterHeight: maxCardFooterHeight,
///   ),
///   ...
/// );
/// ```
double carouselPageHeightForCards({
  required double cardBodyHeight,
  double cardFooterHeight = 0,
  double controlsFooterHeight = kUICarouselControlsFooterHeight,
}) {
  return cardBodyHeight + cardFooterHeight + controlsFooterHeight;
}
