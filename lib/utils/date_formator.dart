String formatBannerDate(DateTime date) {
  final day = date.day;

  final suffix = (day >= 11 && day <= 13)
      ? 'th'
      : switch (day % 10) {
    1 => 'st',
    2 => 'nd',
    3 => 'rd',
    _ => 'th',
  };

  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  return '${months[date.month - 1]} $day$suffix, ${date.year}';
}
