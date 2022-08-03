// ignore_for_file: prefer_const_constructors
import 'package:dehancer_slider/dehancer_slider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DehancerSlider', () {
    test('can be instantiated', () {
      expect(
        DehancerSlider(
          maxValue: 1,
          minValue: -1,
          value: 0,
          startValue: 0,
          defaultValue: 0,
          onScrollingChanged: (value) {},
          onValueChangeStarted: (value) {},
          onValueChanged: (value) {},
        ),
        isNotNull,
      );
    });
  });
}
