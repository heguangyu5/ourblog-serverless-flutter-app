import 'package:flutter/material.dart';
import 'package:ourblog/Common.dart';
import 'package:ourblog/Util.dart' as Util;
import 'package:requests/requests.dart';

import 'main.dart';

class IndexWidget extends StatelessWidget
{
  Future getCategories() async
  {
    var r = await Requests.get(BASE_URL + '/index/categories');
    r.raiseForStatus();
    var res = r.json();
    if (res["response"] != "SUCCESS") {
      throw "/index/categories response " + res["response"];
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
          var views = categories.entries.map<PostList>((entry) => PostList(entry.key)).toList();
          tabs.insert(0, Category("0", "Home"));
          views.insert(0, PostList("0"));
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