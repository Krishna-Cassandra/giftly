class GiftIdea {
  int? gift_idea_id;
  late int recipient_id;
  late String gift_idea_name;
  late double price;

  GiftIdea({
    this.gift_idea_id,
    required this.recipient_id,
    required this.gift_idea_name,
    this.price = 0.0,
  });
}
