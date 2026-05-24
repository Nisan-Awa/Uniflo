import 'package:flutter_test/flutter_test.dart';
import 'package:uniflow/core/adaptive_engine.dart';
import 'package:uniflow/core/uniflow_models.dart';

void main() {
  group('AdaptiveEngine', () {
    test(
      'switches to exam focus mode when exams are near and workload is high',
      () {
        final context = StudentContext.sample().copyWith(
          academicSeason: AcademicSeason.exam,
          pendingTasks: 8,
          stressLevel: 4,
        );

        final state = AdaptiveEngine().resolve(context);

        expect(state.mode, AdaptiveMode.examFocus);
        expect(state.heroAction.label, contains('revision'));
        expect(state.visibleModules.first, UniModule.studyPlan);
        expect(state.reason, contains('exam'));
      },
    );

    test('switches to lite mode when data or battery pressure is high', () {
      final context = StudentContext.sample().copyWith(
        batteryLevel: 12,
        networkQuality: NetworkQuality.poor,
      );

      final state = AdaptiveEngine().resolve(context);

      expect(state.mode, AdaptiveMode.lite);
      expect(state.themeSignal, ThemeSignal.lowPower);
      expect(
        state.visibleModules,
        isNot(contains(UniModule.mediaHeavyLearning)),
      );
      expect(state.microcopy, contains('low-data'));
    });

    test('switches to recovery mode when stress and sleep debt are high', () {
      final context = StudentContext.sample().copyWith(
        stressLevel: 5,
        sleepHours: 4.5,
        missedTasksThisWeek: 5,
      );

      final state = AdaptiveEngine().resolve(context);

      expect(state.mode, AdaptiveMode.recovery);
      expect(state.visibleModules.first, UniModule.wellness);
      expect(state.heroAction.label, contains('tiny'));
      expect(state.interfacePressure, InterfacePressure.low);
    });

    test('switches to money guard mode when weekly funds are low', () {
      final context = StudentContext.sample().copyWith(
        weeklyBudgetLeft: 3000,
        daysToNextExam: 30,
        daysToProjectDeadline: 30,
      );

      final state = AdaptiveEngine().resolve(context);

      expect(state.mode, AdaptiveMode.budgetGuard);
      expect(state.visibleModules.first, UniModule.budget);
      expect(state.heroAction.label, contains('essentials'));
      expect(state.microcopy, contains('Money guard'));
    });

    test('keeps non-student users out of academic exam mode', () {
      final context = StudentContext.sample().copyWith(
        lifeStage: LifeStage.earlyCareer,
        academicSeason: AcademicSeason.exam,
        daysToNextExam: 3,
      );

      final state = AdaptiveEngine().resolve(context);

      expect(state.mode, AdaptiveMode.normal);
      expect(state.reason, contains('life rhythm'));
    });

    test('switches to campus guide mode for new students', () {
      final context = StudentContext.sample().copyWith(
        studentLevel: StudentLevel.newStudent,
        academicSeason: AcademicSeason.normal,
      );

      final state = AdaptiveEngine().resolve(context);

      expect(state.mode, AdaptiveMode.campusGuide);
      expect(state.visibleModules, contains(UniModule.campusMap));
      expect(state.visibleModules, contains(UniModule.emergency));
    });
  });
}
