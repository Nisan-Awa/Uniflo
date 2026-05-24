import 'package:flutter/material.dart';

import 'core/adaptive_engine.dart';
import 'core/uniflow_models.dart';

void main() {
  runApp(const UniFlowApp());
}

class UniFlowApp extends StatelessWidget {
  const UniFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2F5BFF),
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
        fontFamily: 'Roboto',
      ),
      home: const UniFlowHomePage(),
    );
  }
}

class UniFlowHomePage extends StatefulWidget {
  const UniFlowHomePage({super.key});

  @override
  State<UniFlowHomePage> createState() => _UniFlowHomePageState();
}

class _UniFlowHomePageState extends State<UniFlowHomePage> {
  final _engine = AdaptiveEngine();
  var _context = StudentContext.sample();

  late final List<UniTask> _tasks = const [
    UniTask(
      title: 'Submit control systems lab report',
      course: 'EEE 512',
      dueLabel: 'Today, 7 PM',
      isCritical: true,
    ),
    UniTask(
      title: 'Revise power systems protection',
      course: 'EEE 508',
      dueLabel: 'Tomorrow',
      isCritical: true,
    ),
    UniTask(
      title: 'Update final-year project documentation',
      course: 'Project',
      dueLabel: '3 days',
      isCritical: true,
    ),
    UniTask(
      title: 'Pay faculty dues balance',
      course: 'Admin',
      dueLabel: 'Friday',
      isCritical: false,
    ),
  ];

  late final List<CampusItem> _campusItems = const [
    CampusItem(
      title: 'Lecturer office hours',
      subtitle: 'Dr. Ade: Tue/Thu, 10 AM - 1 PM',
      module: UniModule.lecturerHours,
    ),
    CampusItem(
      title: 'Emergency contacts',
      subtitle: 'Security, clinic, department rep',
      module: UniModule.emergency,
    ),
    CampusItem(
      title: 'Transport / shuttle info',
      subtitle: 'Routes, pickup points, safe late movement',
      module: UniModule.transport,
    ),
    CampusItem(
      title: 'Hostel checklist',
      subtitle: 'Power, water, repairs, essentials',
      module: UniModule.hostelChecklist,
    ),
  ];

  late final List<CampusItem> _lifeUtilityItems = const [
    CampusItem(
      title: 'Emergency contacts',
      subtitle: 'Trusted people, clinic, security, and quick help',
      module: UniModule.emergency,
    ),
    CampusItem(
      title: 'Transport / movement plan',
      subtitle: 'Routes, pickup points, and safe late movement',
      module: UniModule.transport,
    ),
    CampusItem(
      title: 'Documents checklist',
      subtitle: 'IDs, receipts, forms, and important screenshots',
      module: UniModule.hostelChecklist,
    ),
    CampusItem(
      title: 'Commitment reminders',
      subtitle: 'Fees, subscriptions, errands, and appointments',
      module: UniModule.fees,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final adaptive = _engine.resolve(_context);
    final palette = _paletteFor(adaptive.themeSignal);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          cacheExtent: 1200,
          slivers: [
            SliverToBoxAdapter(
              child: _HeroHeader(
                state: adaptive,
                palette: palette,
                contextData: _context,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
              sliver: SliverList.list(
                children: [
                  _SectionTitle(
                    title: _sectionTitle(adaptive.mode),
                    subtitle: adaptive.microcopy,
                  ),
                  const SizedBox(height: 12),
                  ...adaptive.visibleModules.map(
                    (module) => _buildModule(module, adaptive, palette),
                  ),
                  const SizedBox(height: 4),
                  _ContextControls(
                    contextData: _context,
                    onChanged: _updateContext,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateContext(StudentContext Function(StudentContext current) update) {
    setState(() => _context = update(_context));
  }

  Widget _buildModule(UniModule module, AdaptiveState state, _Palette palette) {
    return switch (module) {
      UniModule.tasks => _ModuleCard(
        icon: Icons.check_circle_outline,
        title: 'Priority tasks',
        accent: palette.accent,
        child: Column(
          children: _tasks
              .take(state.interfacePressure == InterfacePressure.low ? 2 : 4)
              .map(_TaskTile.new)
              .toList(),
        ),
      ),
      UniModule.timetable => _ModuleCard(
        icon: Icons.calendar_month_outlined,
        title: 'Today timeline',
        accent: palette.accent,
        child: Column(children: _timelineRows()),
      ),
      UniModule.studyPlan => _ModuleCard(
        icon: Icons.menu_book_outlined,
        title: 'Adaptive focus plan',
        accent: palette.accent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InsightPill(text: _focusInsight()),
            const SizedBox(height: 8),
            const _SimpleRow(label: 'Block 1', value: '25 min focused work'),
            const _SimpleRow(label: 'Break', value: '5 min stretch + water'),
            _SimpleRow(label: 'Block 2', value: _secondFocusBlock()),
          ],
        ),
      ),
      UniModule.budget => _ModuleCard(
        icon: Icons.account_balance_wallet_outlined,
        title: 'Money clarity',
        accent: palette.accent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '₦${_context.weeklyBudgetLeft} left this week',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (_context.weeklyBudgetLeft / 30000).clamp(0.0, 1.0),
              minHeight: 9,
              borderRadius: BorderRadius.circular(99),
            ),
            const SizedBox(height: 10),
            const Text(
              'UniFlow keeps money simple: essentials first, pressure visible, no banking complexity.',
            ),
          ],
        ),
      ),
      UniModule.wellness => _ModuleCard(
        icon: Icons.favorite_border,
        title: 'Wellness + routine coach',
        accent: palette.accent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InsightPill(
              text: _context.stressLevel >= 4
                  ? 'Interface pressure reduced. One task at a time.'
                  : 'Energy is okay. Keep work and rest balanced.',
            ),
            const SizedBox(height: 10),
            _SimpleRow(
              label: 'Sleep',
              value: '${_context.sleepHours.toStringAsFixed(1)} hrs',
            ),
            _SimpleRow(label: 'Stress', value: '${_context.stressLevel}/5'),
            const _SimpleRow(
              label: 'Tiny reset',
              value: 'Breathe, drink water, clear desk',
            ),
          ],
        ),
      ),
      UniModule.campusMap ||
      UniModule.lecturerHours ||
      UniModule.fees ||
      UniModule.hostelChecklist ||
      UniModule.transport ||
      UniModule.emergency => _ModuleCard(
        icon: Icons.location_city_outlined,
        title: _context.lifeStage == LifeStage.student
            ? 'Campus utility'
            : 'Life utility',
        accent: palette.accent,
        child: Column(
          children:
              (_context.lifeStage == LifeStage.student
                      ? _campusItems
                      : _lifeUtilityItems)
                  .map((item) => _CampusTile(item: item))
                  .toList(),
        ),
      ),
      UniModule.projectTracker => _ModuleCard(
        icon: Icons.engineering_outlined,
        title: 'Final-year/project tracker',
        accent: palette.accent,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InsightPill(text: 'Defendable evidence > busy activity.'),
            SizedBox(height: 8),
            _SimpleRow(label: 'Next', value: 'Run one test and save proof'),
            _SimpleRow(
              label: 'Doc',
              value: 'Update methodology/results section',
            ),
            _SimpleRow(label: 'Supervisor', value: 'Prepare 3 clear questions'),
          ],
        ),
      ),
      UniModule.mediaHeavyLearning => const SizedBox.shrink(),
    };
  }

  String _sectionTitle(AdaptiveMode mode) => switch (mode) {
    AdaptiveMode.examFocus => 'Exam mode dashboard',
    AdaptiveMode.lite => 'Lite survival dashboard',
    AdaptiveMode.recovery => 'Recovery dashboard',
    AdaptiveMode.budgetGuard => 'Money guard dashboard',
    AdaptiveMode.campusGuide => 'Campus guide dashboard',
    AdaptiveMode.projectSprint => 'Project sprint dashboard',
    AdaptiveMode.normal => 'Today dashboard',
  };

  List<Widget> _timelineRows() {
    if (_context.lifeStage == LifeStage.student) {
      return const [
        _SimpleRow(label: '09:00', value: 'Power Electronics lecture'),
        _SimpleRow(label: '12:00', value: 'Project work block'),
        _SimpleRow(label: '16:00', value: 'Revision / assignment buffer'),
      ];
    }

    return const [
      _SimpleRow(label: '09:00', value: 'Deep work / main commitment'),
      _SimpleRow(label: '12:00', value: 'Admin, calls, or errands'),
      _SimpleRow(label: '16:00', value: 'Learning, review, or recovery block'),
    ];
  }

  String _focusInsight() {
    if (_context.lifeStage == LifeStage.student) {
      return 'Start with your weakest or nearest course.';
    }

    return 'Start with the commitment that would reduce the most pressure.';
  }

  String _secondFocusBlock() {
    if (_context.lifeStage == LifeStage.student) {
      return 'Past question / recall test';
    }

    return 'Review progress and prepare the next clear action';
  }

  _Palette _paletteFor(ThemeSignal signal) => switch (signal) {
    ThemeSignal.lowPower => const _Palette(
      Color(0xFF1C7C54),
      Color(0xFFE9F8F0),
      Color(0xFF083D2B),
    ),
    ThemeSignal.calm => const _Palette(
      Color(0xFF7C4DFF),
      Color(0xFFF1ECFF),
      Color(0xFF2E1A6B),
    ),
    ThemeSignal.highContrast => const _Palette(
      Color(0xFFE85D04),
      Color(0xFFFFF1E6),
      Color(0xFF4A1D00),
    ),
    ThemeSignal.normal => const _Palette(
      Color(0xFF2F5BFF),
      Color(0xFFEFF3FF),
      Color(0xFF071A55),
    ),
  };
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.state,
    required this.palette,
    required this.contextData,
  });

  final AdaptiveState state;
  final _Palette palette;
  final StudentContext contextData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.deep,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: palette.accent.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'UniFlow',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _modeLabel(state.mode),
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Hi ${contextData.studentName}, what matters now is clearer.',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 29,
              height: 1.04,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            state.reason,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: palette.soft,
                  foregroundColor: palette.accent,
                  child: Icon(_iconFor(state.mode)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.heroAction.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.heroAction.description,
                        style: const TextStyle(
                          color: Color(0xFF667085),
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(AdaptiveMode mode) => switch (mode) {
    AdaptiveMode.examFocus => Icons.school_outlined,
    AdaptiveMode.lite => Icons.battery_saver_outlined,
    AdaptiveMode.recovery => Icons.self_improvement_outlined,
    AdaptiveMode.budgetGuard => Icons.savings_outlined,
    AdaptiveMode.campusGuide => Icons.map_outlined,
    AdaptiveMode.projectSprint => Icons.engineering_outlined,
    AdaptiveMode.normal => Icons.dashboard_customize_outlined,
  };

  String _modeLabel(AdaptiveMode mode) => switch (mode) {
    AdaptiveMode.examFocus => 'EXAM FOCUS',
    AdaptiveMode.lite => 'LITE MODE',
    AdaptiveMode.recovery => 'RECOVERY',
    AdaptiveMode.budgetGuard => 'MONEY GUARD',
    AdaptiveMode.campusGuide => 'CAMPUS GUIDE',
    AdaptiveMode.projectSprint => 'PROJECT SPRINT',
    AdaptiveMode.normal => 'NORMAL',
  };
}

class _ContextControls extends StatelessWidget {
  const _ContextControls({required this.contextData, required this.onChanged});

  final StudentContext contextData;
  final void Function(StudentContext Function(StudentContext current))
  onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Context simulator',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap these to see the dashboard respond to school, money, power, and wellbeing context.',
            style: TextStyle(color: Color(0xFF667085)),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ModeChip(
                label: 'Normal',
                selected:
                    contextData.academicSeason == AcademicSeason.normal &&
                    contextData.lifeStage == LifeStage.student &&
                    contextData.batteryLevel > 15 &&
                    contextData.stressLevel < 5 &&
                    contextData.weeklyBudgetLeft > 5000,
                onTap: () => onChanged((c) => StudentContext.sample()),
              ),
              _ModeChip(
                label: 'Exam',
                selected: contextData.academicSeason == AcademicSeason.exam,
                onTap: () => onChanged(
                  (c) => c.copyWith(
                    lifeStage: LifeStage.student,
                    academicSeason: AcademicSeason.exam,
                    pendingTasks: 9,
                    daysToNextExam: 3,
                    stressLevel: 3,
                    batteryLevel: 64,
                    networkQuality: NetworkQuality.good,
                  ),
                ),
              ),
              _ModeChip(
                label: 'Low data/battery',
                selected:
                    contextData.batteryLevel <= 15 ||
                    contextData.networkQuality == NetworkQuality.poor,
                onTap: () => onChanged(
                  (c) => c.copyWith(
                    batteryLevel: 11,
                    networkQuality: NetworkQuality.poor,
                  ),
                ),
              ),
              _ModeChip(
                label: 'Low budget',
                selected: contextData.weeklyBudgetLeft <= 5000,
                onTap: () => onChanged(
                  (c) => c.copyWith(
                    weeklyBudgetLeft: 2800,
                    batteryLevel: 62,
                    networkQuality: NetworkQuality.good,
                    stressLevel: 3,
                    academicSeason: AcademicSeason.normal,
                    daysToNextExam: 24,
                    daysToProjectDeadline: 40,
                  ),
                ),
              ),
              _ModeChip(
                label: 'Burnout',
                selected: contextData.stressLevel >= 5,
                onTap: () => onChanged(
                  (c) => c.copyWith(
                    stressLevel: 5,
                    sleepHours: 4.0,
                    missedTasksThisWeek: 6,
                    batteryLevel: 70,
                    networkQuality: NetworkQuality.good,
                  ),
                ),
              ),
              _ModeChip(
                label: 'Work/life',
                selected: contextData.lifeStage == LifeStage.earlyCareer,
                onTap: () => onChanged(
                  (c) => c.copyWith(
                    lifeStage: LifeStage.earlyCareer,
                    studentLevel: StudentLevel.returningStudent,
                    academicSeason: AcademicSeason.normal,
                    pendingTasks: 6,
                    stressLevel: 2,
                    batteryLevel: 76,
                    networkQuality: NetworkQuality.good,
                    weeklyBudgetLeft: 22000,
                    daysToNextExam: 45,
                    daysToProjectDeadline: 45,
                  ),
                ),
              ),
              _ModeChip(
                label: 'New student',
                selected:
                    contextData.lifeStage == LifeStage.student &&
                    contextData.studentLevel == StudentLevel.newStudent,
                onTap: () => onChanged(
                  (c) => c.copyWith(
                    lifeStage: LifeStage.student,
                    studentLevel: StudentLevel.newStudent,
                    academicSeason: AcademicSeason.normal,
                    stressLevel: 2,
                    batteryLevel: 72,
                    networkQuality: NetworkQuality.good,
                  ),
                ),
              ),
              _ModeChip(
                label: 'Project deadline',
                selected: contextData.daysToProjectDeadline <= 14,
                onTap: () => onChanged(
                  (c) => c.copyWith(
                    lifeStage: LifeStage.student,
                    studentLevel: StudentLevel.finalYear,
                    daysToProjectDeadline: 7,
                    academicSeason: AcademicSeason.projectDefense,
                    batteryLevel: 70,
                    networkQuality: NetworkQuality.good,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: const Color(0xFFEFF3FF),
      labelStyle: TextStyle(
        fontWeight: FontWeight.w700,
        color: selected ? const Color(0xFF2F5BFF) : const Color(0xFF475467),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: selected ? const Color(0xFF2F5BFF) : const Color(0xFFE4E7EC),
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.icon,
    required this.title,
    required this.child,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accent),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile(this.task);

  final UniTask task;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: task.isCritical
            ? const Color(0xFFFFF7ED)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            task.isCritical
                ? Icons.priority_high_rounded
                : Icons.radio_button_unchecked,
            color: task.isCritical
                ? const Color(0xFFE85D04)
                : const Color(0xFF98A2B3),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task.title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            task.dueLabel,
            style: const TextStyle(color: Color(0xFF667085), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _CampusTile extends StatelessWidget {
  const _CampusTile({required this.item});

  final CampusItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        backgroundColor: Color(0xFFEFF3FF),
        child: Icon(Icons.arrow_outward, size: 18),
      ),
      title: Text(
        item.title,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      subtitle: Text(item.subtitle),
    );
  }
}

class _SimpleRow extends StatelessWidget {
  const _SimpleRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF667085),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightPill extends StatelessWidget {
  const _InsightPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Color(0xFF344054),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: Color(0xFF667085), height: 1.35),
        ),
      ],
    );
  }
}

class _Palette {
  const _Palette(this.accent, this.soft, this.deep);

  final Color accent;
  final Color soft;
  final Color deep;
}
