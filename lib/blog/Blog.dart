import 'package:recipe_app_flutter/customWidget/BlogCard.dart';
import 'package:recipe_app_flutter/model/SuperModel.dart';
import 'package:recipe_app_flutter/model/addBlogModels.dart';
import 'package:recipe_app_flutter/NetworkHandler.dart';
import 'package:flutter/material.dart';

class Blogs extends StatefulWidget {
  late final String url;

  @override
  _BlogsState createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  NetworkHandler networkHandler = NetworkHandler();
  SuperModel superModel = SuperModel(data: []);
     List<AddBlogModel> data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler.get(widget.url);
    superModel = SuperModel.fromJson(response);
        setState(() {
      data = superModel.data;
    });
  }

  @override
  Widget build(BuildContext context) {
     return Column(
      children: data
          .map((item) => BlogCard(
                addBlogModel: item,
                networkHandler: networkHandler,
              ))
          .toList(),
    );
  }
}