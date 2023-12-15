class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final double height;
  final double weight;
  // Adicione outros atributos conforme necessário

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.height,
    required this.weight,
    // Adicione outros atributos ao construtor conforme necessário
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites'] != null
          ? json['sprites']['other']['official-artwork']['front_default']
          : '',
      height: json['height'] != null ? json['height'] / 10.0 : 0.0,
      weight: json['weight'] != null ? json['weight'] / 10.0 : 0.0,
      // Adicione outros atributos conforme necessário
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'height': height,
      'weight': weight,
      // Adicione outros atributos ao mapa conforme necessário
    };
  }
}
