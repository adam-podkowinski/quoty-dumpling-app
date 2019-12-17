import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/models/size_config.dart';
import 'package:quoty_dumpling_app/widgets/dumpling.dart';
import 'package:quoty_dumpling_app/widgets/dumpling_screen_app_bar.dart';
import 'package:quoty_dumpling_app/widgets/progress_bar.dart';

class DumplingScreen extends StatelessWidget {
  static const routeId = 'dumpling-screen';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Quoty Dumpling!',
      //     style: Theme.of(context).textTheme.title,
      //   ),
      // ),
      body: Container(
        decoration: BoxDecoration(
          // color: Theme.of(context).primaryColor,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).accentColor.withOpacity(.7),
              Theme.of(context).primaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
