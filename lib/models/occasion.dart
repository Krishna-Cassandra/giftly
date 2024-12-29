class Occasion {
  int? occasion_id;
  late int recipient_id;
  late String occasion_name;
  late String occasion_date;

  Occasion({
    this.occasion_id,
    required this.recipient_id,
    required this.occasion_name,
    required this.occasion_date,
  });
}
