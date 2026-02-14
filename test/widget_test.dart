import 'dart:ui' show Size;

import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:starter_templates/main.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('renders discovery screen', (WidgetTester tester) async {
    await tester.pumpWidget(const NovaStreamHubApp(showSplash: false));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Featured Streams'), findsOneWidget);
    expect(find.text('Atmospheric Flow v4'), findsAtLeastNWidgets(1));
  });

  testWidgets('navigates to details from featured card', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const NovaStreamHubApp(showSplash: false));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.ensureVisible(find.text('Atmospheric Flow v4').first);
    await tester.tap(find.text('Atmospheric Flow v4').first);
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Back to Dashboard'), findsOneWidget);
    expect(
      find.text(
        'High-fidelity system initialization completed. Functional scroll enabled for deep-dive content analysis...',
      ),
      findsOneWidget,
    );
  });

  testWidgets('opens library and system config from navigation', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const NovaStreamHubApp(showSplash: false));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('My Library'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Saved Experiences'), findsOneWidget);
    expect(find.text('Atmospheric Flow v4'), findsAtLeastNWidgets(1));

    await tester.tap(find.text('System Config'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Runtime Profile'), findsOneWidget);
    expect(find.text('Runtime Diagnostics'), findsOneWidget);
  });
}
