const _months = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

/// "Just now", "5 min ago", "1 hour ago", "Yesterday", "3 days ago", then the date after a week.
String timeAgo(DateTime t) {
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 1) return 'Just now';
  if (d.inMinutes < 60) return '${d.inMinutes} min ago';
  if (d.inHours < 24) return d.inHours == 1 ? '1 hour ago' : '${d.inHours} hours ago';
  if (d.inDays == 1) return 'Yesterday';
  if (d.inDays <= 7) return '${d.inDays} days ago';
  return fullDate(t);
}

/// True when [timeAgo] would show a calendar date rather than a relative time.
bool isOlderThanAWeek(DateTime t) => DateTime.now().difference(t).inDays > 7;

String fullDate(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';
