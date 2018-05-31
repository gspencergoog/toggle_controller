// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A widget to manage shared state for its descendants.
///
/// This can be used for keeping state of mutually-exclusive widgets, such
/// as toggles or radio buttons, or when multiple widgets need their state to
/// be kept in sync.
///
/// When the shared state is updated, all of the widgets that depend upon it
/// will be rebuilt, and (if set), the optional [valueChanged] callback will be
/// called.
///
/// This widget doesn't keep the state itself, it uses the state passed in.
class SharedState<T> extends StatelessWidget {
  /// Creates a [SharedState].
  ///
  /// The `child` and `valueChanged` arguments are required and must not be null.
  const SharedState({
    Key key,
    this.value,
    @required this.valueChanged,
    @required this.child,
  })  : assert(valueChanged != null),
        assert(child != null),
        super(key: key);

  /// The child that contains the descendants of this shared state.  All
  /// descendants of [child] will have access to the shared state.
  final Widget child;

  /// The value of the shared state.
  final T value;

  /// The [ValueChanged] callback that is called when the shared state is
  /// changed.
  final ValueChanged<T> valueChanged;

  static _SharedStateScope<T> _getScope<T>(BuildContext context) {
    assert(context != null);
    final _SharedStateScope<T> controllerScope = context.inheritFromWidgetOfExactType(
      // TODO(gspencer): Remove ignore when https://github.com/dart-lang/sdk/issues/33289 is fixed.
      // ignore: prefer_const_constructors
      new TypeMatcher<_SharedStateScope<T>>().type,
    );
    return controllerScope;
  }

  /// Get the shared state of the nearest enclosing [SharedState] widget of the
  /// same type in the widget tree.
  static T getSharedState<T>(BuildContext context, {bool nullOk: false}) {
    final _SharedStateScope<T> controllerScope = _getScope(context);
    if (controllerScope != null) {
      return controllerScope.value;
    }
    if (nullOk) {
      return null;
    }
    throw new FlutterError('SharedState<$T>.getSharedState() called with a context that does not '
        'contain a SharedState of the right type.\n'
        'No SharedState ancestor could be found starting from the context that was passed '
        'to SharedState<$T>.getSharedState(). This can happen if you have not inserted a '
        'SharedState widget, or if the context you use comes from a widget above the '
        'SharedState widget.\n'
        'The context used was:\n'
        '  $context');
  }

  /// Sets the shared state, possibly scheduling a rebuild the descendants that depend
  /// upon it.
  static void setSharedState<T>(BuildContext context, T newValue) {
    final _SharedStateScope<T> controllerScope = _getScope(context);
    assert(() {
      if (controllerScope == null) {
        throw new FlutterError('SharedState<$T>.setSharedState() called with a context that does '
            'not contain a SharedState of the right type.\n'
            'No SharedState ancestor could be found starting from the context that was passed '
            'to SharedState<$T>.setSharedState(). This can happen if you have not inserted a '
            'SharedState widget, or if the context you use comes from a widget above the '
            'SharedState widget.\n'
            'The context used was:\n'
            '  $context');
      }
      return controllerScope != null;
    }());
    if (controllerScope != null && newValue != controllerScope.value) {
      controllerScope.valueChanged(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new _SharedStateScope<T>(value: value, valueChanged: valueChanged, child: child);
  }
}

class _SharedStateScope<T> extends InheritedWidget {
  const _SharedStateScope({Key key, this.value, this.valueChanged, Widget child}) : super(key: key, child: child);

  final T value;
  final ValueChanged<T> valueChanged;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    assert(runtimeType == oldWidget.runtimeType);
    final _SharedStateScope<T> oldScope = oldWidget;
    return value != oldScope.value;
  }
}
