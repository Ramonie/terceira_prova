import 'package:flutter/material.dart';
import 'package:terceira_prova/pokemoncapturado.dart';
import 'package:terceira_prova/telacaptura.dart';

import 'sobre.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Pokémon List'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Capturar'), // Aba 2
                Tab(text: 'Capturados'),
                Tab(text: 'Sobre',),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              // Conteúdo da Aba 1
              // TelaHome(),
              // Conteúdo da Aba 2
              TelaCaptura(),
              TelaPokemonCapturado(),
              TelaSobre(),
            ],
          ),
        ),
      ),
    );
  }
}
