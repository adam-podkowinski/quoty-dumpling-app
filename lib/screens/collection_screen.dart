import 'package:flutter/material.dart';

class CollectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quoty Dumpling!',
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).backgroundColor.withOpacity(.8),
              Theme.of(context).primaryColor.withOpacity(.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Dumpling(),
              // ProgressBar(),
            ],
          ),
        ),
      ),
    );
  }
}
