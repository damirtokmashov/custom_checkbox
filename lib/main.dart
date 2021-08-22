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
    super.initState();
    _scrollController = new ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );
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
      body: SafeArea(
        child: Column(
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
                  return ValueListenableBuilder(
                    valueListenable: colorDefault,
                    builder: (context, value, _) => Container(
                      // width: 20,
                      // height: 20,
                      // padding:
                      //     EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: GestureDetector(
                        onTap: () {
                          list[index].checkValue(list[index].colorValue);
                          colorDefault.value = list[index].color!;
                          list
                              .map((e) => e.selectedValue =
                                  (e.color == colorDefault.value)
                                      ? true
                                      : false)
                              .toList();
                        },
                        child: CustomPaint(
                          painter: DrawCircle(colorDefault.value,
                              list[index].selectedValue, list[index].color!),
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
      ),
    );
  }
}

class DrawCircle extends CustomPainter {
  Color fillColor, activeColor;
  bool selected;
  DrawCircle(this.fillColor, this.selected, this.activeColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = selected ? fillColor : Colors.transparent;

    canvas.drawCircle(Offset(0.0, 0.0), 15, paint);
    final path = Path()
      ..moveTo(-4, -2)
      ..lineTo(0, 3)
      ..moveTo(-2, 3)
      ..lineTo(6.5, -4);

    canvas.drawCircle(
        Offset(0, 0),
        15,
        Paint()
          ..color = activeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5);

    canvas.drawPath(
        path,
        Paint()
          ..isAntiAlias = true
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
