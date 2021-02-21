import 'package:shared_preferences/shared_preferences.dart';

class Achievement {
  String _title;
  String _description;

  String _id;

  int _billsReward;
  int _diamondsReward;

  int doneVal; // How much user accomplished
  int _maxToDoVal; // When achievement is done

  String get title => _title;

  String get description => _description;

  String get id => _id;

  int get billsReward => _billsReward;

  int get diamondsReward => _diamondsReward;

  int get maxToDoVal => _maxToDoVal;

  bool isRewardReceived = false;
  bool get isDone => doneVal >= _maxToDoVal;

  Future<void> receiveReward() async {
    isRewardReceived = true;
    var dbInstance = await SharedPreferences.getInstance();
    await dbInstance.setBool('isRewardReceived' + _id, isRewardReceived);
  }

  Achievement(Map<String, dynamic> map) {
    _title = map['title'];
    _description = map['description'];
    _billsReward = map['billsReward'];
    _diamondsReward = map['diamondsReward'];
    _maxToDoVal = map['maxToDoVal'];
    _id = map['id'];

    doneVal = 0;
    SharedPreferences.getInstance().then(
      (db) => isRewardReceived = db.getBool('isRewardReceived' + _id) ?? false,
    );
  }
}
