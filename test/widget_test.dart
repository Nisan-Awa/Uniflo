import 'package:flutter_test/flutter_test.dart';
import 'package:uniflow/main.dart';

void main() {
  testWidgets(
    'UniFlow renders adaptive dashboard and responds to exam context',
    (tester) async {
      await tester.pumpWidget(const UniFlowApp());

      expect(find.text('UniFlow'), findsOneWidget);
      expect(find.text('Today dashboard'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Exam'), 300);
      await tester.tap(find.text('Exam'));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('Exam mode dashboard'), -300);
      expect(find.text('Exam mode dashboard'), findsOneWidget);
      expect(find.text('Start 25-minute revision block'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Low budget'), 300);
      await tester.tap(find.text('Low budget'));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('Money guard dashboard'), -300);
      expect(find.text('Money guard dashboard'), findsOneWidget);
      expect(find.text('Protect essentials for the week'), findsOneWidget);
    },
  );
}
