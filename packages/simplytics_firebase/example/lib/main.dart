import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:simplytics/simplytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:simplytics_firebase/simplytics_firebase.dart';
import 'package:simplytics_firebase_example/page_route_settings.dart';

void main() {
  MyApp.run();
}

class MyApp extends StatelessWidget {
  // Runs an application in a zone
  static void run() {
    // Initialize Intl & etc.

    runZonedGuarded<Future<void>>(
      () async {
        WidgetsFlutterBinding.ensureInitialized();

        FlutterError.onError = (FlutterErrorDetails details) {
          // Send to Zone handler
          Zone.current.handleUncaughtError(
              details.exception, details.stack ?? StackTrace.current);
        };

        // Setup Firebase
        await Firebase.initializeApp();

        // Setup Simplytics
        Simplytics.setup(
          analyticsService: SimplyticsAnalyticsServiceGroup([
            SimplyticsDebugAnalyticsService(),
            SimplyticsFirebaseAnalyticsService(FirebaseAnalytics.instance),
          ]),
          crashlogService: SimplyticsCrashlogServiceGroup([
            SimplyticsDebugCrashlogService(),
            SimplyticsFirebaseCrashlogService(FirebaseCrashlytics.instance),
          ]),
        );

        // Set custom analytics user's property
        Simplytics.analytics.setUserProperty(
            name: 'app_id', value: 'simplytics_firebase_example');

        runApp(const MyApp());
      },

      // Sends fatal errors to Simplytics
      Simplytics.crashlog.recordFatalError,
    );
  }

  // Setting up an observer
  static SimplyticsNavigatorObserver observer = SimplyticsNavigatorObserver(
    nameExtractor: (route) => (route.settings is PageRouteSettings)
        ? (route.settings as PageRouteSettings).pageName
        : route.settings.name,
    routeFilter: (route) => (route is PageRoute) || (route is RawDialogRoute),
  );

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simplytics Firebase Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const DemoPage(),

      // Adding an observer to navigatorObservers
      navigatorObservers: <NavigatorObserver>[observer],
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
                    // Setting `settings` to set the page name when sending to analytics.
                    settings: const PageRouteSettings(
                        pageName: 'Analytics Demo Page'),
                    builder: (context) => const AnalyticsDemoPage(),
                  ),
                );
              },
              child: const Text('Analytics tests'),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Setting `settings` to set the page name when sending to analytics.
                    settings: const PageRouteSettings(
                        pageName: 'Error Reporting Demo Page'),
                    builder: (context) => const ErrorDemoPage(),
                  ),
                );
              },
              child: const Text('Error Reporting tests'),
            ),
            const Divider(),
            OutlinedButton(
              onPressed: () {
                showDialog(
                    context: context, builder: (context) => const TestDialog());
              },
              child: const Text('Dialog test'),
            ),
            OutlinedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  // Setting `settings` to set the page name when sending to analytics.
                  routeSettings: const PageRouteSettings(
                      pageName: 'Dialog with a named route'),
                  builder: (context) => const TestDialog(),
                );
              },
              child: const Text('Dialog test with a named route'),
            ),
          ],
        ),
      ),
    );
  }
}

// Analytics demo

class PostScoreEvent extends SimplyticsEvent {
  final int score;
  final int level;
  final String? character;

  PostScoreEvent({required this.score, this.level = 1, this.character});

  @override
  SimplyticsEventData getEventData(SimplyticsAnalyticsInterface service) {
    if (service is SimplyticsFirebaseAnalyticsService) {
      return SimplyticsEventData(
        name: 'post_score',
        parameters: {
          'score': score,
          'level': level,
          'character': character,
        },
      );
    } else {
      return SimplyticsEventData(
        name: 'game_score',
        parameters: {
          'scoreValue': score,
          'gameLevel': level,
          'characterName': character,
        },
      );
    }
  }
}

class AnalyticsDemoPage extends StatefulWidget {
  const AnalyticsDemoPage({super.key});

  @override
  State<AnalyticsDemoPage> createState() => _AnalyticsDemoPageState();
}

class _AnalyticsDemoPageState extends State<AnalyticsDemoPage> {
  @override
  void initState() {
    super.initState();

    Simplytics.analytics.setUserId('test_user');
    Simplytics.analytics.setUserProperty(name: 'prop1', value: 'value1');
  }

  void _logEvent() {
    Simplytics.analytics.logEvent(name: 'test_event');
  }

  void _logEventWithParams() {
    Simplytics.analytics
        .logEvent(name: 'test_event', parameters: {'id': 1, 'name': 'Test'});
  }

  void _logTypeSafeEvent() {
    Simplytics.analytics
        .log(PostScoreEvent(score: 7, level: 2, character: 'Dash'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics tests')),
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
                  const Text('Analytics Off'),
                  Switch(
                    value: Simplytics.analytics.isEnabled,
                    onChanged: (value) async {
                      await Simplytics.analytics.setEnabled(value);
                      setState(() {});
                    },
                  ),
                  const Text('Analytics On'),
                ],
              ),
              const Divider(),
              TextButton(
                onPressed: _logEvent,
                child: const Text('Log event'),
              ),
              TextButton(
                onPressed: _logEventWithParams,
                child: const Text('Log event with data'),
              ),
              TextButton(
                onPressed: _logTypeSafeEvent,
                child: const Text('Log type-safe event'),
              ),
            ],
          ),
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
    Simplytics.crashlog
        .recordError('Some error', StackTrace.current, reason: 'FakeException');
  }

  void _recordFatalError() {
    Simplytics.crashlog.recordError('Some error', StackTrace.current,
        reason: 'FakeException', fatal: true);
  }

  void _throwException() {
    throw Exception('Some exception');
  }

  void _flushCrashlytics() {
    FirebaseCrashlytics.instance.sendUnsentReports();
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
              const Divider(),
              TextButton(
                onPressed: _flushCrashlytics,
                child: const Text('Flush Crashlytics'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Test dialog

class TestDialog extends StatelessWidget {
  const TestDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text('Dialog', textAlign: TextAlign.center),
      alignment: Alignment.center,
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text('OK')),
      ],
    );
  }
}
