import 'package:flutter_test/flutter_test.dart';
import 'package:uniflow/main.dart';

void main() {
  testWidgets(
    'UniFlow renders adaptive dashboard and responds to exam context',
    (tester) async {
      await tester.pumpWidget(const UniFlowApp());

      expect(find.text('UniFlow'), findsOneWidget);
      expect(find.text('Today dashboard'), findsOneWidget);
      expect(find.text('Context simulator'), findsOneWidget);

      await tester.tap(find.text('Exam'));
      await tester.pumpAndSettle();

      expect(find.text('Exam mode dashboard'), findsOneWidget);
      expect(find.text('Start 25-minute revision block'), findsOneWidget);
    },
  );
}
