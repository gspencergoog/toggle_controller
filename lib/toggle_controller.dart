// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ToggleController<T> extends StatefulWidget {
  const ToggleController({Key key, this.child, this.initialValue}) : super(key: key);

  final Widget child;
  final T initialValue;

  static T getToggleState<T>(BuildContext context) {
    assert(context != null);
    final Type type = const _ToggleControllerScope<T>._type().runtimeType;
    final _ToggleControllerScope<T> controllerScope = context.inheritFromWidgetOfExactType(type);
    return controllerScope?.value;
  }

  static void setToggleState<T>(BuildContext context, T value) {
    final _ToggleControllerState<T> controllerState = context.ancestorStateOfType(const TypeMatcher<_ToggleControllerState<T>>());
    assert(controllerState != null);
    controllerState.sharedValue = value;
  }

  @override
  _ToggleControllerState<T> createState() {
    return new _ToggleControllerState<T>();
  }
}

class _ToggleControllerState<T> extends State<ToggleController<T>> {
  T _sharedValue;
  T get sharedValue => _sharedValue;
  set sharedValue(T value) {
    if (value == _sharedValue) {
      return;
    }
    setState(() {
      _sharedValue = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _sharedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return new _ToggleControllerScope<T>(value: _sharedValue, child: widget.child);
  }
}

class _ToggleControllerScope<T> extends InheritedWidget {
  const _ToggleControllerScope({Key key, Widget child, this.value}) : super(key: key, child: child);

  // This is only used to get the runtime type of the generic so we can search for it.
  const _ToggleControllerScope._type() : value = null;

  final T value;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    assert(runtimeType == oldWidget.runtimeType);
    final _ToggleControllerScope<T> oldScope = oldWidget;
    return value != oldScope.value;
  }
}
