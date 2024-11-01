import 'package:flutter/foundation.dart';

/// Base class for additional information attached to an error report.
///
/// See also:
///
///  * [SimplyticsErrorTag] and [SimplyticsErrorProperty], that implement this class.
///  * [SimplyticsCrashlogInterface.recordError] and [SimplyticsCrashlogInterface.recordFatalError],
/// which uses in the information parameter.
class SimplyticsErrorInformationProperty
    extends DiagnosticsProperty<List<Object>> {
  SimplyticsErrorInformationProperty(
    String? name,
    Object message, {
    DiagnosticsTreeStyle style = DiagnosticsTreeStyle.flat,
    DiagnosticLevel level = DiagnosticLevel.info,
  }) : super(
          name,
          <Object>[message],
          showName: false,
          showSeparator: false,
          defaultValue: null,
          style: style,
          level: level,
        );

  @override
  String toString({
    TextTreeConfiguration? parentConfiguration,
    DiagnosticLevel minLevel = DiagnosticLevel.info,
  }) {
    return valueToString(parentConfiguration: parentConfiguration);
  }

  @override
  List<Object> get value => super.value!;

  @override
  String valueToString({TextTreeConfiguration? parentConfiguration}) {
    return '$name: ${value.join()}';
  }
}
