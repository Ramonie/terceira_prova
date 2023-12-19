import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terceira_prova/pokemon.dart';
import 'package:terceira_prova/telasoltar.dart';
import 'dart:convert';

import 'pokemondetalhes.dart';
//5) Implemente uma widget TelaPokemonCapturado e adicione um ListView. Liste todos os Pokémons
//capturados que estão cadastrados no banco de dados local. Caso não haja nenhum Pokémon
//capturado ainda, crie uma Widget de Text informando essa condição. (1,0 ponto)

class TelaPokemonCapturado extends StatefulWidget {
  const TelaPokemonCapturado({Key? key}) : super(key: key);

  @override
  _TelaPokemonCapturadoState createState() => _TelaPokemonCapturadoState();
}

class _TelaPokemonCapturadoState extends State<TelaPokemonCapturado> {
  late List<Pokemon> pokemonsCapturados = [];

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
          final Pokemon pokemon = pokemonsCapturados[index];
//6) Adicione uma widget de GestureDetector nos ListItems da TelaPokemonCapturado para que com
//um toque simples a aplicação navegue para o TelaDetalhesPokemon e com o toque longo a
//aplicação navegue para o TelaSoltarPokemon. (1,0 ponto)
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
            onLongPress: () async {
              // Navegar para TelaSoltarPokemon com um toque longo
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaSoltarPokemon(pokemonId: pokemon.id),
                ),
              );

              // Após soltar o Pokémon, recarrega a lista
              _carregarPokemonsCapturados();
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(pokemon.imageUrl),
                radius: 25, // Defina o raio conforme necessário
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
