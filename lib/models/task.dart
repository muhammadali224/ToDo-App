class Task {
  int? id;
  String? title;
  String? note;
  int? isComplete;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;

  Task(
      {this.id,
      this.title,
      this.note,
      this.isComplete,
      this.date,
      this.startTime,
      this.endTime,
      this.color,
      this.remind,
      this.repeat});

// create from json and to json with extension helper
  Task.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    note = json["note"];
    isComplete = json["isComplete"];
    date = json["date"];
    startTime = json["startTime"];
    endTime = json["endTime"];
    color = json["color"];
    remind = json["remind"];
    repeat = json["repeat"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "note": note,
      "isComplete": isComplete,
      "date": date,
      "startTime": startTime,
      "endTime": endTime,
      "color": color,
      "remind": remind,
      "repeat": repeat,
    };
  }

//
}
