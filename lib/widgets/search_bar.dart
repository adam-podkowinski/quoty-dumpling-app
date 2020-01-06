import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          SizeConfig.screenWidth * 0.03,
          SizeConfig.screenWidth * 0.05,
          SizeConfig.screenWidth * 0.03,
          0,
        ),
        child: TextField(
          onChanged: (value) {},
          style: kSearchBarTextStyle(SizeConfig.screenWidth),
          decoration: InputDecoration(
            labelText: "Search",
            hintText: "Author or quote...",
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).backgroundColor,
              size: SizeConfig.screenWidth * 0.07,
            ),
            hintStyle: kSearchBarTextStyle(SizeConfig.screenWidth),
            labelStyle: kSearchBarTextStyle(SizeConfig.screenWidth),
            enabled: true,
            focusedBorder: kSearchBarBorder,
            enabledBorder: kSearchBarBorder,
          ),
        ),
      ),
    );
  }
}
