import 'package:cwa_application/event_model.dart';
import 'package:flutter/foundation.dart';

class Ticket implements Comparable<Ticket> {
  final Event event;
  final String id;
  final String member;

  Ticket({
    @required this.event,
    @required this.id,
    @required this.member,
  });

  factory Ticket.fromJson(Map<String, dynamic> json, Event event2) {
    return Ticket(
      event: event2,
      id: json['_id'] as String,
      member: json['member'] as String,
    );
  }

  @override
  int compareTo(Ticket other) {
    DateTime now = DateTime.now();
    bool thisIsPassed = this.event.date.isBefore(now);
    bool otherIsPassed = other.event.date.isBefore(now);

    if (thisIsPassed && !otherIsPassed) {
      return 1;
    } else if (!thisIsPassed && otherIsPassed) {
      return -1;
    } else if (thisIsPassed && otherIsPassed) {
      return other.event.date.compareTo(this.event.date);
    }
    //if no one is outdated
    return this.event.date.compareTo(other.event.date);
  }
}
