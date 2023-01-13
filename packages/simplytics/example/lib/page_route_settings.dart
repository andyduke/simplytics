import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class PageRouteSettings extends RouteSettings {
  final String? pageName;

  const PageRouteSettings({
    super.name,
    super.arguments,
    this.pageName,
  });

  @override
  PageRouteSettings copyWith({
    String? name,
    Object? arguments,
    String? pageName,
  }) {
    return PageRouteSettings(
      name: name ?? this.name,
      arguments: arguments ?? this.arguments,
      pageName: pageName ?? this.pageName,
    );
  }

  @override
  String toString() =>
      '${objectRuntimeType(this, 'PageRouteSettings')}(${(pageName != null) ? '$pageName: ' : ''}"$name", $arguments)';
}
