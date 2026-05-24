enum AcademicSeason { normal, exam, projectDefense, breakPeriod }

enum NetworkQuality { offline, poor, fair, good }

enum LifeStage { student, earlyCareer, creator, entrepreneur }

enum StudentLevel { newStudent, returningStudent, finalYear }

enum AdaptiveMode {
  normal,
  examFocus,
  lite,
  recovery,
  budgetGuard,
  campusGuide,
  projectSprint,
}

enum ThemeSignal { normal, lowPower, calm, highContrast }

enum InterfacePressure { low, balanced, high }

enum UniModule {
  tasks,
  timetable,
  studyPlan,
  budget,
  wellness,
  campusMap,
  lecturerHours,
  fees,
  hostelChecklist,
  transport,
  emergency,
  projectTracker,
  mediaHeavyLearning,
}

class StudentContext {
  const StudentContext({
    required this.studentName,
    required this.lifeStage,
    required this.studentLevel,
    required this.academicSeason,
    required this.pendingTasks,
    required this.missedTasksThisWeek,
    required this.batteryLevel,
    required this.networkQuality,
    required this.sleepHours,
    required this.stressLevel,
    required this.weeklyBudgetLeft,
    required this.daysToNextExam,
    required this.daysToProjectDeadline,
    required this.timeOfDay,
  });

  final String studentName;
  final LifeStage lifeStage;
  final StudentLevel studentLevel;
  final AcademicSeason academicSeason;
  final int pendingTasks;
  final int missedTasksThisWeek;
  final int batteryLevel;
  final NetworkQuality networkQuality;
  final double sleepHours;
  final int stressLevel;
  final int weeklyBudgetLeft;
  final int daysToNextExam;
  final int daysToProjectDeadline;
  final DateTime timeOfDay;

  factory StudentContext.sample() => StudentContext(
    studentName: 'Nisan',
    lifeStage: LifeStage.student,
    studentLevel: StudentLevel.finalYear,
    academicSeason: AcademicSeason.normal,
    pendingTasks: 5,
    missedTasksThisWeek: 1,
    batteryLevel: 68,
    networkQuality: NetworkQuality.good,
    sleepHours: 6.5,
    stressLevel: 2,
    weeklyBudgetLeft: 18500,
    daysToNextExam: 21,
    daysToProjectDeadline: 34,
    timeOfDay: DateTime(2026, 5, 23, 9),
  );

  StudentContext copyWith({
    String? studentName,
    LifeStage? lifeStage,
    StudentLevel? studentLevel,
    AcademicSeason? academicSeason,
    int? pendingTasks,
    int? missedTasksThisWeek,
    int? batteryLevel,
    NetworkQuality? networkQuality,
    double? sleepHours,
    int? stressLevel,
    int? weeklyBudgetLeft,
    int? daysToNextExam,
    int? daysToProjectDeadline,
    DateTime? timeOfDay,
  }) {
    return StudentContext(
      studentName: studentName ?? this.studentName,
      lifeStage: lifeStage ?? this.lifeStage,
      studentLevel: studentLevel ?? this.studentLevel,
      academicSeason: academicSeason ?? this.academicSeason,
      pendingTasks: pendingTasks ?? this.pendingTasks,
      missedTasksThisWeek: missedTasksThisWeek ?? this.missedTasksThisWeek,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      networkQuality: networkQuality ?? this.networkQuality,
      sleepHours: sleepHours ?? this.sleepHours,
      stressLevel: stressLevel ?? this.stressLevel,
      weeklyBudgetLeft: weeklyBudgetLeft ?? this.weeklyBudgetLeft,
      daysToNextExam: daysToNextExam ?? this.daysToNextExam,
      daysToProjectDeadline:
          daysToProjectDeadline ?? this.daysToProjectDeadline,
      timeOfDay: timeOfDay ?? this.timeOfDay,
    );
  }
}

class HeroAction {
  const HeroAction({
    required this.label,
    required this.description,
    required this.iconCodePoint,
  });

  final String label;
  final String description;
  final int iconCodePoint;
}

class AdaptiveState {
  const AdaptiveState({
    required this.mode,
    required this.reason,
    required this.microcopy,
    required this.heroAction,
    required this.visibleModules,
    required this.themeSignal,
    required this.interfacePressure,
  });

  final AdaptiveMode mode;
  final String reason;
  final String microcopy;
  final HeroAction heroAction;
  final List<UniModule> visibleModules;
  final ThemeSignal themeSignal;
  final InterfacePressure interfacePressure;
}

class UniTask {
  const UniTask({
    required this.title,
    required this.course,
    required this.dueLabel,
    required this.isCritical,
  });

  final String title;
  final String course;
  final String dueLabel;
  final bool isCritical;
}

class CampusItem {
  const CampusItem({
    required this.title,
    required this.subtitle,
    required this.module,
  });

  final String title;
  final String subtitle;
  final UniModule module;
}
