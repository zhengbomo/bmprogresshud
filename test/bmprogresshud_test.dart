import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bmprogresshud/bmprogresshud.dart';

void main() {
  const MethodChannel channel = MethodChannel('bmprogresshud');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Bmprogresshud.platformVersion, '42');
  });
}
