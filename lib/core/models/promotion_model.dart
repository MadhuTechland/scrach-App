// file: lib/data/models/promotion.dart

class Promotion {
  final int id;
  final String image;
  final String name;
  final bool isSlider;

  Promotion({
    required this.id,
    required this.image,
    required this.name,
    required this.isSlider,
  });

  // Factory constructor to create a Promotion from JSON
  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      isSlider: json['is_slider'] == 1, // Convert 1 to true, 0 to false
    );
  }
}
