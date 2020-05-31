import 'package:flutter/material.dart';
import 'package:ourblog/Common.dart';

import 'User.dart';

class AdminWidget extends StatelessWidget
{
  final ValueChanged<int> changeBottomSelectedItem;

  AdminWidget(this.changeBottomSelectedItem);

  @override
  Widget build(BuildContext context) {
    if (uid.isEmpty) {
      return Center(
        child: RaisedButton(
          child: Text('请先登录'),
          color: Colors.blueAccent,
          textColor: Colors.white,
          onPressed: () {
            changeBottomSelectedItem(2);
          },
        ),
      );
    }
    return PostListWithCategory(admin: true);
  }
}