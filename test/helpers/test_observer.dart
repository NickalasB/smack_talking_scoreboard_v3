// borrowed from Flutter repo https://github.com/flutter/flutter/blob/e7b7ebc066c1b2a5aa5c19f8961307427e0142a6/packages/flutter/test/widgets/observer_tester.dart

import 'package:flutter/material.dart';

typedef OnObservation = void Function(
  Route<dynamic>? route,
  Route<dynamic>? previousRoute,
);

/// A trivial observer for testing the navigator.
class TestObserver extends NavigatorObserver {
  Route<dynamic>? previousRoute;
  Route<dynamic>? newRoute;

  OnObservation? onPushed;
  bool didPushRoute = false;

  OnObservation? onPopped;
  bool didPopRoute = false;

  OnObservation? onRemoved;
  OnObservation? onReplaced;
  OnObservation? onStartUserGesture;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    this.previousRoute = previousRoute;
    newRoute = route;

    didPushRoute = true;
    onPushed?.call(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    this.previousRoute = previousRoute;
    newRoute = route;

    didPopRoute = true;
    onPopped?.call(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    this.previousRoute = previousRoute;
    newRoute = route;

    onRemoved?.call(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? oldRoute, Route<dynamic>? newRoute}) {
    previousRoute = oldRoute;
    this.newRoute = newRoute;

    onReplaced?.call(newRoute, oldRoute);
  }

  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    onStartUserGesture?.call(route, previousRoute);
  }
}
