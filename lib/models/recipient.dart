class Recipient {
  int? recipient_id;
  late String name;
  late String relationship;
  late double budget;

  Recipient({
    this.recipient_id,
    required this.name,
    required this.relationship,
    this.budget = 0.0,
  });
}
