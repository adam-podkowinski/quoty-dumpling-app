import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SizeConfig.screenHeight * 0.095,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).accentColor,
          ],
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8),
          BoxShadow(color: Colors.black12, blurRadius: 8),
          BoxShadow(color: Colors.black12, blurRadius: 8),
          BoxShadow(color: Colors.black12, blurRadius: 7),
        ],
      ),
      child: Center(
        child: Text(
          'Dumpling!',
          style: Theme.of(context).textTheme.title,
        ),
      ),
    );
  }
}
