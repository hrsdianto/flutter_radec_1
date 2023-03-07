class ReadModel {
  late String taskId;
  late String titleRead;
  late String textRead;
  late int dt;

  ReadModel({
    required this.taskId,
    required this.titleRead,
    required this.textRead,
    required this.dt,
  });

  static ReadModel fromMap(Map<String, dynamic> map) {
    return ReadModel(
      taskId: map['taskId'],
      titleRead: map['titleRead'],
      textRead: map['textRead'],
      dt: map['dt'],
    );
  }
}
