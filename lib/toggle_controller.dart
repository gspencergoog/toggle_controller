// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ToggleController<T> extends StatefulWidget {
  const ToggleController({Key key, this.child, this.initialValue, this.valueChanged}) : super(key: key);

  final Widget child;
  final T initialValue;
  final ValueChanged<T> valueChanged;

  static T getSharedValue<T>(BuildContext context) {
    assert(context != null);
    final _ToggleControllerScope controllerScope = context.inheritFromWidgetOfExactType(_ToggleControllerScope);
    assert(controllerScope != null, 'Unable to find ancestor ToggleController');
    return controllerScope?.value;
  }

  static void setSharedValue<T>(BuildContext context, T value) {
    // ignore: prefer_const_constructors
    final _ToggleControllerState<T> controllerState = context.ancestorStateOfType(new TypeMatcher<_ToggleControllerState<T>>());
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
      if (widget.valueChanged != null) {
        widget.valueChanged(value);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _sharedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return new _ToggleControllerScope(value: _sharedValue, child: widget.child);
  }
}

class _ToggleControllerScope extends InheritedWidget {
  const _ToggleControllerScope({Key key, Widget child, this.value}) : super(key: key, child: child);

  final dynamic value;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    assert(runtimeType == oldWidget.runtimeType);
    final _ToggleControllerScope oldScope = oldWidget;
    return value != oldScope.value;
  }
}
