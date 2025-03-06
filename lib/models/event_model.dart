class Event {
  final int id;
  final String eventName;
  final String eventDate;
  final int teamSize;
  final String eventType;
  final String duration;
  final bool internship;
  final String rank1Prize;
  final String rank2Prize;
  final String rank3Prize;
  final String poster;
  final String description;

  Event({
    required this.id,
    required this.eventName,
    required this.eventDate,
    required this.teamSize,
    required this.eventType,
    required this.duration,
    required this.internship,
    required this.rank1Prize,
    required this.rank2Prize,
    required this.rank3Prize,
    required this.poster,
    required this.description,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      eventName: json['eventName'],
      eventDate: json['eventDate'],
      teamSize: json['teamSize'],
      eventType: json['eventType'],
      duration: json['duration'],
      internship: json['internship'],
      rank1Prize: json['rank1Prize'],
      rank2Prize: json['rank2Prize'],
      rank3Prize: json['rank3Prize'],
      poster: json['poster'],
      description: json['description'],
    );
  }
}
