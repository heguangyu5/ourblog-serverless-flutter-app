import 'package:flutter/material.dart';
import 'package:ourblog/Admin.dart';
import 'package:ourblog/Index.dart';
import 'package:ourblog/User.dart';

const BASE_URL = "https://service-k7ptizmv-1302170133.bj.apigw.tencentcs.com/release/ourblog";

void main() {
  runApp(OurBlogApp());
}

class OurBlogApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'OurBlog',
        home: OurBlogHomeWidget()
    );
  }
}

class OurBlogHomeWidget extends StatefulWidget
{
  @override
  _OurBlogHomeWidgetState createState() => _OurBlogHomeWidgetState();
}

class _OurBlogHomeWidgetState extends State<OurBlogHomeWidget>
{
  int _selectedIndex = 0;

  void _onItemTapped(int index)
  {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _selectedIndex == 0 ? IndexWidget() : (_selectedIndex == 1 ? AdminWidget(_onItemTapped) : UserWidget()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('前台')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit),
              title: Text('后台')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text('我')
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Color(0xFF222222),
        selectedItemColor: Colors.white,
        unselectedItemColor: Color(0xFF9d9d9d),
      ),
    );
  }
}