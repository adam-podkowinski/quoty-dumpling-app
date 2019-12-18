import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/widgets/dumpling.dart';
import 'package:quoty_dumpling_app/widgets/dumpling_screen_app_bar.dart';
import 'package:quoty_dumpling_app/widgets/progress_bar.dart';

class DumplingScreen extends StatelessWidget {
  static const routeId = 'dumpling-screen';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor.withOpacity(.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              CustomAppBar(),
              SizedBox(
                height: SizeConfig.screenHeight * 0.09,
              ),
              Dumpling(),
              ProgressBar(),
            ],
          ),
        ),
      ),
    );
  }
}
