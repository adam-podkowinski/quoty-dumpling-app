import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/providers/collection_settings_provider.dart';

class SettingsIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.settings,
        color: Theme.of(context).appBarTheme.textTheme.title.color,
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
  final _padding = SizeConfig.screenWidth * .035;
  var _collectionSettingsProvider;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _collectionSettingsProvider = Provider.of<CollectionSettings>(context);
      _collectionSettingsProvider.initOptions();
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
      backgroundColor: Theme.of(context).backgroundColor,
      child: Padding(
        padding: EdgeInsets.all(_padding),
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
                style: kAuthorStyle(SizeConfig.screenWidth).copyWith(
                  fontSize: SizeConfig.screenWidth * 0.065,
                ),
              ),
            ),
            Divider(
              color: Theme.of(context).accentColor,
              thickness: 2,
              endIndent: SizeConfig.screenWidth * .05092,
              indent: SizeConfig.screenWidth * .05092,
            ),
            SizedBox(
              height: SizeConfig.screenHeight * .01,
            ),
            Text(
              'Sort:',
              textAlign: TextAlign.left,
              style: kButtonTextStyle(SizeConfig.screenWidth),
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
              color: Theme.of(context).accentColor,
              thickness: .75,
            ),
            CheckboxListTile(
              activeColor: Theme.of(context).accentColor,
              value: _collectionSettingsProvider.showOnlyFavorite,
              onChanged: (val) =>
                  _collectionSettingsProvider.changeShowOnlyFavorite(val),
              title: Text(
                'Show Only Favorite',
                style: kButtonTextStyle(SizeConfig.screenWidth),
              ),
            ),
            Divider(
              color: Theme.of(context).accentColor,
              thickness: .75,
            ),
            Row(
              children: <Widget>[
                Spacer(),
                SettingsButton(
                  text: 'Save',
                  onPressed: () {
                    _collectionSettingsProvider.saveOptions(context);
                    Navigator.of(context).pop();
                  },
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                Spacer(),
                SettingsButton(
                  text: 'Cancel',
                  onPressed: () {
                    _collectionSettingsProvider.cancelOptions();
                    Navigator.of(context).pop();
                  },
                  color: Theme.of(context).errorColor,
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color color;

  SettingsButton({
    this.onPressed,
    this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.screenWidth * .05092),
      ),
      color: color,
      textColor: Theme.of(context).backgroundColor,
      child: SizedBox(
        width: SizeConfig.screenWidth * .2546,
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }
}

class ListElement extends StatefulWidget {
  final value;

  ListElement({
    @required this.value,
  });

  @override
  _ListElementState createState() => _ListElementState();
}

class _ListElementState extends State<ListElement> {
  bool _isInit = true;
  CollectionSettings collectionSettingsProvider;
  var title;
  var subtitle;

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
          ? EdgeInsets.only(bottom: SizeConfig.screenWidth * .006)
          : EdgeInsets.all(0),
      child: RadioListTile(
        value: widget.value,
        activeColor: Theme.of(context).accentColor,
        groupValue: collectionSettingsProvider.selectedOption.index,
        onChanged: (val) => collectionSettingsProvider.changeSelectedVal(val),
        title: Text(
          title,
          style: kCommonTextStyle(SizeConfig.screenWidth),
        ),
        subtitle: Text(
          subtitle,
        ),
      ),
    );
  }
}
