# Simplytics Firebase Analytics and Crashlytics

[Simplytics](https://pub.dev/packages/simplytics) is a simple abstraction for analytics and crash reporting.
This package adds implementation of **Firebase Analytics** and **Crashlytics** services to Simplytics.

## Usage

To start using Simplytics with Firebase, you need to initialize Firebase and configure Simplytics, specify which classes of analytics and error monitoring services to use:
```dart
await Firebase.initializeApp();

Simplytics.setup(
  analyticsService: SimplyticsFirebaseAnalyticsService(FirebaseAnalytics.instance),
  crashlogService: SimplyticsFirebaseCrashlogService(FirebaseCrashlytics.instance),
);
```

## Firebase Debug

### Firebase Analytics

To see analytics events in the Firebase Analytics DebugView, you need to run the following command:
```sh
adb shell setprop debug.firebase.analytics.app <PACKAGE_NAME>
```
See the Firebase Analytics [documentation](https://firebase.google.com/docs/analytics/debugview) for more details.

### Firebase Crashlytics

To see the error reports that are sent to Firebase Crashlytics, you need to run the following command:
```sh
adb shell setprop log.tag.FirebaseCrashlytics DEBUG
```

...and to disable the output of these reports to the system log, you must run the following command:
```sh
adb shell setprop log.tag.FirebaseCrashlytics INFO
```
