import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/providers/collection.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';
import 'package:quoty_dumpling_app/widgets/custom_app_bar.dart';
import 'package:quoty_dumpling_app/widgets/search_bar.dart';

class CollectionScreen extends StatefulWidget {
  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  var _collectionProvider;

  @override
  void initState() {
    super.initState();
    _collectionProvider = Provider.of<Collection>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor.withOpacity(.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [.66, 1],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CustomAppBar('Collection'),
            IntrinsicHeight(child: SearchBar()),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (ctx, index) => Text(
                  Provider.of<Quotes>(context).items[0].quote,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
