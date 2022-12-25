import 'package:flutter/material.dart';

import '../constants/color.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage(
      {required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    String image =
    (imageUrl == "no profile" ? "assets/icons/defaultAccountIcon.png" : imageUrl);
    return Scaffold(
      appBar: AppBar(title: Text("Profile Picture",style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: backgroundColor,
      body: Dismissible(
        key: Key('Profile Picture here'),
        direction: DismissDirection.up,
        onDismissed: (_) => Navigator.pop(context),
        child: Center(
            child:  imageUrl == "no profile" ?
            Container(
              width:MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                ),
              ),
            ):Image.network(image,fit: BoxFit.contain)),
        ),
      );
  }
}