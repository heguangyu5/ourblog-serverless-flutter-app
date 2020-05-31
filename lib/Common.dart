import 'package:flutter/material.dart';
import 'package:requests/requests.dart';

import 'User.dart';
import 'Util.dart' as Util;
import 'main.dart';

class PostListWithCategory extends StatelessWidget
{
  final bool admin;

  PostListWithCategory({bool admin = false}) : admin = admin;

  Future getCategories() async
  {
    var r = await Requests.get(BASE_URL + '/index/categories');
    r.raiseForStatus();
    var res = r.json();
    if (res["response"] != "SUCCESS") {
      throw res["response"];
    }
    return res["data"];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCategories(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var categories = snapshot.data;
          var tabs  = categories.entries.map<Category>((entry) => Category(entry.key, entry.value)).toList();
          var views = categories.entries.map<PostList>((entry) => PostList(entry.key, this.admin)).toList();
          tabs.insert(0, Category("0", "Home"));
          views.insert(0, PostList("0", this.admin));
          return DefaultTabController(
            length: categories.length + 1,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Search Input Placeholder'),
                bottom: TabBar(
                  tabs: tabs,
                  isScrollable: true,
                ),
              ),
              body: TabBarView(
                children: views
              ),
            ),
          );
        }
        return snapshot.hasError ? Util.ErrorWidget(snapshot.error.toString())
                                 : Util.ProcessingWidget('loading...');
      },
    );
  }
}

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
  final bool admin;

  Post(this.id, this.title, this.admin);

  @override
  Widget build(BuildContext context) {
    Widget trailingWidget;
    if (this.admin) {
      trailingWidget = PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'edit',
            child: FlatButton.icon(
              onPressed: () {},
              icon: Icon(Icons.edit),
              label: Text('Edit'),
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: FlatButton.icon(
              onPressed: () {},
              icon: Icon(Icons.clear),
              label: Text('Delete'),
            ),
          )
        ],
      );
    } else {
      trailingWidget = Icon(Icons.arrow_right);
    }
    return ListTile(
      title: Text(title),
      trailing: trailingWidget,
    );
  }
}

class PostList extends StatefulWidget
{
  final String category;
  final bool admin;

  PostList(this.category, this.admin);

  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList>
{
  bool loading = false;
  int page = 1;
  List<dynamic> posts = [];

  Future getPosts() async
  {
    String url = BASE_URL;
    if (widget.admin) {
      url += '/admin?uid=$uid&ost=$ost&';
    } else {
      url += '?';
    }
    url += 'category=' + widget.category + '&page=' + page.toString();
    var r = await Requests.get(url);
    r.raiseForStatus();
    var res = r.json();
    if (res["response"] != "SUCCESS") {
      throw res["response"];
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
                return Post(posts[index]['id'], posts[index]['title'], widget.admin);
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