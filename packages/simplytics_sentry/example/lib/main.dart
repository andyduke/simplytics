import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:simplytics/simplytics.dart';
import 'package:simplytics_sentry/simplytics_sentry.dart';

void main() {
  // Setup Sentry/GlitchTip
  SentryFlutter.init(
    (options) => options
      // Sentry/GlitchTip DSN and other options
      ..dsn = '<dsn url>'
      ..tracesSampleRate = 1.0
      ..enableAutoSessionTracking = false
      ..diagnosticLevel = SentryLevel.debug,
    appRunner: () => runAppGuarded(
      () async {
        // Setup Simplytics
        Simplytics.setup(
          crashlogService: SimplyticsCrashlogServiceGroup([
            SimplyticsDebugCrashlogService(true),
            SimplyticsSentryCrashlogService(enabled: !kDebugMode),
          ]),
        );

        return const MyApp();
      },

      // It is important to enable this setting when using Sentry
      runAppAfterSetup: true,

      // Sends fatal errors to Simplytics
      onError: (error, stackTrace) => Simplytics.crashlog.recordFatalError,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simplytics Sentry Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const DemoPage(),
    );
  }
}

// Main demo page

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ErrorDemoPage()),
                );
              },
              child: const Text('Error Reporting tests'),
            ),
          ],
        ),
      ),
    );
  }
}

// Crash reporting demo

class ErrorDemoPage extends StatefulWidget {
  const ErrorDemoPage({super.key});

  @override
  State<ErrorDemoPage> createState() => _ErrorDemoPageState();
}

class _ErrorDemoPageState extends State<ErrorDemoPage> {
  @override
  void initState() {
    super.initState();

    Simplytics.crashlog.setUserId('test_user');
    Simplytics.crashlog.setCustomKey('test_key', 'test_value');
  }

  void _logError() {
    Simplytics.crashlog.log('Some log error');
  }

  void _recordError() {
    Simplytics.crashlog.recordError(
      'Some error',
      StackTrace.current,
      information: [
        SimplyticsErrorTag('code', 712234),
        SimplyticsErrorProperty('region', 'local'),
      ],
      reason: 'FakeException',
    );
  }

  void _recordFatalError() {
    Simplytics.crashlog.recordError(
      'Some error',
      StackTrace.current,
      reason: 'FakeException',
      fatal: true,
    );
  }

  void _throwException() {
    throw Exception('Some exception');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Reporting tests'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Crashlog Off'),
                  Switch(
                    value: Simplytics.crashlog.isEnabled,
                    onChanged: (value) async {
                      await Simplytics.crashlog.setEnabled(value);
                      setState(() {});
                    },
                  ),
                  const Text('Crashlog On'),
                ],
              ),
              const Divider(),
              TextButton(
                onPressed: _logError,
                child: const Text('Log error'),
              ),
              TextButton(
                onPressed: _recordError,
                child: const Text('Record error'),
              ),
              TextButton(
                onPressed: _recordFatalError,
                child: const Text('Record fatal error'),
              ),
              TextButton(
                onPressed: _throwException,
                child: const Text('Throw exception'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
