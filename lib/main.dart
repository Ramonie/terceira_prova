import 'package:flutter/material.dart';
import 'package:terceira_prova/pokemoncapturado.dart';
import 'package:terceira_prova/sobre.dart';
import 'package:terceira_prova/telacaptura.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3, // Número de abas
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Pokémon List'),
          
            bottom: const TabBar(
              tabs: [
                //Tab(text: 'Home'), // Aba 1
                Tab(text: 'Capturar'), // Aba 2
                Tab(text: 'Capturados'),
                Tab(text: 'Sobre',)
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              // Conteúdo da Aba 1
              //TelaHome(),
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


