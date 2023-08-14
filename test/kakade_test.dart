import 'package:flutter_test/flutter_test.dart';
import 'package:kakade/kakade.dart';
import 'package:kakade/kakade_platform_interface.dart';
import 'package:kakade/kakade_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockKakadePlatform
    with MockPlatformInterfaceMixin
    implements KakadePlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final KakadePlatform initialPlatform = KakadePlatform.instance;

  test('$MethodChannelKakade is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelKakade>());
  });

  test('getPlatformVersion', () async {
    MockKakadePlatform fakePlatform = MockKakadePlatform();
    KakadePlatform.instance = fakePlatform;

    expect(await Kakade.getPlatformVersion(), '42');
  });
}
