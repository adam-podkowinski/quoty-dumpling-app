import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/widgets/dumpling.dart';
import 'package:quoty_dumpling_app/widgets/progress_bar.dart';

class DumplingFullWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Dumpling(),
        ProgressBar(),
        SizedBox(
          height: SizeConfig.screenHeight * 0.066,
        ),
      ],
    );
  }
}
