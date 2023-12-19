
import 'package:flutter/material.dart';
import 'package:terceira_prova/pokemon.dart';
import 'package:terceira_prova/telacaptura.dart';
//7) Crie uma widget chamada TelaDetalhesPokemon que recebe como parâmetro um ID e possui
//Texts e Imagens com os dados do registro. Carregue os dados do através da API e do banco de
//dados para mostrar informações completas sobre o Pokémon. (0,5 ponto)



class TelaDetalhesPokemon extends StatefulWidget {
  final int pokemonId;

  const TelaDetalhesPokemon({Key? key, required this.pokemonId}) : super(key: key);

  @override
  _TelaDetalhesPokemonState createState() => _TelaDetalhesPokemonState();
}

class _TelaDetalhesPokemonState extends State<TelaDetalhesPokemon> {
  late Pokemon _pokemon;
  bool _isLoading = true;

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
        _isLoading = false; // Marca o carregamento como concluído
      });
    } catch (e) {
      print('Erro ao carregar detalhes do Pokémon: $e');
      // Lide com o erro conforme necessário
      setState(() {
        _isLoading = false; // Marca o carregamento como concluído mesmo em caso de erro
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
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
                height: 400, // Ajuste conforme necessário
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
                child: Text('Peso: ${_pokemon.weight}'),
              ),
      
            ],
          ),
        ),
      );
    }
  }
}