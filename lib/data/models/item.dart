class Item {
  final String id;
  final String name;
  final String category;
  final int quantityTotal;
  final int quantityAvailable;
  final String condition;
  final String location;
  final String photoUrl;

  Item({
    required this.id,
    required this.name,
    required this.category,
    required this.quantityTotal,
    required this.quantityAvailable,
    required this.condition,
    required this.location,
    required this.photoUrl,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      quantityTotal: json['quantity_total'],
      quantityAvailable: json['quantity_available'],
      condition: json['condition'],
      location: json['location'],
      photoUrl: json['photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity_total': quantityTotal,
      'quantity_available': quantityAvailable,
      'condition': condition,
      'location': location,
      'photo_url': photoUrl,
    };
  }
}
