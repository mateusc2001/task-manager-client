import 'package:flutter/material.dart';

class MobileAppBar extends StatelessWidget {
  MobileAppBar({Key? key}) : super(key: key);
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final urlImage = "https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D&w=1000&q=80";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        constraints: BoxConstraints(
          minHeight: 130
        ),
        height: 130.0,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 80.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Column(
                          children: [
                            Text('My Tasks', style: TextStyle(fontSize: 26, color: Colors.white)),
                            Text('4 for today', style: TextStyle(fontSize: 18, color: Colors.white))
                          ],
                        )),
                    getCircle(false)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getCircle(url) {
    if (url) {
      return CircleAvatar(
        radius: 30.0,
        backgroundImage: NetworkImage(url),
        backgroundColor: Colors.transparent,
      );
    } else {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.purple,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text("M", style: TextStyle(fontSize: 20, color: Colors.white),),
        ),
      );
    }
  }
}
