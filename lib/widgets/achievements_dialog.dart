import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/icons/custom_icons.dart';
import 'package:quoty_dumpling_app/models/achievement.dart';
import 'package:quoty_dumpling_app/providers/achievements.dart';
import 'package:quoty_dumpling_app/providers/audio_provider.dart';
import 'package:quoty_dumpling_app/widgets/progress_bar.dart';

class AchievementsDialog extends StatefulWidget {
  @override
  _AchievementsDialog createState() => _AchievementsDialog();
}

class ListElement extends StatefulWidget {
  final value;

  ListElement({
    required this.value,
  });

  @override
  _ListElementState createState() => _ListElementState();
}

class _AchievementsDialog extends State<AchievementsDialog> {
  final _spacing = 11.w;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_spacing),
      ),
      elevation: 5,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_spacing),
          color: ThemeColors.background,
        ),
        child: Stack(
          children: [
            Align(
              heightFactor: 1,
              alignment: Alignment.topRight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_spacing),
                clipBehavior: Clip.hardEdge,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  color: ThemeColors.onBackground,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(_spacing),
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
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
                      color: ThemeColors.secondary,
                      indent: 11.sp * 5,
                      endIndent: 11.sp * 5,
                      thickness: 2,
                    ),
                    SizedBox(height: 5.h),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: SizeConfig.screenHeight * .6,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: Provider.of<Achievements>(context)
                            .achievements
                            .length,
                        itemBuilder: (_, i) => ListElement(
                          value: i,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListElementState extends State<ListElement> {
  bool _isInit = true;
  late Achievements achievementsProvider;
  late Achievement achievement;
  String? title;
  String? description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: SizeConfig.screenWidth! * .006,
        left: 10.w,
        right: 10.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(title ?? 'Error'),
                  subtitle: Text(description ?? 'Error'),
                ),
              ),
              FlatButton(
                shape: CircleBorder(),
                onPressed: achievement.isDone && !achievement.isRewardReceived
                    ? () {
                        Provider.of<AudioProvider>(context, listen: false)
                            .playBuyItem();
                        achievementsProvider.receiveReward(
                          achievement.id,
                          context,
                        );
                      }
                    : null,
                color: achievement.isDone && !achievement.isRewardReceived
                    ? ThemeColors.surface
                    : Colors.transparent,
                splashColor:
                    achievement.isRewardReceived ? Colors.transparent : null,
                highlightColor:
                    achievement.isRewardReceived ? Colors.transparent : null,
                height: 35.w,
                child: Icon(
                  achievement.isDone ? Icons.done_outlined : Icons.clear,
                  size: 20.w,
                  color: achievement.isDone
                      ? achievement.isRewardReceived
                          ? ThemeColors.surface
                          : Styles.kSettingsTitleStyle.color
                      : null,
                ),
              ),
            ],
          ),
          ProgressBar(
            currentPercent: achievement.doneVal! / achievement.maxToDoVal!,
          ),
          SizedBox(
            height: 5.h,
          ),
          Row(
            children: <Widget>[
              Text(
                'Reward: ',
              ),
              if (achievement.billsReward != 0)
                Text(
                  achievement.billsReward.toString(),
                ),
              if (achievement.billsReward != 0)
                Icon(
                  Icons.attach_money,
                  size: 15.w,
                  color: ThemeColors.surface,
                ),
              if (achievement.billsReward != 0)
                SizedBox(
                  width: 10.w,
                ),
              if (achievement.diamondsReward != 0)
                Text(
                  achievement.diamondsReward.toString(),
                ),
              if (achievement.diamondsReward != 0)
                SizedBox(
                  width: 2.w,
                ),
              if (achievement.diamondsReward != 0)
                Icon(
                  CustomIcons.diamond,
                  size: 13.w,
                  color: Colors.blue,
                ),
            ],
          ),
          Divider(
            color: ThemeColors.secondary,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      achievementsProvider = Provider.of<Achievements>(context);
      achievement = achievementsProvider.achievements[widget.value];
      title = achievement.title;
      description = achievement.description;
      _isInit = false;
    }
  }
}
