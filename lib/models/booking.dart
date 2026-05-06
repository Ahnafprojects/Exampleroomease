import 'enums.dart';

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
