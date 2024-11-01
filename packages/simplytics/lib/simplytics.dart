/// Simple and lightweight **Analytics** and **Crash Reporting** abstraction.
library simplytics;

export 'src/analytics/analytics_interface.dart';
export 'src/analytics/analytics_event.dart';
export 'src/analytics/services/default_analytics_service.dart';
export 'src/analytics/services/debug_analytics_service.dart';
export 'src/analytics/services/analytics_service_group.dart';

export 'src/crash_reporting/crashlog_interface.dart';
export 'src/crash_reporting/services/default_crash_reporting_service.dart';
export 'src/crash_reporting/services/debug_crashlog_service.dart';
export 'src/crash_reporting/services/crashlog_service_group.dart';
export 'src/crash_reporting/information_properties/error_information_property.dart';
export 'src/crash_reporting/information_properties/error_tag.dart';
export 'src/crash_reporting/information_properties/error_property.dart';

export 'src/navigator/navigator_observer.dart';

export 'src/run_app_guarded.dart';

export 'src/simplytics.dart';
