import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:requests/requests.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Common.dart';
import 'Util.dart' as Util;
import 'main.dart';

class IndexWidget extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return PostListWithCategory();
  }
}

class PostWidget extends StatelessWidget
{
  final String id;
  final String title;

  PostWidget(this.id, this.title);

  Future getPost() async
  {
    var r = await Requests.get(BASE_URL + '/index/post?id=$id');
    r.raiseForStatus();
    var res = r.json();
    if (res["response"] != "SUCCESS") {
      throw res["response"];
    }
    return res["data"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(this.title),
      ),
      body: FutureBuilder(
        future: getPost(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var post = snapshot.data;
            var content = '# ' + this.title + "\n\n\n";
            if (post["external_post"] == "0") {
              content += post["content"];
            } else {
              content += '[External Post](' + post['content']  + ')';
            }
            return Markdown(
              data: content,
              onTapLink: (url) async {
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Could not lanch $url'),
                    backgroundColor: Colors.red,
                  ));
                }
              },
            );
          }
          return Util.ProcessingWidget('loading...');
        },
      )
    );
  }
}