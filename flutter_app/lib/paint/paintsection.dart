import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_app/paint/painter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


class DrawingArea {
  Offset point;
  Paint areaPaint;

  DrawingArea({this.point, this.areaPaint});
}

class PaintPage extends StatefulWidget {
  @override
  _PaintPageState createState() => _PaintPageState();
}

class _PaintPageState extends State<PaintPage> {
  List<DrawingArea> points = [];
  Color selectedColor;
  double strokeWidth;

  @override
  void initState() {
    super.initState();
    selectedColor = Colors.black;
    strokeWidth = 2.0;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    void selectColor() {
      showDialog(
        context: context,
        child: AlertDialog(
          title: const Text('Color Chooser'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                this.setState(() {
                  selectedColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"))
          ],
        ),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: selectedColor,
        mini: true,
        foregroundColor: Colors.black==selectedColor ? Colors.white :Colors.black,
        child: Icon(Icons.arrow_back),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(138, 35, 135, 1.0),
                      Color.fromRGBO(233, 64, 87, 1.0),
                      Color.fromRGBO(242, 113, 33, 1.0),
                    ])),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: width * 0.80,
                    height: height * 0.80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                          )
                        ]),
                    child: GestureDetector(
                      onPanDown: (details) {
                        this.setState(() {
                          points.add(DrawingArea(
                              point: details.localPosition,
                              areaPaint: Paint()
                                ..strokeCap = StrokeCap.round
                                ..isAntiAlias = true
                                ..color = selectedColor
                                ..strokeWidth = strokeWidth));
                        });
                      },
                      onPanUpdate: (details) {
                        this.setState(() {
                          points.add(DrawingArea(
                              point: details.localPosition,
                              areaPaint: Paint()
                                ..strokeCap = StrokeCap.round
                                ..isAntiAlias = true
                                ..color = selectedColor
                                ..strokeWidth = strokeWidth));
                        });
                      },
                      onPanEnd: (details) {
                        this.setState(() {
                          points.add(null);
                        });
                      },
                      child: SizedBox.expand(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          child: CustomPaint(
                            painter: MyCustomPainter(points: points),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: width * 0.80,
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.color_lens,
                            color: selectedColor,
                          ),
                          onPressed: () {
                            selectColor();
                          }),

                      Expanded(
                        child: Slider(
                          min: 1.0,
                          max: 5.0,
                          label: "Stroke $strokeWidth",
                          activeColor: selectedColor,
                          value: strokeWidth,
                          onChanged: (double value) {
                            this.setState(() {
                              strokeWidth = value;
                            });
                          },
                        ),
                      ),

                      IconButton(
                          icon: Icon(
                            Icons.layers_clear,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            this.setState((){
                              points.clear();
                            });
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}


