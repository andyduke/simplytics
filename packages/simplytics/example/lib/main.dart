import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simplytics/simplytics.dart';
import 'package:simplytics_example/page_route_settings.dart';
import 'package:simplytics_example/services/custom_analytics_service.dart';
import 'package:simplytics_example/services/custom_crash_reporting_service.dart';

void main() {
  runAppGuarded(
    // Initializing Simplytics and creating an application class object
    () async {
      // Setup Simplytics
      Simplytics.setup(
        analyticsService: SimplyticsAnalyticsServiceGroup([
          SimplyticsDebugAnalyticsService(),
          CustomAnalyticsService(),
        ]),
        crashlogService: SimplyticsCrashlogServiceGroup([
          SimplyticsDebugCrashlogService(),
          CustomCrashReportingService(),
        ]),
      );

      return const MyApp();
    },

    // Sends fatal errors to Simplytics
    onError: (error, stackTrace) => Simplytics.crashlog.recordFatalError,
  );
}

class MyApp extends StatelessWidget {
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
      title: 'Simplytics Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
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
  SimplyticsEventData getEventData(SimplyticsAnalyticsInterface service) =>
      SimplyticsEventData(
        name: 'post_score',
        parameters: {
          'score': score,
          'level': level,
          'character': character,
        },
      );
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
    Simplytics.crashlog.recordError(
      'Some error',
      StackTrace.current,
      information: [
        ErrorHint('Error hint...'),
        ErrorDescription('Error description...'),
        ErrorSummary('Error summary...'),
        ErrorSpacer(),
        SimplyticsErrorTag('tag1', 7),
        SimplyticsErrorProperty('prop1', 'a'),
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
