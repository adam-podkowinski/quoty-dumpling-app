import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/helpers/size_config.dart';
import 'package:quoty_dumpling_app/providers/collection_settings_provider.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  late Quotes _quotesProvider;

  var _isInit = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _quotesProvider = Provider.of<Quotes>(context);
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          TextField(
            onChanged: (value) {
              _quotesProvider.searchCollection(_controller.text);
              if (_quotesProvider.visibleQuotes.isEmpty &&
                  _quotesProvider.newQuotes.isEmpty) {
                Provider.of<CollectionSettings>(context, listen: false)
                    .refreshScrollFab();
              }
            },
            style: Styles.kSearchBarTextStyle,
            controller: _controller,
            decoration: InputDecoration(
              suffix: Icon(null),
              labelText: 'Search',
              hintText: 'Author or quote...',
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).backgroundColor,
                size: SizeConfig.screenWidth! * 0.07,
              ),
              hintStyle: Styles.kSearchBarTextStyle,
              labelStyle: Styles.kSearchBarTextStyle,
              focusedBorder: Styles.kSearchBarBorder,
              enabledBorder: Styles.kSearchBarBorder,
            ),
          ),
          Positioned(
            right: SizeConfig.screenWidth! * .02546296,
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
                    setState(() {
                      FocusScope.of(context).unfocus();
                      //error which is a flutter's fault.. .have to use this kind of workaround
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        _controller.clear();
                        _quotesProvider.searchCollection(_controller.text);

                        if (_quotesProvider.visibleQuotes.isEmpty &&
                            _quotesProvider.newQuotes.isEmpty) {
                          Provider.of<CollectionSettings>(context,
                                  listen: false)
                              .refreshScrollFab();
                        }
                      });
                    });
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
