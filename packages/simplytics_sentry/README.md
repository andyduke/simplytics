# Simplytics Sentry/GlitchTip Integration

[Simplytics](https://pub.dev/packages/simplytics) is a simple abstraction for analytics and crash reporting.
This package adds implementation of **Sentry** and **GlitchTip** integration.

## Usage

To start using Simplytics with Sentry or GlitchTip, you need to initialize Sentry and configure Simplytics, specify which classes of analytics and error monitoring services to use:
```dart
SentryFlutter.init(
  (options) => options
    // Sentry/GlitchTip DSN and other options
    ..dsn = '<dsn url>'
    ..tracesSampleRate = 1.0
    ..enableAutoSessionTracking = false
    // ..release = '0.0.1'
    // ..dist = 'dev'
    ..debug = true
    ..diagnosticLevel = SentryLevel.debug,
    appRunner: () => runAppGuarded(
      // Setup Simplytics
      Simplytics.setup(
        analyticsService: SimplyticsAnalyticsServiceGroup([
          SimplyticsDebugAnalyticsService(),
        ]),
        crashlogService: SimplyticsCrashlogServiceGroup([
          SimplyticsDebugCrashlogService(),
          SimplyticsSentryCrashlogService(),
        ]),
      );
  
      return const MyApp();
    },
    // It is important to enable this setting when using SentryFlutter
    runAppAfterSetup: true,
    onError: (error, stackTrace) {
      Simplytics.crashlog.recordFatalError(error, stackTrace);
    },
  ),
);
```

