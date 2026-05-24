import 'uniflow_models.dart';

class AdaptiveEngine {
  AdaptiveState resolve(StudentContext context) {
    if (_needsLiteMode(context)) {
      return const AdaptiveState(
        mode: AdaptiveMode.lite,
        reason: 'Battery, network, or data pressure detected.',
        microcopy: 'low-data mode: only the essentials are shown.',
        heroAction: HeroAction(
          label: 'Save battery: handle one urgent task',
          description:
              'UniFlow is hiding heavy cards until your phone/network is stable.',
          iconCodePoint: 0xe1a3,
        ),
        visibleModules: [
          UniModule.tasks,
          UniModule.timetable,
          UniModule.emergency,
          UniModule.budget,
        ],
        themeSignal: ThemeSignal.lowPower,
        interfacePressure: InterfacePressure.low,
      );
    }

    if (_needsRecovery(context)) {
      return const AdaptiveState(
        mode: AdaptiveMode.recovery,
        reason: 'High stress, low sleep, or repeated missed tasks detected.',
        microcopy:
            'Recovery mode: fewer choices, less pressure, one humane next step.',
        heroAction: HeroAction(
          label: 'Do one tiny reset action',
          description:
              'Take a 10-minute reset, then finish the smallest academic task.',
          iconCodePoint: 0xe3f2,
        ),
        visibleModules: [
          UniModule.wellness,
          UniModule.tasks,
          UniModule.studyPlan,
          UniModule.timetable,
          UniModule.emergency,
        ],
        themeSignal: ThemeSignal.calm,
        interfacePressure: InterfacePressure.low,
      );
    }

    if (_needsExamFocus(context)) {
      return const AdaptiveState(
        mode: AdaptiveMode.examFocus,
        reason: 'exam period or near-exam workload detected.',
        microcopy:
            'Exam focus: revision, deadlines, and rest move to the front.',
        heroAction: HeroAction(
          label: 'Start 25-minute revision block',
          description:
              'Focus on the weakest course first, then take a short break.',
          iconCodePoint: 0xe8b8,
        ),
        visibleModules: [
          UniModule.studyPlan,
          UniModule.tasks,
          UniModule.timetable,
          UniModule.wellness,
          UniModule.budget,
          UniModule.emergency,
        ],
        themeSignal: ThemeSignal.highContrast,
        interfacePressure: InterfacePressure.high,
      );
    }

    if (_needsProjectSprint(context)) {
      return const AdaptiveState(
        mode: AdaptiveMode.projectSprint,
        reason: 'Final-year/project deadline pressure detected.',
        microcopy:
            'Project sprint: defendable progress beats scattered activity.',
        heroAction: HeroAction(
          label: 'Move project one step forward',
          description:
              'Write, test, document, or prepare evidence for your supervisor.',
          iconCodePoint: 0xe873,
        ),
        visibleModules: [
          UniModule.projectTracker,
          UniModule.tasks,
          UniModule.timetable,
          UniModule.wellness,
          UniModule.lecturerHours,
          UniModule.budget,
        ],
        themeSignal: ThemeSignal.normal,
        interfacePressure: InterfacePressure.high,
      );
    }

    if (_needsBudgetGuard(context)) {
      return const AdaptiveState(
        mode: AdaptiveMode.budgetGuard,
        reason: 'Weekly money pressure detected.',
        microcopy:
            'Money guard: essentials, upcoming commitments, and calm choices come first.',
        heroAction: HeroAction(
          label: 'Protect essentials for the week',
          description:
              'Check food, transport, data, and one important commitment before spending.',
          iconCodePoint: 0xe850,
        ),
        visibleModules: [
          UniModule.budget,
          UniModule.tasks,
          UniModule.timetable,
          UniModule.transport,
          UniModule.wellness,
          UniModule.emergency,
        ],
        themeSignal: ThemeSignal.highContrast,
        interfacePressure: InterfacePressure.balanced,
      );
    }

    if (_needsCampusGuide(context)) {
      return const AdaptiveState(
        mode: AdaptiveMode.campusGuide,
        reason: 'New student profile detected.',
        microcopy:
            'Campus guide: useful places, safety, and routines are easier to find.',
        heroAction: HeroAction(
          label: 'Open campus survival guide',
          description:
              'Find lecture rooms, emergency contacts, transport, and hostel basics.',
          iconCodePoint: 0xe55f,
        ),
        visibleModules: [
          UniModule.campusMap,
          UniModule.timetable,
          UniModule.hostelChecklist,
          UniModule.transport,
          UniModule.emergency,
          UniModule.tasks,
        ],
        themeSignal: ThemeSignal.normal,
        interfacePressure: InterfacePressure.balanced,
      );
    }

    return const AdaptiveState(
      mode: AdaptiveMode.normal,
      reason: 'Normal life rhythm.',
      microcopy:
          'Today mode: priorities, timeline, money, and wellbeing stay balanced.',
      heroAction: HeroAction(
        label: 'Plan today in 3 minutes',
        description:
            'Pick your top task, confirm your timeline, and protect your energy.',
        iconCodePoint: 0xe8df,
      ),
      visibleModules: [
        UniModule.tasks,
        UniModule.timetable,
        UniModule.studyPlan,
        UniModule.budget,
        UniModule.wellness,
        UniModule.campusMap,
        UniModule.projectTracker,
      ],
      themeSignal: ThemeSignal.normal,
      interfacePressure: InterfacePressure.balanced,
    );
  }

  bool _needsLiteMode(StudentContext context) {
    return context.batteryLevel <= 15 ||
        context.networkQuality == NetworkQuality.offline ||
        context.networkQuality == NetworkQuality.poor;
  }

  bool _needsRecovery(StudentContext context) {
    return context.stressLevel >= 5 ||
        context.sleepHours < 5 ||
        (context.missedTasksThisWeek >= 4 && context.stressLevel >= 4);
  }

  bool _needsExamFocus(StudentContext context) {
    return context.lifeStage == LifeStage.student &&
        (context.academicSeason == AcademicSeason.exam ||
            context.daysToNextExam <= 7 ||
            (context.pendingTasks >= 7 && context.daysToNextExam <= 14));
  }

  bool _needsProjectSprint(StudentContext context) {
    return context.lifeStage == LifeStage.student &&
        context.studentLevel == StudentLevel.finalYear &&
        (context.academicSeason == AcademicSeason.projectDefense ||
            context.daysToProjectDeadline <= 14);
  }

  bool _needsBudgetGuard(StudentContext context) {
    return context.weeklyBudgetLeft <= 5000;
  }

  bool _needsCampusGuide(StudentContext context) {
    return context.lifeStage == LifeStage.student &&
        context.studentLevel == StudentLevel.newStudent;
  }
}
