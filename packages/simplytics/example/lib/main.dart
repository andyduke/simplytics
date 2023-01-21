import 'dart:async';
import 'package:flutter/material.dart';
import 'package:simplytics/simplytics.dart';
import 'package:simplytics_example/page_route_settings.dart';
import 'package:simplytics_example/services/custom_analytics_service.dart';
import 'package:simplytics_example/services/custom_crash_reporting_service.dart';

void main() {
  MyApp.run();
}

class MyApp extends StatelessWidget {
  static void run() {
    // Initialize Intl & etc.

    runZonedGuarded<Future<void>>(() async {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (FlutterErrorDetails details) {
        // Send to Zone handler
        Zone.current.handleUncaughtError(details.exception, details.stack ?? StackTrace.current);
      };

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

      runApp(const MyApp());
    }, Simplytics.crashlog.recordError);
    /*
    }, (error, stackTrace) {
      // debugPrint('============ ERROR ============');
      // debugPrint('$error\n$stackTrace');

      Simplytics.crashlog.recordError(error, stackTrace);

      // runApp(ErrorDisplayApp(
      //   title: title,
      //   builder: (context) => ErrorDisplay(
      //     error: '$error',
      //     details: '$stackTrace',
      //   ),
      // ));
    });
    */
  }

  // ---

  static SimplyticsNavigatorObserver observer = SimplyticsNavigatorObserver(
    nameExtractor: (route) =>
        (route.settings is PageRouteSettings) ? (route.settings as PageRouteSettings).pageName : route.settings.name,
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
      navigatorObservers: <NavigatorObserver>[observer],
    );
  }
}

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
                    settings: const PageRouteSettings(pageName: 'Error Demo Page'),
                    builder: (context) => const ErrorDemoPage(),
                  ),
                );
              },
              child: const Text('Error Reporting tests'),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: const PageRouteSettings(pageName: 'Analytics Demo Page'),
                    builder: (context) => const AnalyticsDemoPage(),
                  ),
                );
              },
              child: const Text('Analytics tests'),
            ),
            OutlinedButton(
              onPressed: () {
                showDialog(context: context, builder: (context) => const TestDialog());
              },
              child: const Text('Dialog test'),
            ),
            OutlinedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  routeSettings: const PageRouteSettings(pageName: 'Named Dialog'),
                  builder: (context) => const TestDialog(),
                );
              },
              child: const Text('Named Dialog test'),
            ),
          ],
        ),
      ),
    );
  }
}

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
    Simplytics.crashlog.recordError('Some error', StackTrace.current, reason: 'FakeException');
  }

  void _recordFatalError() {
    Simplytics.crashlog.recordError('Some error', StackTrace.current, reason: 'FakeException', fatal: true);
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
    // Simplytics.analytics
    //     .routeStart(name: 'Analytics Demo Screen', screenClassOverride: objectRuntimeType(widget, '<optimized out>'));
  }

  void _logEvent() {
    Simplytics.analytics.logEvent(name: 'test_event');
  }

  void _logEventWithParams() {
    Simplytics.analytics.logEvent(name: 'test_event', parameters: {'id': 1, 'name': 'Test'});
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
              TextButton(
                onPressed: _logEvent,
                child: const Text('Log event'),
              ),
              TextButton(
                onPressed: _logEventWithParams,
                child: const Text('Log event with data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TestDialog extends StatelessWidget {
  const TestDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text('Dialog', textAlign: TextAlign.center),
      alignment: Alignment.center,
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
      ],
    );
  }
}
