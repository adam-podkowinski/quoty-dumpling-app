import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoty_dumpling_app/providers/quotes.dart';
import 'package:quoty_dumpling_app/widgets/collection_grid.dart';
import 'package:quoty_dumpling_app/widgets/custom_app_bar.dart';
import 'package:quoty_dumpling_app/widgets/search_bar.dart';

class CollectionScreen extends StatefulWidget {
	@override
	_CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
	Quotes _quotesProvider;

	@override
	void initState() {
		super.initState();
		_quotesProvider = Provider.of<Quotes>(context, listen: false);
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
					children: _quotesProvider.unlockedQuotes.length <= 0
							? <Widget>[
									CustomAppBar('Collection'),
									NothingInCollectionWidget(),
								]
							: <Widget>[
									CustomAppBar('Collection'),
									SearchBar(),
									CollectionGrid(),
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
			textAlign: TextAlign.center,
		);
		//TODO: Add button which goes to dumpling screen and add some styling
	}
}
