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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new ToggleController<ToggleState>(
            initialValue: ToggleState.go,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                const ExampleAnimatedButton(ToggleState.happy),
                const ExampleAnimatedButton(ToggleState.go),
                const ExampleAnimatedButton(ToggleState.lucky),
                const ExampleAnimatedButton(ToggleState.radio),
                const ExampleAnimatedButton(ToggleState.buttons),
              ],
            ),
          ),
          new ToggleController<ToggleState>(
            initialValue: ToggleState.go,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                const ExampleToggleButton(ToggleState.happy),
                const ExampleToggleButton(ToggleState.go),
                const ExampleToggleButton(ToggleState.lucky),
                const ExampleToggleButton(ToggleState.radio),
                const ExampleToggleButton(ToggleState.buttons),
              ],
            ),
          ),
          new ToggleController<List<ToggleState>>(
            initialValue: const <ToggleState>[ToggleState.happy, ToggleState.radio],
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                const ExampleOnlyTwoButton(ToggleState.happy),
                const ExampleOnlyTwoButton(ToggleState.go),
                const ExampleOnlyTwoButton(ToggleState.lucky),
                const ExampleOnlyTwoButton(ToggleState.radio),
                const ExampleOnlyTwoButton(ToggleState.buttons),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum ToggleState {
  happy,
  go,
  lucky,
  radio,
  buttons,
}

class ExampleToggleButton extends StatelessWidget {
  const ExampleToggleButton(this.selectState);

  final ToggleState selectState;

  @override
  Widget build(BuildContext context) {
    final ToggleState toggleState = ToggleController.getSharedValue<ToggleState>(context);
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

    button = GestureDetector(
      onTap: () {
        ToggleController.setSharedValue<ToggleState>(context, isSelected ? null : selectState);
      },
      child: button,
    );
    return new Padding(padding: const EdgeInsets.all(8.0), child: button);
  }
}

class ExampleAnimatedButton extends StatefulWidget {
  const ExampleAnimatedButton(this.selectState);

  final ToggleState selectState;

  @override
  ExampleAnimatedButtonState createState() {
    return new ExampleAnimatedButtonState();
  }
}

class ExampleAnimatedButtonState extends State<ExampleAnimatedButton> with TickerProviderStateMixin<ExampleAnimatedButton> {
  AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final ToggleState toggleState = ToggleController.getSharedValue<ToggleState>(context);
    final bool isSelected = toggleState == widget.selectState;
    if (isSelected) {
      controller.reverse();
    } else {
      controller.forward();
    }
    final TextStyle textSyle = DefaultTextStyle.of(context).style.copyWith(
          color: Color.lerp(const Color(0xff000000), const Color(0xffffffff), controller.value),
        );
    Widget button = new Container(
      width: 50.0,
      height: 50.0,
      decoration: new ShapeDecoration(
        shape: const StadiumBorder(),
        color: Color.lerp(const Color(0xffffffff), const Color(0xff804040), controller.value),
      ),
      alignment: Alignment.center,
      child: new Text(describeEnum(widget.selectState), style: textSyle),
    );

    button = GestureDetector(
      onTap: () {
        ToggleController.setSharedValue<ToggleState>(context, isSelected ? null : widget.selectState);
      },
      child: button,
    );
    return new Padding(padding: const EdgeInsets.all(8.0), child: button);
  }

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(vsync: this, value: 0.0, duration: const Duration(seconds: 1));
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
  }
}

class ExampleOnlyTwoButton extends StatelessWidget {
  const ExampleOnlyTwoButton(this.selectState);

  final ToggleState selectState;

  @override
  Widget build(BuildContext context) {
    final List<ToggleState> toggleState = ToggleController.getSharedValue<List<ToggleState>>(context).sublist(0);
    final bool isSelected = toggleState.contains(selectState);
    final TextStyle textSyle = DefaultTextStyle.of(context).style.copyWith(
          color: isSelected ? const Color(0xffffffff) : const Color(0xff000000),
        );
    Widget button = new Container(
      width: 50.0,
      height: 50.0,
      decoration: new ShapeDecoration(
        shape: const StadiumBorder(),
        color: isSelected ? const Color(0xff408040) : const Color(0xffff8080),
      ),
      alignment: Alignment.center,
      child: new Text(describeEnum(selectState), style: textSyle),
    );

    button = GestureDetector(
      onTap: () {
        List<ToggleState> newList;
        if (isSelected) {
          newList = toggleState.where((ToggleState state) => state != selectState).toList();
        } else {
          if (toggleState.isNotEmpty) {
            newList = <ToggleState>[toggleState.last, selectState];
          } else {
            newList = <ToggleState>[selectState];
          }
        }
        ToggleController.setSharedValue<List<ToggleState>>(context, newList);
      },
      child: button,
    );
    return new Padding(padding: const EdgeInsets.all(8.0), child: button);
  }
}
