import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

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
          onChanged: (value) {
            setState(() {});
          },
          style: kSearchBarTextStyle(SizeConfig.screenWidth),
          controller: _controller,
          decoration: InputDecoration(
            labelText: "Search",
            hintText: "Author or quote...",
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).backgroundColor,
              size: SizeConfig.screenWidth * 0.07,
            ),
            suffixIcon: AnimatedOpacity(
              duration: Duration(milliseconds: 250),
              opacity: _controller.text != '' ? 1 : 0,
              child: _controller.text != ''
                  ? InkWell(
                      child: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
                      onTap: () => setState(
                        () => _controller.clear(),
                      ),
                    )
                  : null,
            ),
            hintStyle: kSearchBarTextStyle(SizeConfig.screenWidth),
            labelStyle: kSearchBarTextStyle(SizeConfig.screenWidth),
            focusedBorder: kSearchBarBorder,
            enabledBorder: kSearchBarBorder,
          ),
        ),
      ),
    );
  }
}
