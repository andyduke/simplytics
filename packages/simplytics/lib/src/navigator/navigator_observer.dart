import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:simplytics/src/simplytics.dart';

/// Signature for a function that extracts a screen name from [Route.settings].
///
/// Usually, the route name is not a plain string, and it may contains some
/// unique ids that makes it difficult to aggregate over them in analytics service.
typedef ScreenNameExtractor = String? Function(Route<dynamic> route);

/// The default function to extract the route name from [Route.settings]`.name`.
String? defaultNameExtractor(Route<dynamic> route) => route.settings.name;

/// [RouteFilter] allows to filter out routes that should not be tracked.
///
/// By default, only [PageRoute]s are tracked.
typedef RouteFilter = bool Function(Route<dynamic>? route);

/// Default route filter, specifies to track only the [PageRoute] and its descendants.
bool defaultRouteFilter(Route<dynamic>? route) => route is PageRoute;

/// A [NavigatorObserver] that sends events to analytics service when the currently active [ModalRoute] changes.
///
/// To use it, add it to the `navigatorObservers` of your [Navigator], e.g. if you're using a [MaterialApp]:
/// ```dart
/// MaterialApp(
///   home: MyAppHome(),
///   navigatorObservers: [
///     SimplyticsNavigatorObserver(),
///   ],
/// );
/// ```
///
/// You can configure the extraction of the route name from [RouteSettings] using the [nameExtractor] parameter,
/// as well as filter transitions between which routes will be automatically sent to the analytics service
/// using the [routeFilter] parameter.
class SimplyticsNavigatorObserver extends NavigatorObserver {
  /// Creates a [NavigatorObserver] that sends events to analytic service.
  SimplyticsNavigatorObserver({
    this.nameExtractor = defaultNameExtractor,
    this.routeFilter = defaultRouteFilter,
    Function(PlatformException error)? onError,
  }) : _onError = onError;

  /// A function that extracts a screen name from [Route.settings].
  final ScreenNameExtractor nameExtractor;

  /// A function that allows you to filter out routes that should not be tracked.
  final RouteFilter routeFilter;

  final void Function(PlatformException error)? _onError;

  void _sendRouteStart(Route<dynamic> route) {
    final String? screenName = nameExtractor(route);
    if (screenName != null) {
      Simplytics.analytics.routeStart(name: screenName).catchError(
          _handleAnalyticsErrors,
          test: (Object error) => error is PlatformException);
    }
  }

  void _sendRouteEnd(Route<dynamic> route) {
    final String? screenName = nameExtractor(route);
    if (screenName != null) {
      Simplytics.analytics.routeEnd(name: screenName).catchError(
          _handleAnalyticsErrors,
          test: (Object error) => error is PlatformException);
    }
  }

  void _handleAnalyticsErrors(Object error) {
    final onError = _onError;
    if (onError == null) {
      debugPrint('$SimplyticsNavigatorObserver: $error');
    } else {
      onError(error as PlatformException);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    if (previousRoute != null &&
        routeFilter(previousRoute) &&
        routeFilter(route)) {
      _sendRouteEnd(previousRoute);
    }

    if (routeFilter(route)) {
      _sendRouteStart(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    if (oldRoute != null && routeFilter(oldRoute)) {
      _sendRouteEnd(oldRoute);
    }

    if (newRoute != null && routeFilter(newRoute)) {
      _sendRouteStart(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    if (routeFilter(route)) {
      _sendRouteEnd(route);
    }

    if (previousRoute != null &&
        routeFilter(previousRoute) &&
        routeFilter(route)) {
      _sendRouteStart(previousRoute);
    }
  }
}
