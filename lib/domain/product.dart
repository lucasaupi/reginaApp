class Product {
  String id;
  String name;
  int price;
  String description;
  String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.imageUrl
  });
}