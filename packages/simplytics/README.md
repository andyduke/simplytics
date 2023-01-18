# Simplytics (**Simp**le ana**lytics**)

Simple and lightweight **Analytics** and **Crash Reporting** abstraction.

Simplytics is a simple abstraction for analytics and crash reports that allows you to connect several different analytics and error monitoring services such as *Firebase Analytics* and *Crashlytics*, as well as simple logging of events to the system log.

## Features

- Send reports on transitions between routes and events to several different analytics services at once
- Send crash and error reports to several error monitoring services at once
- Easily debug events and send them to the system log
- Easily connect new analytics and error monitoring services
- Easily connect **Firebase Analytics** and **Crashlytics** using [simplytics_firebase](https://pub.dev/packages/simplytics_firebase) package

## Table of Contents

- [Getting started](#getting-started)
- [Usage](#usage)
  - [Sending events](#sending-events)
  - [Track transitions between routes](#track-transitions-between-routes)
  - [Sending errors to the error monitoring service](#sending-errors-to-the-error-monitoring-service)
  - [Set user identity and custom properties](#set-user-identity-and-custom-properties)
- [Debugging analytics events and error reporting](#debugging-analytics-events-and-error-reporting)
- [Creating your own analytics and error monitoring service classes](#creating-your-own-analytics-and-error-monitoring-service-classes)
  - [Your own analytics service class](#your-own-analytics-service-class)
  - [Your own error monitoring service class](#your-own-error-monitoring-service-class)

## Getting started

To start using Simplytics, you need to configure it, specify which classes of analytics and error monitoring services to use:
```dart
Simplytics.setup(
  analyticsService: SimplyticsDebugAnalyticsService(),
  crashlogService: SimplyticsDebugCrashlogService(),
);
```

**Attention!** These setup needs to be done before `runApp()`:
```dart
void main() {
  Simplytics.setup(
    analyticsService: SimplyticsDebugAnalyticsService(),
    crashlogService: SimplyticsDebugCrashlogService(),
  );

  runApp(const MyApp());
}
```

You can use more than one service for both analytics and error monitoring. To do this, you need to wrap them in groups:
```dart
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
```

You can use **Firebase Analytics** and **Crashlytics** with the [simplytics_firebase](https://pub.dev/packages/simplytics_firebase) package:
```dart
  Simplytics.setup(
    analyticsService: SimplyticsFirebaseAnalyticsService(FirebaseAnalytics.instance),
    crashlogService: SimplyticsFirebaseCrashlogService(FirebaseCrashlytics.instance),
  );
```


If you wish to catch all Dart and Flutter errors and exceptions and send them to the error monitoring system, you can do so by wrapping `runApp()` in a **zone** and assigning `FlutterError.onError`:
```dart
void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (FlutterErrorDetails details) {
      // Send to Zone handler
      Zone.current.handleUncaughtError(details.exception, details.stack ?? StackTrace.current);
    };

    Simplytics.setup(
      analyticsService: SimplyticsDebugAnalyticsService(),
      crashlogService: SimplyticsDebugCrashlogService(),
    );

    runApp(const MyApp());
  }, (error, stackTrace) {
    Simplytics.crashlog.recordError(error, stackTrace);
  });
}
```

## Usage

### Sending events

To send events to analytics services, you can use the `logEvent` method of the `Simplytics.analytics` object:
```dart
Simplytics.analytics.logEvent(name: 'button_tapped');
```

You can pass parameters to the event in the `Map<String, Object>`:
```dart
Simplytics.analytics.logEvent(name: 'product_details', parameters: {'id': 1, 'name': 'Product 1'});
```

You can clear all analytics data on a device with `resetAnalyticsData`:
```dart
Simplytics.analytics.resetAnalyticsData();
```

### Track transitions between routes

To track navigation between routes, you can use the `SimplyticsNavigatorObserver` observer in your application:
```dart
class MyApp extends StatelessWidget {

  // Creating an instance of the Simplytics observer
  static SimplyticsNavigatorObserver simplyticsObserver = SimplyticsNavigatorObserver();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simplytics Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const DemoPage(),

      // Passing an instance of the Simplytics observer
      navigatorObservers: <NavigatorObserver>[simplyticsObserver],
    );
  }

}
```

The observer will send events to the analytics service when the current active `ModalRoute` changes.

You can configure the extraction of the route name from `RouteSettings` using the `nameExtractor` parameter, as well as filter transitions between which routes will be automatically sent to the analytics service using the `routeFilter` parameter.

You can also manually dispatch route entry and exit events using the `routeStart` and `routeEnd` methods of the `Simplytics.analytics` object:
```dart
Simplytics.analytics.routeStart('Login Screen');
...
Simplytics.analytics.routeEnd('Login Screen');
```

### Sending errors to the error monitoring service

You can send error information to the error monitoring service using the `recordError()` method of the `Simplytics.crashlog` object:
```dart
Simplytics.crashlog.recordError('Entity not found.', StackTrace.current, reason: 'NotFoundException');
```

### Set user identity and custom properties

You can store the user identity to the analytics and error monitoring services using the `setUserId` method of the corresponding objects:
```dart
Simplytics.analytics.setUserId('user_1');
Simplytics.crashlog.setUserId('user_1');
```

You can also add custom properties and keys to the analytics and error monitoring services using the `setUserProperty` and `setCustomKey` methods:
```dart
// Setting a user property for an analytics service
Simplytics.analytics.setUserProperty(name: 'prop1', value: 'value1');

// Setting a custom key for the error monitoring service
Simplytics.crashlog.setCustomKey('test_key', 'test_value');
```

## Debugging analytics events and error reporting

To debug events, you can use the `SimplyticsDebugAnalyticsService` and `SimplyticsDebugCrashlogService` service classes, which output analytics events and error reports to the system log in debug compilation mode (`kDebugMode`):
```dart
Simplytics.setup(
  analyticsService: SimplyticsAnalyticsServiceGroup([
    // Sending events to system log in kDebugMode
    SimplyticsDebugAnalyticsService(),

    CustomAnalyticsService(),
  ]),
  crashlogService: SimplyticsCrashlogServiceGroup([
    // Sending events to system log in kDebugMode
    SimplyticsDebugCrashlogService(),

    CustomCrashReportingService(),
  ]),
);
```

This behavior can be configured using the constructor parameter of these classes:
```dart
// Always send events to system log
SimplyticsDebugAnalyticsService(true)
```

## Creating your own analytics and error monitoring service classes

For your own or any other analytics and error monitoring services, you can create your own service classes and use them in `Simplytics.setup()`.

### Your own analytics service class

To create your own class for the analytics service, you need to implement the `SimplyticsAnalyticsInterface` interface.

Here is an example implementation of an analytics service class for **Firebase Analytics** (but you can use a pre-built class from the [simplytics_firebase](https://pub.dev/packages/simplytics_firebase) package):
```dart
class CustomFirebaseAnalyticsService implements SimplyticsAnalyticsInterface {
  final FirebaseAnalytics analytics;

  CustomFirebaseAnalyticsService(this.analytics);

  @override
  Future<void> logEvent({required String name, Map<String, Object?>? parameters}) {
    return analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> resetAnalyticsData() {
    return analytics.resetAnalyticsData();
  }

  @override
  Future<void> routeStart({required String name, String? screenClassOverride}) {
    return analytics.setCurrentScreen(screenName: name, screenClassOverride: screenClassOverride ?? 'Flutter');
  }

  @override
  Future<void> routeEnd({required String name}) async {}

  @override
  Future<void> setUserId(String? id) {
    return analytics.setUserId(id: id);
  }

  @override
  Future<void> setUserProperty({required String name, required String? value}) {
    return analytics.setUserProperty(name: name, value: value);
  }
}
```

### Your own error monitoring service class

To create your own class for the crash monitoring service, you need to implement the `SimplyticsCrashlogInterface` interface.

Here is an example implementation of the **Firebase Crashlytics** error monitoring service class (but you can use the pre-built class from the [simplytics_firebase](https://pub.dev/packages/simplytics_firebase) package):
```dart
class CustomFirebaseCrashlogService extends SimplyticsCrashlogInterface {
  final FirebaseCrashlytics crashlytics;

  CustomFirebaseCrashlogService(this.crashlytics);

  @override
  Future<void> log(String message) {
    return crashlytics.log(message);
  }

  @override
  Future<void> recordError(exception, StackTrace? stackTrace, {reason, bool fatal = false}) {
    return crashlytics.recordError(exception, stackTrace, reason: reason, fatal: fatal);
  }

  @override
  Future<void> setCustomKey(String key, Object value) {
    return crashlytics.setCustomKey(key, value);
  }

  @override
  Future<void> setUserId(String identifier) {
    return crashlytics.setUserIdentifier(identifier);
  }
}
```
