import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terceira_prova/pokemon.dart';
import 'package:terceira_prova/telasoltar.dart';
import 'dart:convert';

import 'pokemondetalhes.dart';

class TelaPokemonCapturado extends StatefulWidget {
  const TelaPokemonCapturado({Key? key}) : super(key: key);

  @override
  _TelaPokemonCapturadoState createState() => _TelaPokemonCapturadoState();
}

class _TelaPokemonCapturadoState extends State<TelaPokemonCapturado> {
  late List<Pokemon> pokemonsCapturados = [] ;

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
          return GestureDetector(
            onTap: () {
              // Navegar para TelaDetalhesPokemon
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaDetalhesPokemon(pokemonId: pokemon.id),
                ),
              );
            },
            onLongPress: () {
              // Navegar para TelaSoltarPokemon com um toque longo
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaSoltarPokemon(pokemonId: pokemon.id),
                ),
              );
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(pokemon.imageUrl,scale: 1),
              ),
              title: Text(pokemon.name),
              subtitle: Text('ID: ${pokemon.id}'),
            ),
          );
        },
      );
    }
  }
}
