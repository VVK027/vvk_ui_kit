import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import 'common.dart';
import 'showcase_scaffold.dart';

class RatingShowcase extends StatefulWidget {
  const RatingShowcase({super.key});

  @override
  State<RatingShowcase> createState() => _RatingShowcaseState();
}

class _RatingShowcaseState extends State<RatingShowcase> {
  double _rating = 3;
  double _builderRating = 4;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ShowcaseScaffold(
      title: 'Rating',
      child: Column(
        children: [
          ShowcaseTile(
            name: 'UIRatingBar',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIRatingBar(
                  initialRating: _rating,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 2),
                  onRatingUpdate: (value) => setState(() => _rating = value),
                ),
                const SizedBox(height: 8),
                Text('Selected: $_rating'),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UIRatingBarIndicator',
            child: const UIRatingBarIndicator(
              rating: 4.3,
              itemSize: 28,
              itemPadding: EdgeInsets.symmetric(horizontal: 2),
            ),
          ),
          ShowcaseTile(
            name: 'UIRatingBar.builder',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIRatingBar.builder(
                  initialRating: _builderRating,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                  itemBuilder: (context, index) {
                    final icons = [
                      Icons.sentiment_very_dissatisfied,
                      Icons.sentiment_dissatisfied,
                      Icons.sentiment_neutral,
                      Icons.sentiment_satisfied,
                      Icons.sentiment_very_satisfied,
                    ];
                    final colors = [
                      Colors.red,
                      Colors.deepOrange,
                      Colors.amber,
                      Colors.lightGreen,
                      Colors.green,
                    ];
                    return Icon(icons[index], color: colors[index], size: 32);
                  },
                  onRatingUpdate: (value) =>
                      setState(() => _builderRating = value),
                ),
                const SizedBox(height: 8),
                Text('Selected: $_builderRating'),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UIRatingBar + UIRatingWidget',
            child: UIRatingBar(
              initialRating: 2.5,
              allowHalfRating: true,
              itemPadding: const EdgeInsets.symmetric(horizontal: 2),
              ratingWidget: UIRatingWidget(
                full: Icon(Icons.favorite, color: theme.colorScheme.error),
                half: Icon(Icons.favorite, color: theme.colorScheme.error),
                empty: Icon(
                  Icons.favorite_border,
                  color: theme.colorScheme.outline,
                ),
              ),
              onRatingUpdate: (_) {},
            ),
          ),
          ShowcaseTile(
            name: 'UIRatingBarIndicator (vertical)',
            child: const UIRatingBarIndicator(
              rating: 3.5,
              direction: Axis.vertical,
              itemPadding: EdgeInsets.symmetric(vertical: 2),
            ),
          ),
          ShowcaseTile(
            name: 'UIRatingBar (whole stars only)',
            child: UIRatingBar(
              initialRating: 4,
              allowHalfRating: false,
              itemPadding: const EdgeInsets.symmetric(horizontal: 2),
              onRatingUpdate: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}
