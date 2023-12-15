import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math'; // Importe a biblioteca de números aleatórios
import 'package:http/http.dart' as http;
import 'package:terceira_prova/pokemon.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Pokémon App'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'List'),
                Tab(text: 'Capture'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              PokemonList(),
              TelaCaptura(),
            ],
          ),
        ),
      ),
    );
  }
}

class PokemonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pokemon>>(
      future: fetchPokemonList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Pokémon data available.'));
        } else {
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
        }
      },
    );
  }
}

class TelaCaptura extends StatefulWidget {
  @override
  _TelaCapturaState createState() => _TelaCapturaState();
}

class _TelaCapturaState extends State<TelaCaptura> {
  List<int> sorteios = [];

  @override
  void initState() {
    super.initState();
    gerarSorteios();
  }

  Future<void> gerarSorteios() async {
    final List<int> numerosSorteados = [];
    final Random random = Random();

    while (numerosSorteados.length < 6) {
      int sorteio = random.nextInt(1018); // Gera números de 0 a 1017
      if (!numerosSorteados.contains(sorteio)) {
        numerosSorteados.add(sorteio);
      }
    }

    setState(() {
      sorteios = numerosSorteados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return sorteios.isEmpty
        ? Center(child: Text('Sem números sorteados. Verifique a conexão com a internet.'))
        : ListView.builder(
            itemCount: sorteios.length,
            itemBuilder: (context, index) {
              return PokemonCapturaItem(numeroSorteado: sorteios[index]);
            },
          );
  }
}

class PokemonCapturaItem extends StatelessWidget {
  final int numeroSorteado;

  PokemonCapturaItem({required this.numeroSorteado});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Pokemon>(
      future: fetchPokemonById(numeroSorteado),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('No Pokémon data available for number $numeroSorteado');
        } else {
          final Pokemon pokemon = snapshot.data!;
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(pokemon.imageUrl),
            ),
            title: Text(pokemon.name),
            subtitle: Text('ID: ${pokemon.id}'),
            trailing: ElevatedButton(
              onPressed: () {
                // Adicione a lógica de captura do Pokémon aqui
                print('Capturou o Pokémon ${pokemon.name}!');
              },
              child: Text('Capturar'),
            ),
          );
        }
      },
    );
  }
}

Future<List<Pokemon>> fetchPokemonList() async {
  final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=10'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['results'];
    return data.map((json) => Pokemon.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load Pokémon list');
  }
}

Future<Pokemon> fetchPokemonById(int id) async {
  final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$id'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return Pokemon.fromJson(data);
  } else {
    throw Exception('Failed to load Pokémon data for ID $id');
  }
}
