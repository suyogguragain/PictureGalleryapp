import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

class Album extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(255, 65, 108, 1.0),
                Color.fromRGBO(255, 75, 73, 1.0)
              ])
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back),
                    ),
                    Text(
                      "Photo Albums",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: Center()),
                    IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
                    CircleAvatar(
                      child: Image.asset("assets/images/dp_default.png"),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(border: InputBorder.none, hintText: "Look for your Interest!", fillColor: Colors.grey.shade200, filled: true),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DropdownButton(
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        icon: Icon(Icons.keyboard_arrow_down),
                        underline: Container(
                          color: Colors.white,
                        ),
                        items: ["Featured", "Most Rated", "Recent", "Popular"].map<DropdownMenuItem>((e) => DropdownMenuItem(child: Text(e))).toList(),
                        onChanged: (newItem) {}),
                    IconButton(icon: Icon(Icons.sort), onPressed: () {})
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: GridView(
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      children: [1,2,3,4,5,6,7,8,9,10,11,12].map((e) => FocusedMenuHolder(
                        menuWidth: MediaQuery.of(context).size.width*0.50,
                        blurSize: 5.0,
                        menuItemExtent: 45,
                        menuBoxDecoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        duration: Duration(milliseconds: 100),
                        animateMenuItems: true,
                        blurBackgroundColor: Colors.black54,
                        bottomOffsetHeight: 100,
                        menuItems: <FocusedMenuItem>[
                          FocusedMenuItem(title: Text("Open"),trailingIcon: Icon(Icons.open_in_new) ,onPressed: (){}),
                          FocusedMenuItem(title: Text("Share"),trailingIcon: Icon(Icons.share) ,onPressed: (){}),
                          FocusedMenuItem(title: Text("Favorite"),trailingIcon: Icon(Icons.favorite_border) ,onPressed: (){}),
                          FocusedMenuItem(title: Text("Delete",style: TextStyle(color: Colors.redAccent),),trailingIcon: Icon(Icons.delete,color: Colors.redAccent,) ,onPressed: (){}),
                        ],
                        onPressed: (){},
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Image.asset("assets/images/image_$e.jpg"),
                            ],
                          ),
                        ),
                      )).toList(),
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
