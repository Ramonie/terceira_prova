import 'package:flutter/material.dart';
import 'telacaptura.dart';

class TelaDetalhesPokemon extends StatefulWidget {
  final int pokemonId;

  const TelaDetalhesPokemon({Key? key, required this.pokemonId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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
                child: Text('Peso: ${_pokemon.height}'),
              ),
              // Adicione mais informações conforme necessário
            ],
          ),
        ),
      );
    }
  }
}
