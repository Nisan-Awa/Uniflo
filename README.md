# UniFlow

UniFlow is an adaptive life companion with a student-first focus for Nigerian university students and young adults.

It is a Flutter mobile app prototype that helps people manage tasks, daily timelines, focused work, basic budgeting, wellness/routine signals, and practical utility needs through a dashboard that changes based on context.

## Core idea

Students and young adults do not lack apps; they lack structure. UniFlow acts as a lightweight command center for fragmented daily life:

- WhatsApp group announcements
- screenshots and PDFs
- reminders and calendars
- course deadlines
- final-year project pressure
- budget awareness
- wellness/burnout signals
- campus survival information
- transport, documents, errands, and emergency contacts

## Adaptive modes

The current prototype includes a rule-based adaptive engine with these modes:

- **Normal mode**: balanced dashboard for everyday academic rhythm.
- **Exam focus mode**: prioritizes revision, urgent tasks, timetable, and rest.
- **Lite mode**: low-data/low-battery dashboard for unstable Nigerian network/power realities.
- **Recovery mode**: reduces interface pressure when stress, sleep debt, or missed tasks are high.
- **Money guard mode**: prioritizes essentials when weekly funds are low.
- **Campus guide mode**: helps new students find campus essentials quickly.
- **Project sprint mode**: prioritizes final-year project progress and supervisor-readiness.

## Architecture

The app uses a simple first-principles model:

1. **User context**: life stage, academic season, level, tasks, battery, network, stress, sleep, budget, deadlines.
2. **Adaptive decision engine**: determines what matters now and what should be hidden or promoted.
3. **Adaptive UI**: reorders modules, changes microcopy, reduces interface pressure, and changes visual tone.

## Current implementation

- Flutter/Dart app
- No backend required for MVP
- Rule-based adaptive engine in `lib/core/adaptive_engine.dart`
- Student context models in `lib/core/uniflow_models.dart`
- Interactive context simulator on the home screen
- Unit tests for adaptive engine behavior
- Widget test for dashboard adaptation

## Run locally

```bash
flutter pub get
flutter test
flutter run
```

## Build APK

```bash
flutter build apk --release
```

The output APK will be at:

```text
build/app/outputs/flutter-apk/app-release.apk
```
