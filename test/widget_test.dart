import 'package:flutter_test/flutter_test.dart';
import 'package:mi_app_flutter/app.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CopaCarnavalApp());
    expect(find.text('Copa Carnaval'), findsOneWidget);
  });
}
