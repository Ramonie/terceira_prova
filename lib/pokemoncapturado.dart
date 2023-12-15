import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TelaPokemonCapturado extends StatefulWidget {
  const TelaPokemonCapturado({Key? key}) : super(key: key);

  @override
  _TelaPokemonCapturadoState createState() => _TelaPokemonCapturadoState();
}

class _TelaPokemonCapturadoState extends State<TelaPokemonCapturado> {
  late List<Pokemon> pokemonsCapturados;

  @override
  void initState() {
    super.initState();
    _carregarPokemonsCapturados();
  }

  Future<void> _carregarPokemonsCapturados() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> pokemonsCapturadosJson = prefs.getStringList('pokemons_capturados') ?? [];
    List<Pokemon> pokemons = pokemonsCapturadosJson.map((json) => Pokemon.fromJson(jsonDecode(json))).toList();

    setState(() {
      pokemonsCapturados = pokemons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _construirConteudo(),
    );
  }

  Widget _construirConteudo() {
    if (pokemonsCapturados.isEmpty) {
      return const Center(
        child: Text('Nenhum Pokémon capturado ainda.'),
      );
    } else {
      return ListView.builder(
        itemCount: pokemonsCapturados.length,
        itemBuilder: (context, index) {
          final pokemon = pokemonsCapturados[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(pokemon.imageUrl),
            ),
            title: Text(pokemon.name),
            subtitle: Text('ID: ${pokemon.id}'),
          );
        },
      );
    }
  }
}

class Pokemon {
  final int id;
  final String name;
  final String imageUrl;

  Pokemon({required this.id, required this.name, required this.imageUrl});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'imageUrl': imageUrl};
  }
}