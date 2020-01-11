import 'package:flutter/material.dart';

class SettingsIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.settings,
        color: Theme.of(context).appBarTheme.textTheme.title.color,
      ),
      onPressed: () {},
    );
  }
}
