# Responsive Components Guide

This guide explains how to use the responsive components in this application to create layouts that adapt to different screen sizes.

## Overview of Responsive Components

The responsive system consists of several components:

1. **ResponsiveUtil** - A utility class for responsive calculations based on screen size
2. **ResponsiveWrapper** - A container widget that applies responsive sizing and spacing
3. **ResponsiveScreen** - A scaffold wrapper with responsive padding and layout
4. **ResponsiveBuilder** - A widget that renders different layouts based on screen size
5. **ResponsiveText** - A text widget that scales font size based on screen size
6. **ResponsiveGrid** - A grid layout that adjusts columns based on screen size
7. **ResponsiveRowColumn** - A layout that switches between row and column based on screen size
8. **ResponsiveLayout** - A utility class for applying responsive behavior to existing screens

## How to Use the Responsive System

### 1. Using ResponsiveScreen for Screen Layout

```dart
import 'package:communication_practice/widgets/responsive_screen.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveScreen(
      backgroundColor: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Your screen content here
        ],
      ),
    );
  }
}
```

### 2. Using ResponsiveWrapper for Containers

```dart
import 'package:communication_practice/widgets/responsive_wrapper.dart';
import 'package:communication_practice/utils/responsive.dart';

ResponsiveUtil responsive = ResponsiveUtil(context);

ResponsiveWrapper(
  padding: EdgeInsets.symmetric(
    horizontal: responsive.md,
    vertical: responsive.sm
  ),
  maxWidth: 600, // Maximum width on larger screens
  child: YourWidget(),
)
```

### 3. Using ResponsiveText for Scalable Text

```dart
import 'package:communication_practice/widgets/responsive_builders.dart';

ResponsiveText(
  'This text will scale based on screen size',
  style: Theme.of(context).textTheme.headline4,
  textAlign: TextAlign.center,
)
```

### 4. Using ResponsiveGrid for Adaptive Grid Layouts

```dart
import 'package:communication_practice/widgets/responsive_builders.dart';

ResponsiveGrid(
  children: itemsList.map((item) => ItemCard(item: item)).toList(),
  spacing: 16,
  runSpacing: 16,
  smallScreenCrossAxisCount: 1,
  mediumScreenCrossAxisCount: 2,
  largeScreenCrossAxisCount: 3,
  extraLargeScreenCrossAxisCount: 4,
)
```

### 5. Adapting Layouts Based on Screen Size

```dart
import 'package:communication_practice/widgets/responsive_builders.dart';

ResponsiveBuilder(
  // Default layout that will be used if no specific layout is provided
  builder: (context, responsive) {
    return Container(
      child: Text('Default layout with width: ${responsive.screenWidth}'),
    );
  },
  // Alternative layouts for specific screen sizes
  smallScreen: SmallScreenLayout(),
  mediumScreen: MediumScreenLayout(),
  largeScreen: LargeScreenLayout(),
)
```

### 6. Using ResponsiveRowColumn

```dart
import 'package:communication_practice/widgets/responsive_builders.dart';

ResponsiveRowColumn(
  // Use row on large screens, column on small screens
  rowForLargeScreen: true,
  columnForSmallScreen: true,
  spacing: 16,
  children: [
    Text('Item 1'),
    Text('Item 2'),
    Text('Item 3'),
  ],
)
```

### 7. Quick Conversion with ResponsiveLayout

```dart
import 'package:communication_practice/widgets/responsive_layout.dart';

// Convert any existing screen to use responsive layout
ResponsiveLayout.wrapScreen(
  context,
  YourExistingScreen(),
  padding: EdgeInsets.all(16),
  backgroundColor: Colors.white,
)

// Get adaptive spacing
final padding = ResponsiveLayout.getPadding(context, horizontal: 16, vertical: 8);

// Get adaptive font size
final fontSize = ResponsiveLayout.getFontSize(context, 16);

// Get adaptive spacing based on predefined sizes
final spacing = ResponsiveLayout.getSpacing(context, SpacingSize.md);
```

## Responsive Breakpoints

The application defines the following breakpoints:

- **Small screens**: < 500px (phones)
- **Medium screens**: 500px - 799px (tablets)
- **Large screens**: 800px - 1199px (small desktops)
- **Extra large screens**: >= 1200px (large desktops)

## Best Practices

1. **Use the responsive components consistently** throughout the app for uniform behavior
2. **Test on multiple screen sizes** to ensure layouts adapt correctly
3. **Use responsive spacing and sizing** rather than fixed values
4. **Consider different device orientations** when designing layouts
5. **Prioritize content** for smaller screens by showing only essential information

## Tips for Existing Screens

To convert existing screens to use the responsive system:

1. Replace `Scaffold` with `ResponsiveScreen`
2. Replace fixed-size containers with `ResponsiveWrapper`
3. Replace `Text` widgets with `ResponsiveText`
4. Replace `GridView` with `ResponsiveGrid`
5. Use `ResponsiveBuilder` for conditionally rendered content based on screen size

## Example Screen

Here's an example of a screen using all the responsive components:

```dart
import 'package:flutter/material.dart';
import 'package:communication_practice/utils/responsive.dart';
import 'package:communication_practice/widgets/responsive_screen.dart';
import 'package:communication_practice/widgets/responsive_wrapper.dart';
import 'package:communication_practice/widgets/responsive_builders.dart';

class ExampleResponsiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    
    return ResponsiveScreen(
      padding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Responsive Example')),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ResponsiveWrapper(
              padding: EdgeInsets.all(responsive.md),
              child: ResponsiveText(
                'Responsive Screen Example',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            
            ResponsiveBuilder(
              smallScreen: SmallScreenContent(),
              mediumScreen: MediumScreenContent(),
              builder: (context, responsive) {
                return DefaultScreenContent();
              },
            ),
            
            ResponsiveWrapper(
              padding: EdgeInsets.all(responsive.md),
              child: ResponsiveGrid(
                spacing: responsive.sm,
                runSpacing: responsive.sm,
                children: List.generate(
                  6, 
                  (index) => GridItem(index: index)
                ),
              ),
            ),
            
            ResponsiveRowColumn(
              rowForLargeScreen: true,
              columnForSmallScreen: true,
              spacing: responsive.md,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button('Option 1'),
                Button('Option 2'),
                Button('Option 3'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
``` 