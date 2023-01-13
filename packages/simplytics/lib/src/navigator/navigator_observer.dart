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

  void _sendScreenView(Route<dynamic> route) {
    final String? screenName = nameExtractor(route);
    if (screenName != null) {
      Simplytics.analytics.setCurrentScreen(name: screenName).catchError((Object error) {
        final onError = _onError;
        if (onError == null) {
          debugPrint('$SimplyticsNavigatorObserver: $error');
        } else {
          onError(error as PlatformException);
        }
      }, test: (Object error) => error is PlatformException);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (routeFilter(route)) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null && routeFilter(newRoute)) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null && routeFilter(previousRoute) && routeFilter(route)) {
      _sendScreenView(previousRoute);
    }
  }
}
