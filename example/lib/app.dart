import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import 'showcase/showcase_home.dart';

class FlutterUiComponentsExampleApp extends StatefulWidget {
  const FlutterUiComponentsExampleApp({super.key});

  @override
  State<FlutterUiComponentsExampleApp> createState() =>
      _FlutterUiComponentsExampleAppState();
}

class _FlutterUiComponentsExampleAppState
    extends State<FlutterUiComponentsExampleApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return UIImageScope(
      networkImageBuilder: (context, params) {
        return Image.network(
          params.url,
          width: params.width,
          height: params.height,
          fit: params.fit,
          color: params.color,
          errorBuilder: (_, error, stackTrace) => params.errorWidget(),
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return params.placeholder();
          },
        );
      },
      child: MaterialApp(
        title: 'VVK UI Kit',
        theme: UIAppTheme.light,
        darkTheme: UIAppTheme.dark,
        themeMode: _themeMode,
        home: ShowcaseHome(
          themeMode: _themeMode,
          onThemeModeChanged: _setThemeMode,
        ),
      ),
    );
  }
}
