import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    return FutureBuilder<List<Pokemon>?>(
      future: fetchPokemonList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
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
  
  void gerarSorteios() {}
}

class _TelaCapturaState extends State<TelaCaptura> with AutomaticKeepAliveClientMixin {
  List<int> sorteios = [];

  @override
  bool get wantKeepAlive => true;

  Future<void> gerarSorteios() async {
    final List<int> numerosSorteados = [];
    final Random random = Random();

    while (numerosSorteados.length < 6) {
      int sorteio = random.nextInt(1018);
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
    super.build(context);

    return Scaffold(
      body: sorteios.isEmpty
          ? Center(child: Text('Sem números sorteados. Verifique a conexão com a internet.'))
          : ListView.builder(
              itemCount: sorteios.length,
              itemBuilder: (context, index) {
                return PokemonCapturaItem(numeroSorteado: sorteios[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          gerarSorteios();
        },
        child: Icon(Icons.shuffle),
      ),
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
            trailing: CapturarButton(pokemon: pokemon),
          );
        }
      },
    );
  }
}

class CapturarButton extends StatelessWidget {
  final Pokemon pokemon;

  CapturarButton({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isPokemonCaptured(pokemon),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.hasError) {
          print('Error checking if Pokemon is captured: ${snapshot.error}');
          return _buildButton(Colors.red, 'Capturar');
        } else {
          return _buildButton(snapshot.data! ? Colors.grey : Colors.red, 'Capturar');
        }
      },
    );
  }

  Widget _buildButton(Color color, String buttonText) {
    return InkWell(
      onTap: () async {
        bool isCaptured = await isPokemonCaptured(pokemon);

        if (!isCaptured) {
          print('Capturou o Pokémon ${pokemon.name}!');
          await adicionarPokemonCapturado(pokemon);
          // Atualiza a lista de sorteios após a captura
          TelaCaptura().gerarSorteios();
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<bool> isPokemonCaptured(Pokemon pokemon) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> pokemonsCapturados = prefs.getStringList('pokemons_capturados') ?? [];

    return pokemonsCapturados.any((captured) {
      return jsonDecode(captured)['id'] == pokemon.id;
    });
  }

  Future<void> adicionarPokemonCapturado(Pokemon pokemon) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> pokemonsCapturados = prefs.getStringList('pokemons_capturados') ?? [];
    pokemonsCapturados.add(jsonEncode(pokemon.toJson()));
    prefs.setStringList('pokemons_capturados', pokemonsCapturados);
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
      imageUrl: json['sprites'] != null ? json['sprites']['front_default'] : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'imageUrl': imageUrl};
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

Future<List<Pokemon>> fetchPokemonList() async {
  final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=50'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['results'];
    final List<Pokemon> pokemonList = (await fetchPokemonDetails(data)).cast<Pokemon>();
    return pokemonList;
  } else {
    print('Failed to load Pokémon list. Status Code: ${response.statusCode}');
    throw Exception('Failed to load Pokémon list');
  }
}

Future<List<Pokemon>> fetchPokemonDetails(List<dynamic> pokemonData) async {
  List<Pokemon> pokemonList = [];

  for (var item in pokemonData) {
    final response = await http.get(Uri.parse(item['url']));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Pokemon pokemon = Pokemon.fromJson(data);
      pokemonList.add(pokemon);
    } else {
      print('Failed to load Pokémon details. Status Code: ${response.statusCode}');
      throw Exception('Failed to load Pokémon details');
    }
  }

  return pokemonList;
}
