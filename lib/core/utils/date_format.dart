const _months = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

String timeAgo(DateTime t) {
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 1) return 'Just now';
  if (d.inMinutes < 60) return '${d.inMinutes} min ago';
  if (d.inHours < 24) return '${d.inHours} hours ago';
  if (d.inDays == 1) return 'Yesterday';
  return '${d.inDays} days ago';
}

String fullDate(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';
