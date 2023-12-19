import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terceira_prova/pokemon.dart';
import 'package:terceira_prova/telacaptura.dart';
//8) Crie uma widget chamada TelaSoltarPokemon que recebe como parâmetro um ID e possui Texts e
//Imagens com os dados do registro. Carregue os dados do banco de dados. Adicione dois botões,
//uma para confirmar que o Pokémon será solto (delete do banco de dados local) e outro para  cancelar.
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
 void mostrarSnackBar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
      ),
    );
  }
  Future<void> _carregarDetalhesPokemon() async {
    try {
      final pokemon = await fetchPokemonById(widget.pokemonId);
      setState(() {
        _pokemon = pokemon;
      });
    } catch (e) {
      print('Erro ao carregar detalhes do Pokémon: $e');
   
    }
  }

  Future<void> _removerPokemonCapturado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Obter a lista atual de Pokémon capturados
    List<String> pokemonsCapturadosJson = prefs.getStringList('pokemons_capturados') ?? [];
    List<Pokemon> pokemons = pokemonsCapturadosJson.map((json) => Pokemon.fromJson(jsonDecode(json))).toList();

    // Remover o Pokémon da lista com base no ID
    pokemons.removeWhere((pokemon) => pokemon.id == widget.pokemonId);

    // Atualizar a lista no SharedPreferences
    List<String> novaLista = pokemons.map((pokemon) => jsonEncode(pokemon.toJson())).toList();
    prefs.setStringList('pokemons_capturados', novaLista);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
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
              _pokemon?.imageUrl ?? '', // Adiciona uma verificação de nulo e usa uma string vazia se _pokemon for nulo
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
           
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Remover o Pokémon da lista de capturados
                      await _removerPokemonCapturado();

                      // Exibir o nome do Pokémon
                      print('Pokémon solto: ${_pokemon.name}');
                      mostrarSnackBar('Pokémon solto: ${_pokemon.name}!');

                      // Usando um Navigator global para navegar de volta
                      Navigator.of(context).pop();
                    },
                    child: const Text('Confirmar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
