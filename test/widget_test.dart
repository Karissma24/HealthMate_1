import 'package:flutter_test/flutter_test.dart';
import 'package:my_symptom_checker_v2/main.dart';

void main() {
  testWidgets('Patient Records screen appears', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const HealthMate()); // ✅ Use correct class

    // Example: Adjust this depending on what your home screen actually shows.
    expect(find.text('HealthMate Patient Records'), findsOneWidget);
  });
}
