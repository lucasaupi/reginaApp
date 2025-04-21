class Service {
  String id;
  String name;
  int price;
  String times;
  String description;
  String? imageUrl;
  List<String>? availableSlots;

  Service({
    required this.id,
    required this.name,
    required this.price,
    required this.times,
    required this.description,
    this.imageUrl,
    this.availableSlots,
  });
}
