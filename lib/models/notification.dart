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
