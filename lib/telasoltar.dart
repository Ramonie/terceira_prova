// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:terceira_prova/pokemon.dart';
import 'package:terceira_prova/telacaptura.dart';

class TelaSoltarPokemon extends StatefulWidget {
  final int pokemonId;

  const TelaSoltarPokemon({Key? key, required this.pokemonId}) : super(key: key);

  @override
  _TelaSoltarPokemonState createState() => _TelaSoltarPokemonState();
}

class _TelaSoltarPokemonState extends State<TelaSoltarPokemon> {
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

  void _confirmarSoltura() {
    // Lógica para confirmar a soltura do Pokémon (delete do banco de dados local)
    // Adicione a lógica necessária para deletar o Pokémon do banco de dados local
    // Exemplo: PokemonDatabase.deletePokemon(widget.pokemonId);
    Navigator.pop(context as BuildContext); // Voltar para a tela anterior
  }

  void _cancelarSoltura() {
    Navigator.pop(context as BuildContext); // Voltar para a tela anterior
  }

  @override
  Widget build(BuildContext context) {
    if (_pokemon == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Soltar'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                _pokemon.imageUrl,
                height: 400,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('ID: ${_pokemon.id}'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Nome: ${_pokemon.name}'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Altura: ${_pokemon.height}'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Peso: ${_pokemon.weight}'),
              ),
              // Adicione mais informações conforme necessário
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Solatr'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _confirmarSoltura,
                    child: const Text('Confirmar'),
                  ),
                  ElevatedButton(
                    onPressed: _cancelarSoltura,
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
