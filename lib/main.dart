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

class _CustomBoxesPageState extends State<CustomBoxesPage> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
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
                    builder: (context, value, _) => Container(
                      child: GestureDetector(
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
                          foregroundPainter: DrawLine(
                            fillColor: colorDefault.value,
                            selected: list[index].selectedValue,
                            activeColor:
                                list[index].color ?? Colors.transparent,
                          ),
                          painter: FillBox(
                            fillColor: colorDefault.value,
                            selected: list[index].selectedValue,
                            activeColor:
                                list[index].color ?? Colors.transparent,
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

class FillBox extends CustomPainter {
  final Color fillColor, activeColor;
  final bool selected;

  FillBox({
    required this.fillColor,
    required this.selected,
    required this.activeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final halfHeight = size.height / 2, halfWidth = size.width / 2;

    canvas.drawCircle(
      Offset(halfHeight, halfWidth),
      16,
      Paint()
        ..color = activeColor
        ..style = selected ? PaintingStyle.fill : PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DrawLine extends CustomPainter {
  final Color fillColor, activeColor;
  final bool selected;

  DrawLine({
    required this.fillColor,
    required this.selected,
    required this.activeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final halfHeight = size.height / 2;

    final path = Path()
      ..moveTo(halfHeight, 40)
      ..lineTo(27, 32)
      ..moveTo(-halfHeight, 40)
      ..lineTo(-22, 28);

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
