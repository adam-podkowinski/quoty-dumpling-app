import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/models/size_config.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      elevation: 5,
      child: Container(
        width: double.infinity,
        height: SizeConfig.screenHeight * 0.1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor,
            ],
          ),
        ),
        child: Center(
          child: Text(
            'Open Your Dumpling!',
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    );
  }
}
