import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/providers/collection_settings_provider.dart';
import 'package:quoty_dumpling_app/widgets/rounded_button.dart';

class SettingsIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.settings,
        color: ThemeColors.onSecondary,
      ),
      onPressed: () => showDialog(
        context: context,
        builder: (ctx) => SettingsDialog(),
      ),
    );
  }
}

class SettingsDialog extends StatefulWidget {
  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  final _padding = SizeConfig.screenWidth! * .035;
  late CollectionSettings _collectionSettingsProvider;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _collectionSettingsProvider = Provider.of<CollectionSettings>(context);
      _collectionSettingsProvider.initOptionsDialog();
      FocusScope.of(context).unfocus();
      _isInit = false;
    }
  }

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
          color: ThemeColors.background,
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
                    'Customize Collection',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: Styles.settingsTitleStyle,
                  ),
                ),
                Divider(
                  color: ThemeColors.secondary,
                  thickness: 2,
                  endIndent: SizeConfig.screenWidth! * .05092,
                  indent: SizeConfig.screenWidth! * .05092,
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * .01,
                ),
                Text(
                  'Sort:',
                  textAlign: TextAlign.left,
                  style: Styles.buttonTextStyle,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _collectionSettingsProvider
                      .titlesWithSubtitlesOfOptions.length,
                  itemBuilder: (_, i) => ListElement(
                    value: i,
                  ),
                ),
                Divider(
                  color: ThemeColors.secondary,
                  thickness: .75,
                ),
                CheckboxListTile(
                  activeColor: ThemeColors.secondary,
                  value: _collectionSettingsProvider
                      .selectedOptions['favoritesOnTop'],
                  onChanged: (val) => _collectionSettingsProvider
                      .changeSelectedFavoritesOnTop(val),
                  title: AutoSizeText(
                    'Show Favorites On Top',
                    maxLines: 1,
                    style: Styles.buttonTextStyle,
                  ),
                ),
                Divider(
                  color: ThemeColors.secondary,
                  thickness: .75,
                ),
                Row(
                  children: <Widget>[
                    Spacer(),
                    RoundedButton(
                      text: 'Save',
                      onPressed: () async {
                        await _collectionSettingsProvider.saveOptions(context);
                        Navigator.of(context).pop();
                      },
                      color: ThemeColors.surface,
                      textColor: ThemeColors.background,
                      width: SizeConfig.screenWidth! * .2546,
                    ),
                    Spacer(),
                    RoundedButton(
                      text: 'Cancel',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      width: SizeConfig.screenWidth! * .2546,
                      color: Theme.of(context).errorColor,
                      textColor: ThemeColors.background,
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListElement extends StatefulWidget {
  final value;

  ListElement({
    required this.value,
  });

  @override
  _ListElementState createState() => _ListElementState();
}

class _ListElementState extends State<ListElement> {
  bool _isInit = true;
  late CollectionSettings collectionSettingsProvider;
  late var title;
  late var subtitle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      collectionSettingsProvider = Provider.of<CollectionSettings>(context);
      title = collectionSettingsProvider
          .titlesWithSubtitlesOfOptions[widget.value][0];
      subtitle = collectionSettingsProvider
          .titlesWithSubtitlesOfOptions[widget.value][1];
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.value != 3
          ? EdgeInsets.only(bottom: SizeConfig.screenWidth! * .006)
          : EdgeInsets.all(0),
      child: RadioListTile(
        value: widget.value,
        activeColor: ThemeColors.secondary,
        groupValue:
            collectionSettingsProvider.selectedOptions['sortOption'].index,
        onChanged: (dynamic val) =>
            collectionSettingsProvider.changeSelectedSortOption(val),
        title: Text(
          title,
          style: Styles.commonTextStyle,
        ),
        subtitle: Text(
          subtitle,
        ),
      ),
    );
  }
}
