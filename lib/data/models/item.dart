class Item {
  final String id;
  final String name;
  final int stock;
  final String location;
  final String photoUrl;

  Item({
    required this.id,
    required this.name,
    required this.stock,
    required this.location,
    required this.photoUrl,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'].toString(),
      name: json['name'],
      stock: json['stock'],
      location: json['location'],
      photoUrl: json['photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "stock": stock,
      "location": location,
      "photo_url": photoUrl,
    };
  }
}
