class Pokemon {
  final int? id;
  final String name;
  final String imageUrl;

  Pokemon({this.id, required this.name, required this.imageUrl});

 factory Pokemon.fromJson(Map<String, dynamic> json) {
  return Pokemon(
    id: json['id'],
    name: json['name'],
    imageUrl: json['sprites'] != null ? json['sprites']['front_default'] : '',
  );
}

  Object? toJson() {
    return null;
  }

}
