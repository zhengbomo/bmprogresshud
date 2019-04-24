# bmprogresshud

A lightweight progress HUD for your Flutter app

## Example

place ProgressHud to you container

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
                  RaisedButton(
                    onPressed: () {
                      _showSuccessHud(context);
                    },
                    child: Text("show success"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      _showErrorHud(context);
                    },
                    child: Text("show error"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      _showProgressHud(context);
                    },
                    child: Text("show progress"),
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

  _showSuccessHud(BuildContext context) {
    ProgressHud.of(context).showAndDismiss(ProgressHudType.success, "load success");
  }

  _showErrorHud(BuildContext context) {
    ProgressHud.of(context).showAndDismiss(ProgressHudType.error, "load fail");
  } 

  _showProgressHud(BuildContext context) {
    var hud = ProgressHud.of(context);
    hud.show(ProgressHudType.progress, "loading");

    double current = 0;
    Timer.periodic(Duration(milliseconds: 1000.0 ~/ 60), (timer) {
      current += 1;
      var progress = current / 100;
      hud.updateProgress(progress, "loading $current%");
      if (progress == 1) {
        hud.showAndDismiss(ProgressHudType.success, "load success");
        timer.cancel();
      }
    });
  }
}
```

## Showcase

![]()

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.io/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
