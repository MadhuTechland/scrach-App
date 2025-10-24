class Promotion {
  final int id;
  final String name;
  final String isSlider;
  final String image;

  Promotion({
    required this.id,
    required this.name,
    required this.isSlider,
    required this.image,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'],
      name: json['name'] ?? '',
      isSlider: json['is_slider'].toString(), // ensure it's a string
      image: json['image'],
    );
  }
}
