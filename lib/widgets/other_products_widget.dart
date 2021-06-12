import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:quoty_dumpling_app/helpers/constants.dart';
import 'package:quoty_dumpling_app/models/items/money_item.dart';
import 'package:quoty_dumpling_app/widgets/shop_tab_bar_view.dart';

class OtherProductsWidget extends StatefulWidget {
  const OtherProductsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<OtherProductsWidget> createState() => _OtherProductsWidgetState();
}

class _OtherProductsWidgetState extends State<OtherProductsWidget> {
  static const String _kRemoveAdsId = 'remove_ads1';
  static const List<String> _kProductIds = <String>[_kRemoveAdsId];
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = false;
  String? _queryProductError;

  @override
  void initState() {
    super.initState();
    final purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        print(
          'ERROR in OtherProductsWidget while listening to purchaseUpdated $error',
        );
      },
    );
    initStoreInfo();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _products
          .map(
            (u) => Item(
              MoneyItem.fromProductDetails(u),
              ThemeColors.surface,
              buyProduct,
            ),
          )
          .toList(),
    );
  }

  void buyProduct(String id) {
    print('Buying product!');
    var productDetails = _products.firstWhere((element) => element.id == id);
    late var purchaseParam = PurchaseParam(productDetails: productDetails);
    if (productDetails.id == _kRemoveAdsId) {
      _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          var valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    //TODO: verify a purchase (no need cuz im lazy)
    return Future<bool>.value(true);
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == _kRemoveAdsId) {
      setState(() {
        _purchasePending = false;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    print(
      'ERROR: Invalid purchase for product id ${purchaseDetails.productID}',
    );
  }

  Future<void> initStoreInfo() async {
    final isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      print('Purchases unavailable');
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    var productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _purchasePending = false;
      _loading = false;
    });
  }
}
