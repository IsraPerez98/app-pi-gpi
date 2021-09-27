class AudioMessage {
  late String message;
  late dynamic date;
  late dynamic file;

  AudioMessage({required this.message, this.date, this.file});

  AudioMessage.empty() {
    this.message = 'The translated message with audio';
    this.date = null;
    this.file = null;
  }

  factory AudioMessage.fromJSON(Map<String, dynamic> json) {
    if (json == null) {
      return AudioMessage.empty();
    }
    return AudioMessage(
        message: json['message'], date: json['date'], file: json['file']);
  }

  static List<AudioMessage> fromJSONlist(dynamic json) {
    if (json == null) {
      return [];
    }
    List<AudioMessage> list = [];
    for (var i = 0; i < json.length; i++) {
      list.add(AudioMessage.fromJSON(json[i]));
    }
    return list;
  }
}
