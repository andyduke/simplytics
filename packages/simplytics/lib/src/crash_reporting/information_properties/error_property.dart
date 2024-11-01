import 'package:flutter/foundation.dart';
import 'package:simplytics/src/crash_reporting/information_properties/error_information_property.dart';

/// Allows you to add an informational property to an error message
/// when reporting it to the error monitoring system.
///
/// See also:
///
///  * [SimplyticsCrashlogInterface.recordError] and [SimplyticsCrashlogInterface.recordFatalError],
/// which uses in the information parameter.
class SimplyticsErrorProperty extends SimplyticsErrorInformationProperty {
  /// Creates a property with the "name" and the "value" for reporting to the error monitoring system.
  SimplyticsErrorProperty(String name, Object value)
      : super(name, value, level: DiagnosticLevel.hint);

  @override
  String get name => super.name ?? '';
}
