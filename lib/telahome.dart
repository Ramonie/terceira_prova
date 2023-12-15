import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:terceira_prova/pokemon.dart';



class TelaHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Pokemon>>(
        future: fetchPokemonList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final pokemon = snapshot.data![index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(pokemon.imageUrl),
                  ),
                  title: Text(pokemon.name),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: Text('No Pokémon data available.'),
            );
          }
        },
      ),
    );
  }
}

Future<List<Pokemon>> fetchPokemonList() async {
  final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=1017'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['results'];
    final List<Pokemon> pokemonList = await fetchPokemonDetails(data);
    return pokemonList;
  } else {
    print('Failed to load Pokémon list. Status Code: ${response.statusCode}');
    throw Exception('Failed to load Pokémon list');
  }
}

Future<List<Pokemon>> fetchPokemonDetails(List<dynamic> pokemonData) async {
  final List<Pokemon> pokemonList = [];

  for (final pokemon in pokemonData) {
    final response = await http.get(Uri.parse(pokemon['url']));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Pokemon fetchedPokemon = Pokemon.fromJson(data);
      pokemonList.add(fetchedPokemon);
    } else {
      print('Failed to load Pokémon details. Status Code: ${response.statusCode}');
    }
  }

  return pokemonList;
}

void main() {
  runApp(MaterialApp(
    home: TelaHome(),
  ));
}
