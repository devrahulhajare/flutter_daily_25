import 'package:flutter_test/flutter_test.dart';

import 'package:daily_25/app/di/injection.dart';
import 'package:daily_25/app/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await configureDependencies();
  });

  testWidgets('Daily 25 app boots to Home tab', (tester) async {
    await tester.pumpWidget(const Daily25App());
    await tester.pump();

    expect(find.text('Daily 25'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Date Now'), findsOneWidget);
  });
}
