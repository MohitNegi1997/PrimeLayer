enum DashboardPeriod {
  today,
  sevenDays,
  thirtyDays;

  String get label => switch (this) {
    DashboardPeriod.today => 'Today',
    DashboardPeriod.sevenDays => '7 days',
    DashboardPeriod.thirtyDays => '30 days',
  };
}
