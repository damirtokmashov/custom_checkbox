import 'dart:math';
// import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:test_task/model/colored_checkbox.dart';

import 'utils/const.dart';
import 'utils/draw_line.dart';
import 'utils/fill_custom_box.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
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
  late AnimationController _animationController = AnimationController(
    vsync: this,
    duration: Duration(
      milliseconds: 100,
    ),
  );
  late Animation radiusFilled;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );
    radiusFilled = Tween(
      begin: 0.0,
      end: 16.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.1,
          1.0,
          curve: Curves.slowMiddle,
        ),
      )..addListener(() {
          setState(() {
            radiusFilled.value;
          });
        }),
    );
  }

  final colorInitial = ValueNotifier<Color>(Colors.transparent);
  final currentAnimation = ValueNotifier(0.0);
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
                padding: const EdgeInsets.all(0.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 1.0),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ValueListenableBuilder(
                    valueListenable: colorInitial,
                    builder: (context, value, _) => GestureDetector(
                      onTap: () {
                        _animationController.reset();
                        _animationController.forward();
                        list[index].checkValue(list[index].colorValue);
                        colorInitial.value = list[index].color!;
                        list
                            .map(
                              (e) => e.selectedValue =
                                  (e.color == colorInitial.value)
                                      ? true
                                      : false,
                            )
                            .toList();
                      },
                      child: CustomPaint(
                        foregroundPainter: DrawLine(),
                        painter: FillCustomBox(
                          radius: radiusFilled.value,
                          selected: list[index].selectedValue,
                          activeColor: list[index].color ?? Colors.transparent,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(animationDuration),
            Slider(
              onChanged: (changedAnimation) {
                setState(() => currentAnimation.value = changedAnimation);
                _animationController.duration = Duration(
                    milliseconds: 100 + currentAnimation.value.toInt() * 10);
              },
              value: currentAnimation.value,
              min: 0,
              max: 100,
            ),
            Text('${currentAnimation.value.roundToDouble()} ms for animation'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                                (e.color == colorInitial.value) ? true : false,
                          )
                          .toList();
                    });
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  child: Text(addBtn),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      list.clear();
                    });
                  },
                  child: Text(clearBtn),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
