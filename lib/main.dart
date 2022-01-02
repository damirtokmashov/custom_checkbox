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
      theme: ThemeData.dark(),
      home: CustomBoxesPage(),
    );
  }
}

class CustomBoxesPage extends StatefulWidget {
  CustomBoxesPage({Key? key}) : super(key: key);

  @override
  _CustomBoxesPageState createState() => _CustomBoxesPageState();
}

class _CustomBoxesPageState extends State<CustomBoxesPage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  late AnimationController _controller;
  late Animation colorAnimation;
  late Color animatedColor;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    colorAnimation =
        ColorTween(begin: Colors.transparent, end: Colors.blue).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0),
      )..addListener(() {
          setState(() {
            animatedColor = colorAnimation.value;
          });
        }),
    );
  }

  final colorDefault = ValueNotifier<Color>(Colors.transparent);
  final rating = ValueNotifier(0.0);
  final list = <ColoredCheckbox>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom CheckBox'),
        backgroundColor: Colors.pinkAccent[100],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                ),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ValueListenableBuilder(
                    valueListenable: colorDefault,
                    builder: (context, value, _) => GestureDetector(
                      onTap: () {
                        list[index].checkValue(list[index].colorValue);
                        colorDefault.value = list[index].color!;
                        list
                            .map(
                              (e) => e.selectedValue =
                                  (e.color == colorDefault.value)
                                      ? true
                                      : false,
                            )
                            .toList();
                      },
                      child: CustomPaint(
                        foregroundPainter: DrawLine(),
                        painter: FillCustomBox(
                          selected: list[index].selectedValue,
                          activeColor: list[index].color ?? Colors.transparent,
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
                    _controller.forward();
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
                          .map(
                            (e) => e.selectedValue =
                                (e.color == colorDefault.value) ? true : false,
                          )
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

class FillCustomBox extends CustomPainter {
  final Color activeColor;
  final bool selected;

  FillCustomBox({
    required this.selected,
    required this.activeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final offsetCenter = Offset(
      size.width / 2,
      size.height / 2,
    );

    canvas.drawCircle(
      offsetCenter,
      offsetCenter.dx / 2,
      Paint()
        ..color = activeColor
        ..style = selected ? PaintingStyle.fill : PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DrawLine extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final offsetCenter = Offset(
      size.width / 2,
      size.height / 2,
    );

    final path = Path()
      ..moveTo(offsetCenter.dx - 1, offsetCenter.dy + 6)
      ..lineTo(offsetCenter.dx - 7, offsetCenter.dy - 2)
      ..moveTo(-offsetCenter.dx - 1, offsetCenter.dy + 6)
      ..lineTo(-offsetCenter.dx + 8, offsetCenter.dy - 5);

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
