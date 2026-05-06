import 'enums.dart';

class Room {
  final String id;
  final String name;
  final RoomType type;
  final int capacity;
  final String floor;
  final String building;
  RoomStatus status;
  final List<String> facilities;
  final double rating;
  final int reviews;

  Room({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.floor,
    required this.building,
    required this.status,
    required this.facilities,
    required this.rating,
    required this.reviews,
  });

  String get typeName {
    switch (type) {
      case RoomType.boardroom:   return 'BOARDROOM';
      case RoomType.meetingRoom: return 'MEETING ROOM';
      case RoomType.huddleSpace: return 'HUDDLE SPACE';
      case RoomType.training:    return 'TRAINING';
    }
  }
}
