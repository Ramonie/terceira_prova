//2) Defina a data class para guardar dados de Pokémons com base nas informações que podem ser
//obtidas através da PokeAPI (https://pokeapi.co/). Crie pelo menos 6 atributos. Implemente o uso de
//banco de dados utilizando a biblioteca SQFLITE através da biblioteca Floor (não será aceito o uso
//de SQFLITE puro). Você deve implementar métodos para: criar, deletar, listar todos, listar por ID.
//(1,0 pontos).

class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final double? height;
  final double? weight;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.height,
    required this.weight,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'height': height,
      'weight': weight,
    };
  }

}