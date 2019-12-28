import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/widgets/custom_app_bar.dart';
import 'package:quoty_dumpling_app/widgets/search_bar.dart';

class CollectionScreen extends StatefulWidget {
  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor.withOpacity(.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [.66, 1],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CustomAppBar('Collection'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SearchBar(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
