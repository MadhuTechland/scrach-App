class ScratchCard {
  final int id;
  final String name;
  final String price;
  final int userId;
  final int crashCardId;
  final bool isScratched;
  final String? image;
  final String? winnerName;
  final String? phoneNumber;

  ScratchCard({
    required this.id,
    required this.name,
    required this.price,
    required this.userId,
    required this.crashCardId,
    required this.isScratched,
    this.image,
    this.winnerName,
    this.phoneNumber,
  });

  factory ScratchCard.fromJson(Map<String, dynamic> json) {
    return ScratchCard(
      id: json['id'],
      name: json['name'] ?? '',
      price: json['price'],
      userId: json['user_id'],
      crashCardId: json['crash_card_id'],
      isScratched: json['is_scratched'] == 1,
      image: json['crash_card']?['image'],
      winnerName: json['winner_user'] ?? 'Unknow',
      phoneNumber: json['phone_number'] ?? '0000000000',
    );
  }
}
