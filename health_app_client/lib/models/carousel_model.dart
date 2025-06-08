// lib/models/carousel_model.dart
class CarouselModel {
  final int id;
  final String imageUrl;
  final String link;
  final int sort;

  CarouselModel({
    required this.id,
    required this.imageUrl,
    required this.link,
    required this.sort,
  });

  factory CarouselModel.fromJson(Map<String, dynamic> json) {
    return CarouselModel(
      id: json['id'],
      imageUrl: json['imageUrl'],
      link: json['link'] ?? '',
      sort: json['sort'] ?? 0,
    );
  }
}