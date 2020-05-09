# bmprogresshud

[![pub package](https://img.shields.io/pub/v/bmprogresshud.svg)](https://pub.dartlang.org/packages/bmprogresshud)

A lightweight progress HUD for your Flutter app, Inspired by [SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD).

## Showcase

![demo演示](https://github.com/zhengbomo/bmprogresshud/blob/master/images/demo.gif?raw=true)

## Example

place ProgressHud to you container, and get with `ProgressHud.of(context)`

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bmprogresshud/bmprogresshud.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("hud demo"),
        ),
        body: ProgressHud(
          maximumDismissDuration: Duration(seconds: 2),
          child: Center(
            child: Builder(builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      _showLoadingHud(context);
                    },
                    child: Text("show loading"),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
  
  _showLoadingHud(BuildContext context) async {
    ProgressHud.of(context).show(ProgressHudType.loading, "loading...");
    await Future.delayed(const Duration(seconds: 1));
    ProgressHud.of(context).dismiss();
  }
}
```

other ProgressHudType

```dart
// show successHud with text
_showSuccessHud(BuildContext context) {
  ProgressHud.of(context).showAndDismiss(ProgressHudType.success, "load success");
}

// show errorHud with text
_showErrorHud(BuildContext context) {
  ProgressHud.of(context).showAndDismiss(ProgressHudType.error, "load fail");
}

// show progressHud with progress and text
_showProgressHud(BuildContext context) {
  var hud = ProgressHud.of(context);
  hud.show(ProgressHudType.progress, "loading");

  double current = 0;
  Timer.periodic(Duration(milliseconds: 1000.0 ~/ 60), (timer) {
    current += 1;
    var progress = current / 100;
    hud.updateProgress(progress, "loading $current%");
    if (progress == 1) {
      // finished
      hud.showAndDismiss(ProgressHudType.success, "load success");
      timer.cancel();
    }
  });
}
```

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.io/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
