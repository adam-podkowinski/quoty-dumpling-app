import 'package:flutter/material.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          TextField(
            onChanged: (value) {
              setState(() {});
            },
            style: kSearchBarTextStyle(SizeConfig.screenWidth),
            controller: _controller,
            focusNode: _focusNode,
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
              focusedBorder: kSearchBarBorder,
              enabledBorder: kSearchBarBorder,
            ),
          ),
          Positioned(
            right: SizeConfig.screenWidth * .02546296,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: _controller.text != '' ? 1 : 0,
              child: GestureDetector(
                child: Icon(
                  Icons.cancel,
                  color: Theme.of(context).backgroundColor,
                ),
                onTap: () {
                  if (_controller.text != '') {
                    //error which is a flutter's fault... have to use this kind of workaround
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => setState(
                        () {
                          _controller.clear();
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
