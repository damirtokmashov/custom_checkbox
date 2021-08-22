import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:test_task/model/colored_checkbox.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController _scrollController = ScrollController(); // NEW

  @override // NEW
  void initState() {
    // NEW
    super.initState(); // NEW
    _scrollController = new ScrollController(
      // NEW
      initialScrollOffset: 0.0, // NEW
      keepScrollOffset: true, // NEW
    );
  }

  void _toEnd() {
    // NEW
    _scrollController.animateTo(
      // NEW
      _scrollController.position.maxScrollExtent, // NEW
      duration: const Duration(milliseconds: 500), // NEW
      curve: Curves.ease, // NEW
    ); // NEW
  }

  var colorDefault = ValueNotifier<Color>(Colors.transparent);
  var rating = ValueNotifier(0.0);
  List<ColoredCheckbox> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.red,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
              ),
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return Transform.scale(
                  scale: 1.8,
                  child: ValueListenableBuilder(
                    valueListenable: colorDefault,
                    builder: (context, value, _) => Container(
                      child: CustomPaint(
                        // painter: CirclePainter(),
                        child: AnimatedContainer(
                          duration: Duration(seconds: rating.value.toInt()),
                          child: Checkbox(
                            fillColor:
                                MaterialStateProperty.all(list[index].color),
                            activeColor: list[index].color,
                            splashRadius: 1,
                            shape: CircleBorder(),
                            value: list[index].selectedValue,
                            onChanged: (bool? value) {
                              Timer(Duration(seconds: rating.value.toInt()),
                                  () {
                                setState(
                                  () {
                                    list[index]
                                        .checkValue(list[index].colorValue);
                                    colorDefault.value = list[index].color!;
                                    list
                                        .map((e) => e.selectedValue =
                                            (e.color == colorDefault.value)
                                                ? true
                                                : false)
                                        .toList();
                                  },
                                );
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Text('Animation Duration'),
          Slider(
            onChanged: (newRating) {
              setState(() => rating.value = newRating);
            },
            value: rating.value,
            min: 0,
            max: 100,
          ),
          Text('${rating.value.roundToDouble()} ms for animation'),
          Row(
            children: <Widget>[
              TextButton(
                onPressed: () {
                  setState(() {
                    for (int i = 0; i < 10; i++) {
                      list.add(
                        ColoredCheckbox(
                          EnumColor.values[
                              Random().nextInt(EnumColor.values.length)],
                        ),
                      );
                    }
                    list
                        .map((e) => e.selectedValue =
                            (e.color == colorDefault.value) ? true : false)
                        .toList();
                  });
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                child: Text('Add checkboxes'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    list.clear();
                  });
                },
                child: Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DrawCircle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.red;
    canvas.drawCircle(Offset(0.0, 0.0), 50, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
