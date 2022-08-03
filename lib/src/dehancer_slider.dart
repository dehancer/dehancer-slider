import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Dehancer Slider Value handler
typedef DehancerSliderValueHandler = void Function(double value);

/// Dehancer Slider scroll handler
typedef DehancerSliderScrollHandler = void Function(bool isScrolling);

/// Dehancer Slider emptry handler
typedef DehancerSliderEmptyHandler = void Function();

/// {@template dehancer_slider}
/// Dehancer Slider package
/// {@endtemplate}
class DehancerSlider extends StatefulWidget {
  /// {@macro dehancer_slider}
  const DehancerSlider({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.defaultValue,
    required this.startValue,
    required this.value,
    this.onValueChanged,
    this.onScrollingChanged,
    this.onValueChangeStarted,
    this.onDefaultValuePassed,
    this.onValueReset,
    this.onMinValuePassed,
    this.onMaxValuePassed,
    this.trackBarCenterHeight = 4.0,
    this.trackBarHandleHeight = 20.0,
    this.trackBarHeight = 2.0,
    this.trackBarTouchAreaSize = 55.0,
    this.inactiveTrackColor = const Color(0xff323232),
    this.activeTrackColor = const Color(0xff008fc1),
    this.touchAreaColor = Colors.transparent,
    this.trackHandleColor = const Color(0xffa3a3a3),
  });

  /// Max value
  final double maxValue;

  /// Min value
  final double minValue;

  /// Current value
  final double value;

  /// Default value
  final double defaultValue;

  /// Start value
  final double startValue;

  /// Inactive track color
  final Color inactiveTrackColor;

  /// Active track color
  final Color activeTrackColor;

  /// Touch area color (transparent by default)
  final Color touchAreaColor;

  /// Track Handle color
  final Color trackHandleColor;

  /// Track bar center point height
  final double trackBarCenterHeight;

  /// Track bar handle height
  final double trackBarHandleHeight;

  /// Track bar height
  final double trackBarHeight;

  /// Touch area size
  final double trackBarTouchAreaSize;

  /// On value change started handler
  final DehancerSliderValueHandler? onValueChangeStarted;

  /// On value change handler
  final DehancerSliderValueHandler? onValueChanged;

  /// On scrolling changed handler
  final DehancerSliderScrollHandler? onScrollingChanged;

  /// On default value passed handler
  final DehancerSliderEmptyHandler? onDefaultValuePassed;

  /// On value reset handler
  final DehancerSliderEmptyHandler? onValueReset;

  /// On min value passed handler
  final DehancerSliderEmptyHandler? onMinValuePassed;

  /// On max value passed handler
  final DehancerSliderEmptyHandler? onMaxValuePassed;

  @override
  State<DehancerSlider> createState() => _DehancerSliderState();
}

class _DehancerSliderState extends State<DehancerSlider> {
  final _stickyValuePercentage = 3.0; // 3%

  double _trackBarCenterHeight = 0;
  double _trackBarHandlerHeight = 0;
  double _trackBarHeight = 0;
  double _touchSize = 0;

  double _maxWidth = 0;
  double? _currentPosition;
  double _normalMaxValue = 0;
  double _normalMinValue = 0;
  double _normalValue = 0;
  double _normalStartValue = 0;
  double _normalDefaultValue = 0;
  double _lastBorderValue = double.infinity;
  double _lastBorderMinValue = double.infinity;
  double _lastBorderMaxValue = double.infinity;
  double _startOffsetAtPointerDown = 0;
  double _startPositionAtPointerDown = 0;
  double _touchPadding = 0;

  @override
  void initState() {
    super.initState();

    _trackBarCenterHeight = widget.trackBarCenterHeight;
    _trackBarHandlerHeight = widget.trackBarHandleHeight;
    _trackBarHeight = widget.trackBarHeight;
    _touchSize = widget.trackBarTouchAreaSize;
    _touchPadding = (_touchSize - _trackBarHandlerHeight) / 2;
  }

  @override
  void didUpdateWidget(covariant DehancerSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!mounted) {
      return;
    }

    final offset = 0 - widget.minValue;

    _normalMaxValue = widget.maxValue + offset;
    _normalValue = widget.value + offset;
    _normalDefaultValue = widget.defaultValue + offset;
    _normalStartValue = widget.startValue + offset;
    _currentPosition = _positionFromValue(value: _normalValue);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!mounted) {
      return;
    }
    final offset = 0 - widget.minValue;

    _normalMinValue = 0;
    _normalMaxValue = widget.maxValue + offset;
    _normalValue = widget.value + offset;
    _normalDefaultValue = widget.defaultValue + offset;
    _normalStartValue = widget.startValue + offset;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _maxWidth = constraints.maxWidth;

        _currentPosition ??= _positionFromValue(value: _normalValue);
        final startValuePosition = _startPosition;

        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Stack(
            children: [
              Positioned(
                // Normal track
                top: constraints.maxHeight / 2,
                left: 0,
                child: Container(
                  width: _maxWidth,
                  height: _trackBarHeight,
                  color: widget.inactiveTrackColor,
                ),
              ),
              if (_normalValue != _normalStartValue)
                Positioned(
                  // Centered active track
                  top: constraints.maxHeight / 2,
                  left: _normalValue > _normalStartValue
                      ? startValuePosition
                      : _currentPosition!,
                  child: Container(
                    width: (_normalValue > _normalStartValue
                            ? _currentPosition! - startValuePosition
                            : startValuePosition - _currentPosition!)
                        .abs(),
                    height: _trackBarHeight,
                    color: widget.activeTrackColor,
                  ),
                ),
              Positioned(
                // Start point
                top: constraints.maxHeight / 2 -
                    _trackBarCenterHeight / 2 +
                    _trackBarHeight / 2,
                left: startValuePosition,
                child: Container(
                  width: _trackBarCenterHeight,
                  height: _trackBarCenterHeight,
                  decoration: BoxDecoration(
                    color: widget.activeTrackColor,
                    borderRadius: BorderRadius.circular(
                      _trackBarCenterHeight / 2,
                    ),
                  ),
                ),
              ),
              Positioned(
                // Track handle
                top: 0, //constraints.maxHeight / 2 - constraints.minHeight / 2,
                left: _currentPosition! - _touchPadding,
                child: Listener(
                  onPointerDown: (event) {
                    widget.onScrollingChanged?.call(true);

                    _startOffsetAtPointerDown = event.localPosition.dx;
                    _startPositionAtPointerDown = _currentPosition!;

                    _normalValue =
                        _valueFromPosition(position: _currentPosition ?? 0);

                    final value =
                        _realValueFromNormalValue(value: _normalValue);

                    widget.onValueChangeStarted
                        ?.call(_roundedValue(value: value));
                  },
                  onPointerUp: (_) {
                    widget.onScrollingChanged?.call(false);
                  },
                  onPointerCancel: (_) {
                    widget.onScrollingChanged?.call(false);
                  },
                  onPointerMove: (event) {
                    final maxPosition = _toPosition;
                    final minPosition = _fromPosition;
                    final offset =
                        event.localPosition.dx - _startOffsetAtPointerDown;
                    final updatedPosition =
                        _startPositionAtPointerDown + offset;

                    setState(() {
                      final position = max(
                        minPosition,
                        min(
                          maxPosition,
                          updatedPosition,
                        ),
                      );
                      _currentPosition = position;

                      _normalValue = _valueFromPosition(position: position);

                      final value =
                          _realValueFromNormalValue(value: _normalValue);

                      _checkDefaultValueFeedback(value);
                      _checkMaxValueFeedback(value);
                      _checkMinValueFeedback(value);

                      widget.onValueChanged?.call(_roundedValue(value: value));
                    });
                  },
                  child: GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        _normalValue = _normalDefaultValue;

                        final value =
                            _realValueFromNormalValue(value: _normalValue);

                        widget.onValueChanged
                            ?.call(_roundedValue(value: value));
                        widget.onValueReset?.call();

                        HapticFeedback.selectionClick();
                      });
                    },
                    child: Container(
                      color: widget.touchAreaColor,
                      width: _touchSize,
                      height: constraints.maxHeight,
                      child: Center(
                        child: Container(
                          width: _trackBarHandlerHeight,
                          height: _trackBarHandlerHeight,
                          decoration: BoxDecoration(
                            color: widget.trackHandleColor,
                            borderRadius: BorderRadius.circular(
                              _trackBarHandlerHeight / 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _checkDefaultValueFeedback(double value) {
    final offset = _normalMaxValue / 100 * _stickyValuePercentage;

    if (value >= widget.defaultValue - offset &&
        value <= widget.defaultValue + offset) {
      if (_lastBorderValue != widget.defaultValue) {
        HapticFeedback.selectionClick();

        _lastBorderValue = widget.defaultValue;

        widget.onDefaultValuePassed?.call();
      }
    } else {
      _lastBorderValue = value;
    }
  }

  void _checkMaxValueFeedback(double value) {
    final offset = _normalMaxValue / 100 * _stickyValuePercentage;

    if (value >= widget.maxValue - offset &&
        value <= widget.maxValue + offset) {
      if (_lastBorderMaxValue != widget.maxValue) {
        HapticFeedback.selectionClick();

        _lastBorderMaxValue = widget.maxValue;

        widget.onMaxValuePassed?.call();
      }
    } else {
      _lastBorderMaxValue = value;
    }
  }

  void _checkMinValueFeedback(double value) {
    final offset = _normalMaxValue / 100 * _stickyValuePercentage;

    if (value >= widget.minValue - offset &&
        value <= widget.minValue + offset) {
      if (_lastBorderMinValue != widget.minValue) {
        HapticFeedback.selectionClick();

        _lastBorderMinValue = widget.minValue;

        widget.onMinValuePassed?.call();
      }
    } else {
      _lastBorderMinValue = value;
    }
  }

  double get _startPosition {
    if (_normalStartValue == _normalMaxValue) {
      return _maxWidth - _trackBarCenterHeight;
    } else if (_normalStartValue == _normalMinValue) {
      return 0;
    }

    final position = _positionFromValue(value: _normalStartValue);

    return position + _trackBarCenterHeight * 2;
  }

  double get _fromPosition {
    return 0;
  }

  double get _toPosition {
    return _maxWidth - _trackBarHandlerHeight;
  }

  double _positionFromValue({
    required double value,
  }) {
    final offset = value / _normalMaxValue * _toPosition;

    return _fromPosition + offset;
  }

  double _valueFromPosition({
    required double position,
  }) {
    final offset = (position - _fromPosition) / _toPosition * _normalMaxValue;

    return offset;
  }

  double _realValueFromNormalValue({
    required double value,
  }) {
    return value - (0 - widget.minValue);
  }

  double _roundedValue({
    required double value,
  }) {
    final roundedValue = (value * 100).toInt() / 100.0;

    return roundedValue;
  }
}
