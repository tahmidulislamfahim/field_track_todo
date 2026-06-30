import 'package:flutter/material.dart';

class SyncItem {
  final String title;
  final String time; // e.g., "10:15 AM"
  final IconData icon;
  final String type; // e.g. "inventory", "document", "location"

  const SyncItem({
    required this.title,
    required this.time,
    required this.icon,
    required this.type,
  });
}
