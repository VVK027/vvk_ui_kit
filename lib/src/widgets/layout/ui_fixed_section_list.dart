import 'package:flutter/material.dart';

/// Builds a scrollable list from a small fixed set of sections.
class UIFixedSectionListView extends StatelessWidget {
  const UIFixedSectionListView({
    super.key,
    required this.sections,
    this.padding,
    this.physics,
  });

  final List<Widget> sections;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;

  UIFixedSectionListView copyWith({
    Key? key,
    List<Widget>? sections,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
  }) {
    return UIFixedSectionListView(
      key: key ?? this.key,
      sections: sections ?? this.sections,
      padding: padding ?? this.padding,
      physics: physics ?? this.physics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      physics: physics,
      itemCount: sections.length,
      itemBuilder: (context, index) => sections[index],
    );
  }
}
