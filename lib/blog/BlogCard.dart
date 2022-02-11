import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app_flutter/model/addBlogModels.dart';
import 'package:recipe_app_flutter/NetworkHandler.dart';

class BlogCard extends StatelessWidget {
  const BlogCard(
      {Key? key, required this.addBlogModel, required this.networkHandler})
      : super(key: key);

  final AddBlogModel addBlogModel;
  final NetworkHandler networkHandler;

  @override
  Widget build(BuildContext context) {
    var imagefile;
    return Container(
      height: 200,
      padding: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: networkHandler.getImage(addBlogModel.id),
                  fit: BoxFit.fitWidth),
            ),
          ),
          Positioned(
            bottom: 2,
            child: Container(
              padding: EdgeInsets.all(8),
              height: 55,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Text(
                addBlogModel.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
