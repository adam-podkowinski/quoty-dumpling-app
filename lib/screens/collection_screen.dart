import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/widgets/custom_app_bar.dart';

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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CustomAppBar(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Text(
                  'blank',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
