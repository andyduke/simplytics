import 'package:simplytics/src/analytics/analytics_interface.dart';

/// An interface that allows you to create type safe analytics events.
///
/// For example, you can create an event to send a game score:
/// ```dart
/// class PostScoreEvent extends SimplyticsEvent {
///   final int score;
///   final int level;
///   final String? character;
///
///   PostScoreEvent({required this.score, this.level = 1, this.character});
///
///   @override
///   SimplyticsEventData getEventData(SimplyticsAnalyticsInterface service) => SimplyticsEventData(
///     name: 'post_score',
///     parameters: {
///       'score': score,
///       'level': level,
///       'character': character,
///     },
///   );
/// }
/// ```
///
/// ...and then use it in your code:
/// ```dart
/// Simplytics.analytics.log(PostScoreEvent(score: 7));
/// ```
/// ---
/// It is possible to send different events for different analytics services
/// with a different set of parameters by checking the type of the [service] parameter:
/// ```dart
/// @override
/// SimplyticsEventData getEventData(SimplyticsAnalyticsInterface service) {
///   if (service is SimplyticsFirebaseAnalyticsService) {
///     return SimplyticsEventData(
///       name: 'post_score',
///       parameters: {
///         'score': score,
///         'level': level,
///         'character': character,
///       },
///     );
///   } else {
///     return SimplyticsEventData(
///       name: 'game_score',
///       parameters: {
///         'scoreValue': score,
///         'gameLevel': level,
///         'characterName': character,
///       },
///     );
///   }
/// );
/// ```
abstract class SimplyticsEvent {
  /// Return the description of the event to send to the analytics service.
  ///
  /// By checking the [service] parameter, you can prepare different events
  /// for different analytics services.
  SimplyticsEventData getEventData(SimplyticsAnalyticsInterface service);
}

/// A class that describes the event to send to the analytics service (used in [SimplyticsEvent]).
class SimplyticsEventData {
  /// Event name.
  final String name;

  /// Parameters that are sent along with the event.
  final Map<String, Object?>? parameters;

  /// Creates a class that describes an analytics service event.
  SimplyticsEventData({
    required this.name,
    this.parameters,
  });
}
