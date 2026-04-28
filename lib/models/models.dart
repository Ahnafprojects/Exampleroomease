enum RoomStatus { available, booked, checkedin, maintenance }
enum RoomType { boardroom, meetingRoom, huddleSpace, training }
enum BookingStatus { booked, checkedin, done, cancelled, noshow }

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
      case RoomType.boardroom: return 'BOARDROOM';
      case RoomType.meetingRoom: return 'MEETING ROOM';
      case RoomType.huddleSpace: return 'HUDDLE SPACE';
      case RoomType.training: return 'TRAINING';
    }
  }
}

class Booking {
  final String id;
  final String roomId;
  final String roomName;
  final RoomType roomType;
  final String floor;
  final String date;
  final String dateShort;
  final String time;
  final String endTime;
  final String duration;
  final String keperluan;
  BookingStatus status;
  final List<String> facilities;

  Booking({
    required this.id,
    required this.roomId,
    required this.roomName,
    required this.roomType,
    required this.floor,
    required this.date,
    required this.dateShort,
    required this.time,
    required this.endTime,
    required this.duration,
    required this.keperluan,
    required this.status,
    required this.facilities,
  });
}

class NotificationItem {
  final String id;
  final int type;
  bool read;
  final String title;
  final String body;
  final String time;
  final String bookingId;
  final String roomId;
  final String group;

  NotificationItem({
    required this.id,
    required this.type,
    required this.read,
    required this.title,
    required this.body,
    required this.time,
    required this.bookingId,
    required this.roomId,
    required this.group,
  });
}

class UserModel {
  String name;
  String initials;
  String role;
  String dept;
  String email;
  String phone;
  String floor;
  bool isAdmin;

  UserModel({
    required this.name,
    required this.initials,
    required this.role,
    required this.dept,
    required this.email,
    required this.phone,
    required this.floor,
    required this.isAdmin,
  });
}
