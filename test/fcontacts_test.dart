import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fcontacts/fcontacts.dart';

void main() {
  const MethodChannel channel = MethodChannel('fcontacts');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FContacts.platformVersion, '42');
  });
}
