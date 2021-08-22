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
  var colorDefault = ValueNotifier<Color>(Colors.transparent);
  var rating = ValueNotifier(0);
  List<ColoredCheckbox> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.red,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 500,
              child: GridView.builder(
                physics: ScrollPhysics(),
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
                        child: Checkbox(
                          fillColor:
                              MaterialStateProperty.all(list[index].color),
                          activeColor: list[index].color,
                          splashRadius: 1,
                          shape: CircleBorder(),
                          value: list[index].selectedValue,
                          onChanged: (bool? value) {
                            setState(() {
                              list[index].checkValue(list[index].colorValue);
                              colorDefault.value = list[index].color!;
                              list
                                  .map((e) => e.selectedValue =
                                      (e.color == colorDefault.value)
                                          ? true
                                          : false)
                                  .toList();
                            });
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Text('Animation Duration'),
            // Slider(
            //   onChanged: (newRating) {
            //     setState(() => rating = newRating);
            //   },
            //   value: rating,
            //   min: 0,
            //   max: 100,
            // ),
            Text('need ms for animation'),
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
