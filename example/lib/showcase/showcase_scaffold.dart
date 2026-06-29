import 'package:flutter/material.dart';

class ShowcaseScaffold extends StatelessWidget {
  const ShowcaseScaffold({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(padding: const EdgeInsets.all(16), children: [child]),
    );
  }
}
