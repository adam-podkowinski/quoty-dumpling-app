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

  Achievement(Map<String, dynamic> map) {
    _title = map['title'];
    _description = map['description'];
    _billsReward = map['billsReward'];
    _diamondsReward = map['diamondsReward'];
    _maxToDoVal = map['maxToDoVal'];
    _id = map['id'];

    doneVal = 0;
  }

  void fetchFromDB(Map<String, dynamic> map) {
    doneVal = map['doneVal'] ?? 0;
    print('\nHere is a done value: $doneVal \n \n');
    print('Here is a boolean: $isDone \n \n');
  }

  void updateState() {}
}
