import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:simplytics/src/simplytics.dart';

/// Signature for a function that extracts a screen name from [RouteSettings].
///
/// Usually, the route name is not a plain string, and it may contains some
/// unique ids that makes it difficult to aggregate over them in Firebase
/// Analytics.
typedef ScreenNameExtractor = String? Function(Route<dynamic> route);

String? defaultNameExtractor(Route<dynamic> route) => route.settings.name;

/// [RouteFilter] allows to filter out routes that should not be tracked.
///
/// By default, only [PageRoute]s are tracked.
typedef RouteFilter = bool Function(Route<dynamic>? route);

bool defaultRouteFilter(Route<dynamic>? route) => route is PageRoute;

class SimplyticsNavigatorObserver extends NavigatorObserver {
  SimplyticsNavigatorObserver({
    this.nameExtractor = defaultNameExtractor,
    this.routeFilter = defaultRouteFilter,
    Function(PlatformException error)? onError,
  }) : _onError = onError;

  final ScreenNameExtractor nameExtractor;
  final RouteFilter routeFilter;
  final void Function(PlatformException error)? _onError;

  void _sendRouteStart(Route<dynamic> route) {
    final String? screenName = nameExtractor(route);
    if (screenName != null) {
      Simplytics.analytics
          .routeStart(name: screenName)
          .catchError(_handleAnalyticsErrors, test: (Object error) => error is PlatformException);
    }
  }

  void _sendRouteEnd(Route<dynamic> route) {
    final String? screenName = nameExtractor(route);
    if (screenName != null) {
      Simplytics.analytics
          .routeEnd(name: screenName)
          .catchError(_handleAnalyticsErrors, test: (Object error) => error is PlatformException);
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

    if (previousRoute != null && routeFilter(previousRoute) && routeFilter(route)) {
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

    if (previousRoute != null && routeFilter(previousRoute) && routeFilter(route)) {
      _sendRouteStart(previousRoute);
    }
  }
}
