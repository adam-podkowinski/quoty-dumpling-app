import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';

class CustomAppBar extends StatelessWidget {
  final title;
  final Widget prefix;
  final Widget suffix;

  CustomAppBar(this.title, {this.prefix, this.suffix});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SizeConfig.screenHeight * 0.094,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.screenWidth * 0.05,
      ),
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
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Align(
              child: prefix,
              alignment: Alignment.centerLeft,
            ),
          ),
          Center(
            child: FittedBox(
              child: Text(
                title,
                style: Theme.of(context).appBarTheme.textTheme.headline6,
              ),
            ),
          ),
          Expanded(
            child: Align(
              child: suffix,
              alignment: Alignment.centerRight,
            ),
          ),
        ],
      ),
    );
  }
}
