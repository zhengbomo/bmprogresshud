import 'dart:async';

import 'package:bmprogresshud/bmprogresshud.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProgressHud(
      isGlobalHud: true,
      child: MaterialApp(home: HomePage()),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ProgressHudState> _hudKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hud demo"),
      ),
      body: ProgressHud(
        key: _hudKey,
        maximumDismissDuration: Duration(seconds: 2),
        child: Center(
          child: Builder(builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _showLoadingHud(context);
                  },
                  child: Text("show loading"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showToast(context);
                  },
                  child: Text("show toast"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showSuccessHud(context);
                  },
                  child: Text("show success"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showErrorHud(context);
                  },
                  child: Text("show error"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showProgressHud(context);
                  },
                  child: Text("show progress"),
                ),
                Divider(height: 50),
                ElevatedButton(
                  onPressed: () async {
                    ProgressHud.showLoading();
                    await Future.delayed(const Duration(seconds: 1));
                    ProgressHud.dismiss();
                  },
                  child: Text("show global loading"),
                ),
                ElevatedButton(
                  onPressed: () {
                    ProgressHud.showAndDismiss(
                        ProgressHudType.success, "load success");
                  },
                  child: Text("show global success"),
                ),
                ElevatedButton(
                  onPressed: () {
                    ProgressHud.showAndDismiss(
                        ProgressHudType.error, "load fail");
                  },
                  child: Text("show global error"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showProgressHudGlobal();
                  },
                  child: Text("show global progress"),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  _showLoadingHud(BuildContext context) async {
    ProgressHud.of(context)?.show(ProgressHudType.loading, "loading...");
    await Future.delayed(const Duration(seconds: 1));
    _hudKey.currentState?.dismiss();
  }

  _showToast(BuildContext context) async {
    ProgressHud.of(context)?.showToast(text: "${DateTime.now()}");
  }

  _showSuccessHud(BuildContext context) {
    ProgressHud.of(context)
        ?.showAndDismiss(ProgressHudType.success, "load success");
  }

  _showErrorHud(BuildContext context) {
    ProgressHud.of(context)?.showAndDismiss(ProgressHudType.error, "load fail");
  }

  _showProgressHud(BuildContext context) {
    var hud = ProgressHud.of(context);
    hud?.show(ProgressHudType.progress, "loading");

    double current = 0;
    Timer.periodic(Duration(milliseconds: 1000.0 ~/ 60), (timer) {
      current += 1;
      var progress = current / 100;
      hud?.updateProgress(progress, "loading $current%");
      if (progress == 1) {
        hud?.showAndDismiss(ProgressHudType.success, "load success");
        timer.cancel();
      }
    });
  }

  _showProgressHudGlobal() {
    ProgressHud.show(ProgressHudType.progress, "loading");

    double current = 0;
    Timer.periodic(Duration(milliseconds: 1000.0 ~/ 60), (timer) {
      current += 1;
      var progress = current / 100;
      ProgressHud.updateProgress(progress, "loading $current%");
      if (progress == 1) {
        ProgressHud.showAndDismiss(ProgressHudType.success, "load success");
        timer.cancel();
      }
    });
  }
}
