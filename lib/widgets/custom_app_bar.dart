import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';

class CustomAppBar extends StatelessWidget {
  final title;

  CustomAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SizeConfig.screenHeight * 0.094,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).accentColor,
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.black12, blurRadius: 8),
          BoxShadow(color: Colors.black12, blurRadius: 8),
          BoxShadow(color: Colors.black12, blurRadius: 8),
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: Theme.of(context).appBarTheme.textTheme.title,
        ),
      ),
    );
  }
}
