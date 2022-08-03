<!-- Copyright 2022 Dehancer author. All rights reserved.
Use of this source code is governed by an Apache license
that can be found in the LICENSE file. -->

# dehancer_slider

[![pub package](https://img.shields.io/pub/v/dehancer_slider?label=stable)][pub package]
[![GitHub](https://img.shields.io/github/license/dehancer/dehancer-slider)][repo]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Dehancer Slider package - a Flutter package that provides configurable and easy to use slider UI value picker.

![Demo](https://github.com/dehancer/dehancer-slider/blob/master/rosources/DehancerSlider.mp4?raw=true)

## Prepare for use

### Add the plugin reference to pubspec.yaml

Two ways to add the plugin to your pubspec:
- **(Recommend)** Run `flutter pub add dehancer_slider`. 
- Add the package reference in your `pubspec.yaml`'s `dependencies` section:
```yaml
dependencies:
  dehancer_slider: $latest_version
```

The latest stable version is:
[![pub package](https://img.shields.io/pub/v/dehancer_slider.svg)][pub package]

### Import in your projects

```dart
import 'package:dehancer_slider/dehancer_slider.dart';
```

## Usage

### Slider with values from 0 to 100

```dart
DehancerSlider(
	minValue: 0,
	maxValue: 100,
	defaultValue: 0,
	startValue: 0,
	value: 0,
)
```

### Slider with values from -3 to 3

```dart
DehancerSlider(
	minValue: -3,
	maxValue: 3,
	defaultValue: 0,
	startValue: 0,
	value: 0,
)
```

### Slider with values from 0 to 100 and default value 20

Default value is a value that will be used on reset (on double tap)

```dart
DehancerSlider(
	minValue: 0,
	maxValue: 100,
	defaultValue: 20,
	startValue: 0,
	value: 0,
)
```

### Slider with values from 0 to 100 and start value 20

Default value is a value that will displayed as a marker on track

```dart
DehancerSlider(
	minValue: 0,
	maxValue: 100,
	defaultValue: 0,
	startValue: 20,
	value: 0,
	onValueChanged: (value) {
	},
)
```

### Slider with values from 0 to 100 and value change handlers

```dart
DehancerSlider(
	minValue: 0,
	maxValue: 100,
	defaultValue: 0,
	startValue: 0,
	value: 0,
	onValueChangeStarted: (value) {
	},
	onValueChanged: (value) {
	},
)
```

### Slider with values from 0 to 100 and scroll change handler

This handler might be used to block vertical scrolling while user changes slider value. 
Check example for more information.

```dart
DehancerSlider(
	minValue: 0,
	maxValue: 100,
	defaultValue: 0,
	startValue: 0,
	value: 0,
	onScrollingChanged: (isChanging) {
	},
)
```


[pub package]: https://pub.dev/packages/dehancer_slider
[repo]: https://github.com/dehancer/dehancer-slider
[GitHub issues]: https://github.com/dehancer/dehancer-slider/issues

[license_badge]: https://img.shields.io/badge/license-Apache-blue.svg
[license_link]: https://opensource.org/licenses/Apache-2.0
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
