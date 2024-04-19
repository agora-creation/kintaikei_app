class WorkBreakModel {
  String _id = '';
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();

  String get id => _id;

  WorkBreakModel.fromMap(Map data) {
    _id = data['id'] ?? '';
    startedAt = data['startedAt'].toDate() ?? DateTime.now();
    endedAt = data['endedAt'].toDate() ?? DateTime.now();
  }

  Map toMap() => {
        'id': _id,
        'startedAt': startedAt,
        'endedAt': endedAt,
      };
}
