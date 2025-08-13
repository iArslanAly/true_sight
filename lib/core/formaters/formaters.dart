/// Returns current year as a string (e.g., "2025")
String currentYear() {
  return DateTime.now().year.toString();
}

/// Returns formatted date & time (e.g., "2025-08-12 14:35")
String formattedDateTime() {
  final now = DateTime.now();
  return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} "
      "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
}
