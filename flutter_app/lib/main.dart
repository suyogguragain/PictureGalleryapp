import 'package:flutter/material.dart';
import 'package:flutter_app/drawerpainter.dart';
import 'package:flutter_app/focusedpopup/mainscreen.dart';
import 'package:flutter_app/paint/paintsection.dart';
import 'package:flutter_app/sidebar_button.dart';
import 'package:flutter_app/threed/threedimensionview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Photo Gallery",
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  Offset _offset = Offset(0,0);
  GlobalKey globalKey = GlobalKey();
  List<double> limits = [];

  bool isMenuOpen = false;

  @override
  void initState() {
    limits= [0, 0, 0, 0, 0, 0];
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
    super.initState();
  }

  getPosition(duration){
    RenderBox renderBox = globalKey.currentContext.findRenderObject();
    final position = renderBox.localToGlobal(Offset.zero);
    double start = position.dy - 20;
    double contLimit = position.dy + renderBox.size.height - 20;
    double step = (contLimit-start)/5;
    limits = [];
    for (double x = start; x <= contLimit; x = x + step) {
      limits.add(x);
    }
    setState(() {
      limits = limits;
    });

  }

  double getSize(int x){
    double size  = (_offset.dy > limits[x] && _offset.dy < limits[x + 1]) ? 25 : 20;
    return size;
  }

  Future<String> createAlertDialog(BuildContext context){

    TextEditingController customController = TextEditingController() ;

    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Your Name?"),
        content: TextField(
          controller: customController,
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text("Submit"),
            onPressed: () {

              Navigator.of(context).pop(customController.text.toString());

            } ,
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = mediaQuery.width * 0.65;
    double menuContainerHeight = mediaQuery.height/2;

    return Scaffold(
      key: _scaffoldkey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromRGBO(255, 65, 108, 1.0),
            Color.fromRGBO(255, 75, 73, 1.0)
          ])
        ),
        width: mediaQuery.width,
        child: Stack(
          children: <Widget>[
            Center(
              child: MaterialButton(
                onPressed: (){
                  createAlertDialog(context).then((onvalue) {
                    print('$onvalue');
                    SnackBar mysnackbar = SnackBar(content: Text("Hello $onvalue"));
                    _scaffoldkey.currentState.showSnackBar(mysnackbar);
                  });
                },
                color: Colors.white,
                child: Text(
                  "Hello World",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 1500),
              left: isMenuOpen?0: -sidebarSize+20,
              top: 0,
              curve: Curves.elasticOut,
              child: SizedBox(
                width: sidebarSize,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    if (details.localPosition.dx <= sidebarSize){
                      setState(() {
                        _offset  = details.localPosition;
                      });
                    }

                    if(details.localPosition.dx>sidebarSize-20 && details.delta.distanceSquared>2){
                      setState(() {
                        isMenuOpen = true;
                      });
                    }

                  },
                  onPanEnd: (details) {
                    setState(() {
                      _offset = Offset(0,0);
                    });
                  },
                  child: Stack(
                    children: <Widget>[
                      CustomPaint(
                        size: Size(sidebarSize, mediaQuery.height),
                        painter: DrawerPainter(offset: _offset),
                      ),
                      Container(
                        height: mediaQuery.height,
                        width: sidebarSize,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              height: mediaQuery.height*0.25,
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    Image.asset("assets/dp_default.png",width: sidebarSize/2,),
                                    Text("Suyog Guragain",style: TextStyle(color: Colors.black45),),
                                  ],
                                ),
                              ),
                            ),
                            Divider(thickness: 1,),
                            Container(
                              key: globalKey,
                              width: double.infinity,
                              height: menuContainerHeight,
                              child: Column(
                                children: <Widget>[
                                  MyButton(
                                    text: "Paint",
                                    iconData: Icons.palette,
                                    textSize: getSize(0),
                                    height: (menuContainerHeight)/5,
                                    onpressed: (){
                                      this.setState(() {
                                        isMenuOpen = false;
                                      });
                                      print("Profile");
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => PaintPage()));
                                    },
                                  ),
                                  MyButton(
                                    text: "Albums",
                                    iconData: Icons.album,
                                    textSize: getSize(1),
                                    height: (menuContainerHeight)/5,
                                    onpressed: (){
                                      this.setState(() {
                                        isMenuOpen = false;
                                      });
                                      print("Albums");
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Album()));
                                    },
                                  ),
                                  MyButton(
                                    text: "3D Photos",
                                    iconData: Icons.threed_rotation,
                                    textSize: getSize(2),
                                    height: (mediaQuery.height/2)/5,
                                    onpressed: (){
                                      this.setState(() {
                                        isMenuOpen = false;
                                      });
                                      print("3D");
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => threeDimensionView()));
                                    },
                                  ),
                                  MyButton(
                                    text: "Settings",
                                    iconData: Icons.settings,
                                    textSize: getSize(3),
                                    height: (menuContainerHeight)/5,
                                    onpressed: (){

                                    },
                                  ),
//                                    MyButton(
//                                      text: "My Files",
//                                      iconData: Icons.attach_file,
//                                      textSize: getSize(4),
//                                      height: (menuContainerHeight)/5,),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 400),
                        right: (isMenuOpen)?10:sidebarSize,
                        bottom: 30,
                        child: IconButton(
                          enableFeedback: true,
                          icon: Icon(Icons.keyboard_backspace,color: Colors.black45,size: 30,),
                          onPressed: (){
                            this.setState(() {
                              isMenuOpen = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


