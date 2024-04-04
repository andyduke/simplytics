import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Runs the application, catches all unhandled errors and exceptions,
/// then passes them to the `onError` handler.
///
/// * runner -            A function that creates an application class object. In it you can
///                       make additional settings before running the application, for example,
///                       initializing Firebase.
/// * onError -           Handler for all unhandled errors and exceptions. Here you can send
///                       all errors to the error monitoring service.
/// * ensureInitialized - should `WidgetsFlutterBinding.ensureInitialized()` be called
///                       immediately before app initialization *(default: yes)*?
/// * runAppAfterSetup -  should the application be created after setting up error handlers
///                       or before *(default: before)*?
Future<void> runAppGuarded(
  Future<Widget> Function() runner, {
  required void Function(Object error, StackTrace? stackTrace)? onError,
  bool ensureInitialized = true,
  bool runAppAfterSetup = false,
}) async {
  if (ensureInitialized) {
    // Initialize widget bindings if necessary
    WidgetsFlutterBinding.ensureInitialized();
  }

  Widget? app;
  if (!runAppAfterSetup) {
    // Initializing and creating the application
    app = await runner();
  }

  bool inHandler = false;

  // Save prev handlers
  final FlutterExceptionHandler? oldOnError = FlutterError.onError;
  // final ErrorWidgetBuilder oldBuilder = ErrorWidget.builder;

  // --- Set new handlers

  // Catch Flutter errors
  FlutterError.onError = (FlutterErrorDetails details) {
    // Prevent an infinite loop and fall back to the original handler.
    if (inHandler) {
      try {
        oldOnError?.call(details);
      } catch (ex) {
        // intentionally left empty.
      }
      return;
    }

    // If there's an error in the error handler, we want to know about it.
    inHandler = true;

    if (onError != null) {
      onError(details.exception, details.stack);
    } else if (oldOnError != null) {
      oldOnError(details);
    }

    inHandler = false;
  };

  // Catch Dart errors
  PlatformDispatcher.instance.onError = (error, stack) {
    final handler = onError ?? oldOnError;
    handler?.call(error, stack);
    return true;
  };

  // Catch Isolate errors
  if (!kIsWeb) {
    // Catch any errors in the main() function.
    Isolate.current.addErrorListener(
      RawReceivePort((pair) async {
        final isolateError = pair as List<dynamic>;
        final handler = onError ?? oldOnError;
        handler?.call(
          isolateError.first.toString(),
          isolateError.last.toString(),
        );
      }).sendPort,
    );
  }

  // Run the application
  if (!runAppAfterSetup) {
    runApp(app!);
  } else {
    runApp(await runner());
  }
}
