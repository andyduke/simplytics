# Simplytics (**Simp**le ana**lytics**)

Simple and lightweight **Analytics** and **Crash Reporting** abstraction.

Simplytics is a simple abstraction for analytics and crash reports that allows you to connect several different analytics and error monitoring services such as *Firebase Analytics* and *Crashlytics*, *Sentry*, as well as simple logging of events to the system log.

## Features

- Easily add a new analytics/error monitoring service or replace an already added one without any changes in the application, only changes in the `Simplytics` settings
- Send reports on transitions between routes and events to several different analytics services at once
- Send crash and error reports to several error monitoring services at once
- Easily debug events and send them to the system log
- Easily connect new analytics and error monitoring services
- Easily connect **Firebase Analytics** and **Crashlytics** using [simplytics_firebase](https://pub.dev/packages/simplytics_firebase) package
- Easily connect **Sentry** and **Glitchtip** using [simplytics_sentry](https://pub.dev/packages/simplytics_sentry) package

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
- [Analytics events with type safe parameters](#analytics-events-with-type-safe-parameters)

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

For **Firebase Analytics** and **Crashlytics**, you can use pre-built service classes from the [simplytics_firebase](https://pub.dev/packages/simplytics_firebase) package:
```dart
Simplytics.setup(
  analyticsService: SimplyticsFirebaseAnalyticsService(FirebaseAnalytics.instance),
  crashlogService: SimplyticsFirebaseCrashlogService(FirebaseCrashlytics.instance),
);
```


If you wish to catch all Dart and Flutter errors and exceptions and send them to the error monitoring system, you can do this using `runAppGuarded()`:
```dart
void main() {
  runAppGuarded(
    // Initializing Simplytics and creating an application class object
    () async {
      // Setup Simplytics
      Simplytics.setup(
        analyticsService: SimplyticsDebugAnalyticsService(),
        crashlogService: SimplyticsDebugCrashlogService(),
      );

      // Create an application class object
      return const MyApp();
    },

    // Sends fatal errors to Simplytics
    onError: (error, stackTrace) => Simplytics.crashlog.recordFatalError,
  );
}
```

The `runAppGuarded()` function makes it easy to configure and catch all unhandled errors and exceptions.

It calls `WidgetsFlutterBinding.ensureInitialized()` *(can be disabled)*, configures all Dart and Flutter error handlers, and launches the application. All errors and exceptions will be passed to your handler in the `onError` parameter.


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

#### Adding additional information to a report

When sending a report, you can specify additional information, such as a custom property in the form *"name=value"*, *tag*, etc. To do this, you need to pass one or more objects to the `information` parameter. Simplytics has two predefined objects for describing properties and a tag:
- `SimplyticsErrorProperty` - for a custom property;
- `SimplyticsErrorTag` - for a tag.

For example, to tag a report with the "flow", you can pass `SimplyticsErrorTag`:
```dart
Simplytics.crashlog.recordError(
  'User not found.',
  StackTrace.current,
  reason: 'UserNotFoundException',
  information: [
    SimplyticsErrorTag('flow', 1),
  ],
);
```

The property is added in the same way. You can add several tags and properties at once:
```dart
Simplytics.crashlog.recordError(
  'User not found.',
  StackTrace.current,
  reason: 'UserNotFoundException',
  information: [
    SimplyticsErrorTag('flow', 1),
    SimplyticsErrorProperty('region', 'local'),
    SimplyticsErrorProperty('code', 321),
  ],
);
```

You can also pass other objects, such as `ErrorHint`, `ErrorDescription`, `ErrorSummary`, `ErrorSpacer` and any other dart objects. All of them will be converted to a string and passed along with the report.

> Depending on the implementation of the error monitoring service, attaching additional information to the report may differ. For example, in **Firebase Crashlytics**, tags, properties, and other objects are sent as a block of additional information. In **Sentry**, tags are sent as tags, which allows you to filter reports by tags.


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

To create your own class for the analytics service, you need to extend the `SimplyticsAnalyticsInterface` interface.

Here is an example implementation of an analytics service class for **Firebase Analytics** (but you can use a pre-built class from the [simplytics_firebase](https://pub.dev/packages/simplytics_firebase) package):
```dart
class CustomFirebaseAnalyticsService extends SimplyticsAnalyticsInterface {
  final FirebaseAnalytics analytics;

  CustomFirebaseAnalyticsService(this.analytics);

  bool _enabled = true;

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

  @override
  bool get isEnabled => _enabled;

  @override
  Future<void> setEnabled(bool enabled) {
    _enabled = enabled;
    return analytics.setAnalyticsCollectionEnabled(enabled);
  }
}
```

### Your own error monitoring service class

To create your own class for the crash monitoring service, you need to extend the `SimplyticsCrashlogInterface` interface.

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
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool fatal = false,
  }) {
    return crashlytics.recordError(
      exception,
      stackTrace,
      reason: reason,
      information: information,
      fatal: fatal,
    );
  }

  @override
  Future<void> setCustomKey(String key, Object value) {
    return crashlytics.setCustomKey(key, value);
  }

  @override
  Future<void> setUserId(String identifier) {
    return crashlytics.setUserIdentifier(identifier);
  }

  @override
  bool get isEnabled => crashlytics.isCrashlyticsCollectionEnabled;

  @override
  Future<void> setEnabled(bool enabled) => crashlytics.setCrashlyticsCollectionEnabled(enabled);
}
```

## Analytics events with type safe parameters

You can create your own event classes with type safe parameters and use them when dispatching events:
```dart
Simplytics.analytics.log(PostScoreEvent(score: 7));
```

To do this, extend the `SimplyticsEvent` class and implement its `getEventData` method:
```dart
class PostScoreEvent extends SimplyticsEvent {
  final int score;
  final int level;
  final String? character;

  PostScoreEvent({required this.score, this.level = 1, this.character});

  @override
  SimplyticsEventData getEventData(SimplyticsAnalyticsInterface service) => SimplyticsEventData(
    name: 'post_score',
    parameters: {
      'score': score,
      'level': level,
      'character': character,
    },
  );
}
```

It is possible to send different events for different analytics services
with a different set of parameters by checking the type of the `service` parameter:
```dart
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
```
