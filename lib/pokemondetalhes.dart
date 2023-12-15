import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'telacaptura.dart';

class TelaDetalhesPokemon extends StatefulWidget {
  final int pokemonId;

  TelaDetalhesPokemon({Key? key, required this.pokemonId}) : super(key: key);

  @override
  _TelaDetalhesPokemonState createState() => _TelaDetalhesPokemonState();
}

class _TelaDetalhesPokemonState extends State<TelaDetalhesPokemon> {
  late Pokemon _pokemon;

  @override
  void initState() {
    super.initState();
    _carregarDetalhesPokemon();
  }

  Future<void> _carregarDetalhesPokemon() async {
    try {
      final pokemon = await fetchPokemonById(widget.pokemonId);
      setState(() {
        _pokemon = pokemon;
      });
    } catch (e) {
      print('Erro ao carregar detalhes do Pokémon: $e');
      // Lide com o erro conforme necessário
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pokemon == null) {
      // Aguarde até que o Pokémon seja carregado
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(_pokemon.name),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                _pokemon.imageUrl,
                height: 300, // Ajuste conforme necessário
                width: MediaQuery.of(context).size.width, // Use a largura total da tela
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('ID: ${_pokemon.id}'),
              ),
              // Adicione mais informações conforme necessário
            ],
          ),
        ),
      );
    }
  }
}

// Restante do código do Pokemon, fetchPokemonById, etc.
