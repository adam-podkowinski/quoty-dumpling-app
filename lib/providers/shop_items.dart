import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:quoty_dumpling_app/data/db_provider.dart';
import 'package:quoty_dumpling_app/models/items/item.dart';
import 'package:quoty_dumpling_app/models/items/money_item.dart';
import 'package:quoty_dumpling_app/models/items/powerup_item.dart';
import 'package:quoty_dumpling_app/models/items/upgrade_item.dart';

class ShopItems extends ChangeNotifier {
  final List<ShopItem> _items = [];
  final List<UpgradeItem> _upgrades = [];

  final List<PowerupItem> _powerups = [];
  final List<MoneyItem> _money = [];

  List<ShopItem> get items => [..._items];

  List<MoneyItem> get money => [..._money];

  List<PowerupItem> get powerups => [..._powerups];

  List<UpgradeItem> get upgrades => [..._upgrades];

  PowerupItem? currentPowerup;

  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  final List<String> _productIds = <String>[];
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];

  bool isAvailable = false;
  bool purchasePending = false;
  bool loading = false;
  String? queryProductError;

  List<String>? get productIds => [..._productIds];

  List<String> get notFoundIds => [..._notFoundIds];

  List<ProductDetails> get products => [..._products];

  List<PurchaseDetails> get purchases => [..._purchases];

  bool isMoneyItemAvailable(MoneyItem item) {
    if (item.isConsumable) return true;
    var productId = _products.firstWhere((e) => e.id == item.id).id;
    //print('Product id: $productId');
    if (purchases.map((e) => e.productID).contains((e) => e.id == productId)) {
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void addPowerup(powerup) {
    if (currentPowerup == null) {
      currentPowerup = powerup;
      var sub = currentPowerup!.timer.listen(null);
      sub.onData((duration) {
        currentPowerup!.updateTimer(duration.elapsed.inSeconds);
        notifyListeners();
      });
      sub.onDone(() {
        currentPowerup!.deactivatePowerup();
        currentPowerup = null;
        sub.cancel();
        notifyListeners();
      });
    }
  }

  Future fetchItems(BuildContext context) async {
    print('fetching items');
    List<dynamic>? content;

    content = jsonDecode(
      await rootBundle.loadString('assets/items/items.json'),
    );

    _items.clear();

    _items.addAll(
      content!.map(
        (e) => ShopItem.fromItemType(e),
      ),
    );

    final dbItems = await DBProvider.getAllElements('Items');

    _items.forEach((u) {
      u.fetchFromDB(
        dbItems.firstWhere((e) => e['id'] == u.id, orElse: () => {}),
      );
      switch (u.runtimeType) {
        case UpgradeItem:
          _upgrades.add(u as UpgradeItem);
          break;
        case PowerupItem:
          _powerups.add(u as PowerupItem);
          break;
        default:
          _money.add(u as MoneyItem);
          break;
      }
    });

    _productIds.clear();
    _productIds.addAll(_money.map((e) => e.id ?? ''));

    final purchaseUpdated = inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        print(
          'ERROR in fetchItems while listening to purchaseUpdated $error',
        );
      },
    );

    await initStoreInfo();

    _money.forEach((element) {
      element.priceUSD = _products.firstWhere((e) => e.id == element.id).price;
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print('PENDING');
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          print('ERROR');
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          print('restored or purchased');
          var valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          print('pendingCompletePurchase');
          await inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
  }

  void showPendingUI() {
    purchasePending = true;
    notifyListeners();
  }

  void handleError(IAPError error) {
    purchasePending = false;
    notifyListeners();
    print('ERROR while buying an item');
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    //TODO: verify a purchase (no need cuz im lazy)
    return Future<bool>.value(true);
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    _purchases.add(purchaseDetails);
    purchasePending = false;
    notifyListeners();
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    print(
      'ERROR: Invalid purchase for product id ${purchaseDetails.productID}',
    );
  }

  void buyProduct(String id) {
    print('Buying product!');
    var productDetails = _products.firstWhere((element) => element.id == id);
    late var purchaseParam = PurchaseParam(productDetails: productDetails);
    if (_productIds.contains(productDetails.id)) {
      inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  Future<void> initStoreInfo() async {
    final isAvailable = await inAppPurchase.isAvailable();
    if (!isAvailable) {
      print('Purchases unavailable');
      this.isAvailable = isAvailable;
      _products = [];
      _purchases = [];
      _notFoundIds = [];
      purchasePending = false;
      loading = false;
      notifyListeners();
      return;
    }

    var productDetailResponse = await inAppPurchase.queryProductDetails(
      _productIds.toSet(),
    );
    if (productDetailResponse.error != null) {
      queryProductError = productDetailResponse.error!.message;
      this.isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = [];
      _notFoundIds = productDetailResponse.notFoundIDs;
      purchasePending = false;
      loading = false;
      notifyListeners();
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      queryProductError = null;
      this.isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = [];
      _notFoundIds = productDetailResponse.notFoundIDs;
      purchasePending = false;
      loading = false;
      notifyListeners();
      return;
    }

    this.isAvailable = isAvailable;
    _products = productDetailResponse.productDetails;
    _notFoundIds = productDetailResponse.notFoundIDs;
    purchasePending = false;
    loading = false;
    notifyListeners();
  }
}
