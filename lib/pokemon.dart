class Pokemon {
  final int? id;
  final String name;
  final String imageUrl;
  final String type;
  final int baseExperience;
  final List<String> abilities;
  final int height;
  final int weight;

  Pokemon({
    this.id,
    required this.name,
    required this.imageUrl,
    required this.type,
    required this.baseExperience,
    required this.abilities,
    required this.height,
    required this.weight,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null || json['name'] == null || json['sprites'] == null) {
      // Tratar um JSON nulo ou incompleto
      throw const FormatException("Invalid Pokemon JSON");
    }

    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'] ?? '',
      type: json['type'] ?? 'Unknown',
      baseExperience: json['base_experience'] ?? 0,
      abilities: List<String>.from(json['abilities'] ?? []),
      height: json['height'] ?? 0,
      weight: json['weight'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'type': type,
      'baseExperience': baseExperience,
      'abilities': abilities,
      'height': height,
      'weight': weight,
    };
  }

  static List<Pokemon> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Pokemon.fromJson(json)).toList();
  }


}
