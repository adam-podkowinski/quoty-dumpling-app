import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/providers/achievements.dart';

class AchievementsDialog extends StatefulWidget {
  @override
  _AchievementsDialog createState() => _AchievementsDialog();
}

class _AchievementsDialog extends State<AchievementsDialog> {
  final _padding = 11.h;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_padding),
      ),
      elevation: 5,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_padding),
          color: Theme.of(context).backgroundColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(_padding),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    'Achievements',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: Styles.kSettingsTitleStyle,
                  ),
                ),
                Divider(
                  color: Theme
                      .of(context)
                      .accentColor,
                  indent: 11.sp * 5,
                  endIndent: 11.sp * 5,
                  thickness: 2,
                ),
                ListView.builder(
                  itemCount:
                  Provider
                      .of<Achievements>(context)
                      .achievements
                      .length,
                  itemBuilder: (_, i) =>
                      ListTile(
                        title: Text("Title"),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
