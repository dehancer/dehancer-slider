import 'package:dehancer_slider/dehancer_slider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dehancer Slider Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Dehancer Slider Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _canScroll = true;
  final Map<String, double> _values = {};

  @override
  Widget build(BuildContext context) {
    const defaultControlHeight = 40.0;
    const defaultTextWidth = 50.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: const Color(0xff1E1E1E),
      body: ListView(
        physics: _canScroll
            ? const BouncingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        children: <Widget>[
          const SizedBox(
            height: defaultControlHeight,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, bottom: 20),
            child: Text(
              'Double tap handle resets to default',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Positive range: ${_values['Positive range']}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          _buildSliderWith(
            valueKey: 'Positive range',
            minValue: 0,
            maxValue: 100,
            defaultValue: 0,
            startValue: 0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Negative range: ${_values['Negative range']}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          _buildSliderWith(
            valueKey: 'Negative range',
            minValue: -100,
            maxValue: 0,
            defaultValue: 0,
            startValue: 0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Shifted range: ${_values['Shifted range']}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          _buildSliderWith(
            valueKey: 'Shifted range',
            minValue: -20,
            maxValue: 80,
            defaultValue: 0,
            startValue: 0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'From -3 to +3 Value: ${_values['From -3 to +3 range']}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          _buildSliderWith(
            valueKey: 'From -3 to +3 range',
            minValue: -3,
            maxValue: 3,
            defaultValue: 0,
            startValue: 0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Default: 20, Start: 0, Value: ${_values['Default: 20, Start: 0']}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          _buildSliderWith(
            valueKey: 'Default: 20, Start: 0',
            minValue: -20,
            maxValue: 80,
            defaultValue: 20,
            startValue: 0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Default: 0, Start: 20, Value: ${_values['Default: 0, Start: 20']}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          _buildSliderWith(
            valueKey: 'Default: 0, Start: 20',
            minValue: -20,
            maxValue: 80,
            defaultValue: 0,
            startValue: 20,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'Customization',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: SizedBox(
              height: defaultControlHeight + 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: defaultTextWidth,
                    child: Text(
                      '0%',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: DehancerSlider(
                      minValue: 0,
                      maxValue: 100,
                      defaultValue: 0,
                      startValue: 0,
                      value: _values['custom'] ?? 0,
                      inactiveTrackColor: Colors.red,
                      activeTrackColor: Colors.blue,
                      touchAreaColor: Colors.amber.withOpacity(0.5),
                      trackHandleColor: Colors.green,
                      trackBarTouchAreaSize: 70,
                      trackBarCenterHeight: 10,
                      trackBarHandleHeight: 30,
                      trackBarHeight: 4,
                      onValueChanged: (value) {
                        setState(() {
                          _values['custom'] = value;
                        });
                      },
                      onScrollingChanged: (isScrolling) {
                        setState(() {
                          _canScroll = !isScrolling;
                        });
                      },
                      onValueChangeStarted: (value) {},
                      onDefaultValuePassed: () {},
                      onValueReset: () {},
                      onMinValuePassed: () {},
                      onMaxValuePassed: () {},
                    ),
                  ),
                  const SizedBox(
                    width: defaultTextWidth,
                    child: Text(
                      '100%',
                      textAlign: TextAlign.end,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSliderWith({
    required String valueKey,
    required double minValue,
    required double maxValue,
    required double defaultValue,
    required double startValue,
  }) {
    const defaultControlHeight = 44.0;
    const defaultTextWidth = 50.0;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
      child: SizedBox(
        height: defaultControlHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: defaultTextWidth,
              child: Text(
                '$minValue',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              child: DehancerSlider(
                minValue: minValue,
                maxValue: maxValue,
                defaultValue: defaultValue,
                startValue: startValue,
                value: _values[valueKey] ?? defaultValue,
                onValueChanged: (value) {
                  setState(() {
                    _values[valueKey] = value;
                  });
                },
                onScrollingChanged: (isScrolling) {
                  setState(() {
                    _canScroll = !isScrolling;
                  });
                },
              ),
            ),
            SizedBox(
              width: defaultTextWidth,
              child: Text(
                '$maxValue',
                textAlign: TextAlign.end,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
