import 'package:flutter/material.dart';
import 'package:requests/requests.dart';

import 'Util.dart' as Util;
import 'main.dart';

class Category extends StatelessWidget
{
  final String id;
  final String name;

  Category(this.id, this.name);

  @override
  Widget build(BuildContext context) {
    return Text(this.name);
  }
}

class Post extends StatelessWidget
{
  final String id;
  final String title;

  Post(this.id, this.title);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_right),
    );
  }
}

class PostList extends StatefulWidget
{
  final String category;

  PostList(this.category);

  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList>
{
  bool loading = false;
  int page = 1;
  List<dynamic> posts = [];

  Future getPosts() async
  {
    var r = await Requests.get(BASE_URL + '?category=' + widget.category + '&page=' + page.toString());
    print(BASE_URL + '?category=' + widget.category + '&page=' + page.toString());
    r.raiseForStatus();
    var res = r.json();
    if (res["response"] != "SUCCESS") {
      throw "/index/categories response " + res["response"];
    }
    posts.addAll(res["data"]);
    if (res["data"].length == 0 && page > 1) {
      page--;
    }
    loading = false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        if (loading) {
          return true;
        }
        if (notification.toString().contains("trailing")) {
          setState(() {
            loading = true;
            page++;
          });
        } else {
          setState(() {
            loading = true;
            page = 1;
            posts.clear();
          });
        }
        return true;
      },
      child: FutureBuilder(
        future: getPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Post(posts[index]['id'], posts[index]['title']);
              },
            );
          }

          return snapshot.hasError ? Util.ErrorWidget(snapshot.error.toString())
            : Util.ProcessingWidget('loading...');
        },
      )
    );
  }
}