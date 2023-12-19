import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terceira_prova/pokemon.dart';

class PokemonList extends StatelessWidget {
  const PokemonList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pokemon>?>(
      future: fetchPokemonList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text('No Pokémon data available.'));
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
  const TelaCaptura({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
      int sorteio = random.nextInt(20);
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
          ? const Center(child: Text('Sem números sorteados. Verifique a conexão com a internet.'))
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
        child: const Icon(Icons.shuffle),
      ),
    );
  }
}

class PokemonCapturaItem extends StatelessWidget {
  final int numeroSorteado;

  const PokemonCapturaItem({Key? key, required this.numeroSorteado}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Pokemon>(
      future: fetchPokemonById(numeroSorteado),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('No Pokémon data available for number $numeroSorteado');
        } else {
          final Pokemon pokemon = snapshot.data!;
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
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

class CapturarButton extends StatefulWidget {
  final Pokemon pokemon;

  const CapturarButton({super.key, required this.pokemon});

  @override
  _CapturarButtonState createState() => _CapturarButtonState();
}

class _CapturarButtonState extends State<CapturarButton> {
  late Future<bool> _isCapturedFuture;

  @override
  void initState() {
    super.initState();
    _isCapturedFuture = isPokemonCaptured(widget.pokemon);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isCapturedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildButton(Colors.grey, 'Carregando...');
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
        bool isCaptured = await _isCapturedFuture;
        

        if (!isCaptured) {
          
          
          print('Capturou o Pokémon ${widget.pokemon.name}!');
          
          await adicionarPokemonCapturado(widget.pokemon);
          // Atualiza a lista de sorteios após a captura
          TelaCaptura telaCaptura = TelaCaptura();
          telaCaptura.gerarSorteios();
          setState(() {
            _isCapturedFuture = isPokemonCaptured(widget.pokemon);
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Restante do código
}

Future<Pokemon> fetchPokemonById(int id) async {
  final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$id'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return Pokemon.fromJson(data);
  } else {
    throw Exception('Falha ao carregar dados de Pokémon para ID $id');
  }
}

Future<List<Pokemon>> fetchPokemonList() async {
  final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=1017'));

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
