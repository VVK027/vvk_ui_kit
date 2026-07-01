# VVK UI Kit Examples

This document provides detailed examples and best practices for using the components in `vvk_ui_kit`.

## Table of Contents

- [Theming](#theming)
- [Buttons](#buttons)
- [Forms & Inputs](#forms--inputs)
- [Glass Components](#glass-components)
- [Navigation](#navigation)
- [Feedback & Tours](#feedback--tours)
- [Media & Icons](#media--icons)

---

## Theming

### Accessing Theme Colors

Use the `context.uiTheme` extension to access semantic colors defined in the kit.

```dart
final theme = context.uiTheme;

Container(
  color: theme.colors.card,
  child: Text(
    'Hello World',
    style: TextStyle(color: theme.colors.textPrimary),
  ),
)
```

### Custom Palette

If you want to use the kit with your own brand colors:

```dart
final myPalette = UIThemePalette(
  scaffold: Colors.white,
  surface: Colors.grey[50]!,
  card: Colors.white,
  sectionBorder: Colors.grey[200]!,
  textPrimary: Colors.black,
  textSecondary: Colors.grey[800]!,
  textMuted: Colors.grey[600]!,
  chipBackground: Colors.grey[100]!,
  chipBorder: Colors.grey[300]!,
  chipLabel: Colors.black,
  accent: Colors.deepPurple,
  accentSecondary: Colors.deepPurpleAccent,
);

MaterialApp(
  theme: UIAppTheme.custom(palette: myPalette),
  home: const MyHomePage(),
)
```

---

## Buttons

### Styled Button

`UIStyledButton` is the most versatile button. It supports multiple styles and sizes.

```dart
UIStyledButton(
  style: UIStyledButtonStyle.primary(context),
  size: UIStyledButtonSize.large,
  onPressed: () {},
  child: const Text('Primary Button'),
)

UIStyledButton(
  style: UIStyledButtonStyle.outline(context),
  onPressed: () {},
  child: const Text('Outline Button'),
)
```

### Split Button

Useful for a primary action with a set of secondary actions.

```dart
UISplitButton.fromTheme(
  context,
  label: 'Save Changes',
  onPressed: () => save(),
  menuItems: [
    UISplitButtonMenuItem(
      label: 'Save and Exit',
      onTap: () => saveAndExit(),
    ),
    UISplitButtonMenuItem(
      label: 'Discard',
      onTap: () => discard(),
    ),
  ],
)
```

---

## Forms & Inputs

### Using UIForm

`UIForm` helps manage multiple form fields and their values.

```dart
final _formKey = GlobalKey<UIFormState>();

UIForm(
  key: _formKey,
  onChanged: (values) {
    print('Form values: $values');
  },
  child: Column(
    children: [
      UIFormTextField(
        name: 'username',
        label: 'Username',
        placeholder: 'Enter username',
        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
      ),
      const SizedBox(height: 16),
      UIFormTextField(
        name: 'password',
        label: 'Password',
        obscureText: true,
      ),
      const SizedBox(height: 24),
      UIStyledButton(
        style: UIStyledButtonStyle.primary(context),
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            final data = _formKey.currentState?.formData;
            // Handle submission
          }
        },
        child: const Text('Submit'),
      ),
    ],
  ),
)
```

---

## Glass Components

Glass components provide a modern "frosted glass" look. They work best when placed over colorful or high-contrast backgrounds.

### Glass Scaffold

```dart
UIGlassScaffold(
  appBar: UIGlassAppBar(
    title: const Text('My Glassy App'),
    actions: [
      IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
    ],
  ),
  body: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue, Colors.purple],
      ),
    ),
    child: Center(
      child: UIGlassCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Frosted Glass Card', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            UIGlassButton(
              onPressed: () {},
              child: const Text('Glass Button'),
            ),
          ],
        ),
      ),
    ),
  ),
)
```

---

## Navigation

### Using NavigationUtil

```dart
// Push a new page
NavigationUtil.pushPage(context, const DetailPage());

// Push and remove current
NavigationUtil.pushReplacement(context, const LoginPage());

// Pop with result
NavigationUtil.pop(context, true);
```

### Bottom Navy Bar

```dart
Scaffold(
  bottomNavigationBar: UIBottomNavyBar(
    selectedIndex: _currentIndex,
    onItemSelected: (index) => setState(() => _currentIndex = index),
    items: [
      UIBottomNavyBarItem(
        icon: const Icon(Icons.home),
        title: const Text('Home'),
        activeColor: context.uiTheme.colors.accent,
      ),
      UIBottomNavyBarItem(
        icon: const Icon(Icons.search),
        title: const Text('Search'),
        activeColor: Colors.blue,
      ),
    ],
  ),
)
```

---

## Feedback & Tours

### Product Tour

```dart
final tour = UITourController(
  steps: [
    UITourStep(
      targetKey: _menuKey,
      title: 'Navigation Menu',
      description: 'Access all features from this menu.',
    ),
    UITourStep(
      targetKey: _searchKey,
      title: 'Global Search',
      description: 'Search for anything across the app.',
    ),
  ],
);

// Start the tour
tour.start(context);
```

---

## Media & Icons

### Unified UIImage

`UIImage` handles assets, network images, and SVGs automatically based on the URL format.

```dart
// Network image
UIImage(url: 'https://example.com/image.png', width: 100, height: 100)

// SVG from asset
UIImage(url: 'assets/icons/logo.svg', color: Colors.blue)

// Base64 image
UIImage(url: 'data:image/png;base64,...')
```

### Custom SVG Rendering

```dart
UISvgImage.asset(
  'assets/icons/custom_icon.svg',
  width: 24,
  height: 24,
  color: Colors.red,
)
```
