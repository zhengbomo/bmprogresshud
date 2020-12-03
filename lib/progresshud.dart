import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'circle_progressbar.dart';

enum ProgressHudType {
  /// show loading with CupertinoActivityIndicator and text
  loading,

  /// show Icons.check and Text
  success,

  /// show Icons.close and Text
  error,

  /// show circle progress view and text
  progress
}

/// show progresshud like ios app
class ProgressHud extends StatefulWidget {
  /// the offsetY of hudview postion from center, default is -50
  final double offsetY;
  final Widget child;
  // max duration for auto dismiss hud
  final Duration? maximumDismissDuration;

  static ProgressHudState of(BuildContext context) {
    return context.findAncestorStateOfType<ProgressHudState>()!;
  }

  ProgressHud({
    Key? key,
    required this.child,
    this.offsetY = -50,
    this.maximumDismissDuration
  }) : super(key: key);

  @override
  ProgressHudState createState() => ProgressHudState();
}

class ProgressHudState extends State<ProgressHud> {
  var _isVisible = false;
  String _text = "";
  double _opacity = 0.0;
  var _progressType = ProgressHudType.loading;
  var _progressValue = 0.0;

  /// dismiss hud
  void dismiss() {
    setState(() {
      _opacity = 0;
    });
  }

  /// show hud with type and text
  void show(ProgressHudType type, String text) {
    _text = text;
    _isVisible = true;
    _progressType = type;
    setState(() {
      _opacity = 1;
    });
  }

  /// show loading with text
  void showLoading({String text = "loading"}) {
    this.show(ProgressHudType.loading, text);
  }

  /// show success icon with text and dismiss automatic
  Future showSuccessAndDismiss({required String text}) async {
    await this.showAndDismiss(ProgressHudType.success, text);
  }

  /// show error icon with text and dismiss automatic
  Future showErrorAndDismiss({required String text}) async {
    await this.showAndDismiss(ProgressHudType.error, text);
  }

  /// update progress value and text when ProgressHudType = progress
  ///
  /// should call `show(ProgressHudType.progress, "Loading")` before use
  void updateProgress(double progress, String text) {
    setState(() {
      _progressValue = progress;
      _text = text;
    });
  }

  /// show hud and dismiss automatically
  Future showAndDismiss(ProgressHudType type, String text) async {
    show(type, text);
    var millisecond = max(500 + text.length * 200, 1000);
    var duration = Duration(milliseconds: millisecond);
    if (widget.maximumDismissDuration != null &&
        widget.maximumDismissDuration!.inMilliseconds <
            duration.inMilliseconds) {
      duration = widget.maximumDismissDuration!;
    }
    await Future.delayed(duration);
    dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        Offstage(
          offstage: !_isVisible,
          child: AnimatedOpacity(
            onEnd: () {
              if (_opacity == 0 && _isVisible) {
                // hide
                setState(() {
                  _isVisible = false;
                });
              }
            },
            opacity: _opacity,
            duration: Duration(milliseconds: 250),
            child: _createHud(),
          ),
        )
      ],
    );
  }

  Widget _createHud() {
    const double kIconSize = 50;
    switch (_progressType) {
      case ProgressHudType.loading:
        var sizeBox = SizedBox(
          width: kIconSize,
          height: kIconSize,
          child: CupertinoTheme(
              data: CupertinoTheme.of(context)
                  .copyWith(brightness: Brightness.dark),
              child: CupertinoActivityIndicator(animating: true, radius: 15)),
        );
        return _createHudView(sizeBox);
      case ProgressHudType.error:
        return _createHudView(
            Icon(Icons.close, color: Colors.white, size: kIconSize));
      case ProgressHudType.success:
        return _createHudView(
            Icon(Icons.check, color: Colors.white, size: kIconSize));
      case ProgressHudType.progress:
        var progressWidget = CustomPaint(
          painter: CircleProgressBarPainter(progress: _progressValue),
          size: Size(kIconSize, kIconSize),
        );
        return _createHudView(progressWidget);
      default:
        throw Exception("not implementation");
    }
  }

  Widget _createHudView(Widget child) {
    return Stack(
      children: <Widget>[
        // do not response touch event
        IgnorePointer(
          ignoring: false,
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10 - widget.offsetY * 2),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 33, 33, 33),
                borderRadius: BorderRadius.circular(5)),
            constraints: BoxConstraints(minHeight: 130, minWidth: 130),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(15),
                    child: child,
                  ),
                  Container(
                    child: Text(_text,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
