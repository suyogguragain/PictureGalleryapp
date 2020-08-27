import 'package:flutter/material.dart';
import 'package:flutter_app/threed/pageviewholder.dart';
import 'package:provider/provider.dart';

class threeDimensionView extends StatefulWidget {
  @override
  _threeDimensionViewState createState() => _threeDimensionViewState();
}

class _threeDimensionViewState extends State<threeDimensionView> {
  PageViewHolder holder;

  PageController _controller;
  double fraction = 0.50;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    holder = PageViewHolder(value: 2.0);
    _controller = PageController(initialPage: 2, viewportFraction: fraction);
    _controller.addListener(() {
      holder.setValue(_controller.page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text("Perspective PageView"),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(255, 65, 108, 1.0),
                Color.fromRGBO(255, 75, 73, 1.0)
              ])
          ),
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: ChangeNotifierProvider<PageViewHolder>.value(
                value: holder,
                child: PageView.builder(
                    controller: _controller,
                    itemCount: 12,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return MyPage(number: index.toDouble(), fraction: fraction);
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyPage extends StatelessWidget {
  final double number;
  final double fraction;

  MyPage({this.number, this.fraction});

  @override
  Widget build(BuildContext context) {
    double value = Provider.of<PageViewHolder>(context).value;
    double diff = (number - value);

    //Matrix for Elements
    final Matrix4 pvMatrix = Matrix4.identity()
      ..setEntry(3, 3, 1 / 0.9) // Increasing Scale by 90%
      ..setEntry(1, 1, fraction) // Changing Scale Along Y Axis
      ..setEntry(3, 0, 0.004 * -diff); // Changing Perspective Along X Axis

    //Matrix for Shadow
    final Matrix4 shadowMatrix = Matrix4.identity()
      ..setEntry(3, 3, 1 / 1.6) // Increasing Scale by 60%
      ..setEntry(3, 1, -0.004) //Changing Perspective along Y-Axis
      ..setEntry(3, 0, 0.002 * diff) // Changing Perspective along X Axis
      ..rotateX(1.309); //Rotating Shadow along X Axis

    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: <Widget>[
        if(diff<=1.0 && diff >= -1.0) ... [
          AnimatedOpacity(
            duration: Duration(milliseconds: 100),
            opacity: 1-diff.abs(),
            child: Transform(
              transform: shadowMatrix,
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10.0, spreadRadius: 1.0)
                ]),
              ),
            ),
          ),
        ],
        Transform(
          transform: pvMatrix,
          alignment: FractionalOffset.center,
          child: Container(
            child: Image.asset(
              "assets/images/image_${number.toInt() + 1}.jpg",
              fit: BoxFit.fill,
            ),
          ),
        )
      ],
    );
  }
}
