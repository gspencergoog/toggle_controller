// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'toggle_controller.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = new ThemeData.light();
    return new MaterialApp(
      title: 'Toggle Controller',
      theme: theme,
      home: DefaultTextStyle(
        style: theme.textTheme.body2,
        child: const MyHomePage(title: 'Toggle Controller'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: const Color(0xff808080),
      child: new ToggleController<ToggleState>(
        initialValue: ToggleState.go,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            const ExampleToggleButton(ToggleState.happy),
            const ExampleToggleButton(ToggleState.go),
            const ExampleToggleButton(ToggleState.lucky),
          ],
        ),
      ),
    );
  }
}


enum ToggleState {
  happy,
  go,
  lucky,
}

class ExampleToggleButton extends StatelessWidget {
  const ExampleToggleButton(this.selectState);

  final ToggleState selectState;

  @override
  Widget build(BuildContext context) {
    final ToggleState toggleState = ToggleController.getToggleState<ToggleState>(context);
    final bool isSelected = toggleState == selectState;
    final TextStyle textSyle = DefaultTextStyle.of(context).style.copyWith(
      color: isSelected ? const Color(0xffffffff) : const Color(0xff000000),
    );
    Widget button = new Container(
      width: 50.0,
      height: 50.0,
      decoration: new ShapeDecoration(
        shape: const StadiumBorder(),
        color: isSelected ? const Color(0xff000000) : const Color(0xffffffff),
      ),
      alignment: Alignment.center,
      child: new Text(describeEnum(selectState), style: textSyle),
    );

    if (!isSelected) {
      button = GestureDetector(
        onTap: () {
          ToggleController.setToggleState<ToggleState>(context, selectState);
        },
        child: button,
      );
    }
    return new Padding(padding: const EdgeInsets.all(8.0), child: button);
  }
}
