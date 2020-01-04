import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/providers/collection.dart';
import 'package:quoty_dumpling_app/widgets/custom_app_bar.dart';
import 'package:quoty_dumpling_app/widgets/search_bar.dart';

class CollectionScreen extends StatefulWidget {
  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  Collection _collectionProvider;

  @override
  void initState() {
    super.initState();
    _collectionProvider = Provider.of<Collection>(context, listen: false);
    _collectionProvider.fetchUnlockedItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
          children: _collectionProvider.unlockedItems.length <= 0
              ? <Widget>[
                  CustomAppBar('Collection'),
                  NothingInCollectionWidget(),
                ]
              : <Widget>[
                  CustomAppBar('Collection'),
                  IntrinsicHeight(child: SearchBar()),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _collectionProvider.unlockedItems.length,
                      itemBuilder: (ctx, index) => Text(
                        _collectionProvider.unlockedItems[index].quote,
                      ),
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}

class NothingInCollectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'You haven\'t unlocked anything yet. Go and open your dumplings!',
    );
    //TODO: Add button which goes to dumpling screen and add some styling
  }
}
