import 'package:recipe_app_flutter/customWidget/BlogCard.dart';
import 'package:recipe_app_flutter/model/SuperModel.dart';
import 'package:recipe_app_flutter/model/addBlogModels.dart';
import 'package:recipe_app_flutter/NetworkHandler.dart';
import 'package:flutter/material.dart';

class Blogs extends StatefulWidget {
  Blogs({Key key, this.url}) : super(key: key);
  final String url;

  @override
  _BlogsState createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  NetworkHandler networkHandler = NetworkHandler();
  SuperModel superModel = SuperModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void fetchData() async {
    var response = await networkHandler.get(widget.url);
    superModel = SuperModel.fromJson(response);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => BlogCard(),
      itemCount: superModel.data.length,
    );
  }
}