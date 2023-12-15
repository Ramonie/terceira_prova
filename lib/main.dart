import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:terceira_prova/pokemon.dart';
import 'package:terceira_prova/telahome.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2, // Número de abas
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Pokémon List'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Home'), // Aba 1
                Tab(text: 'Favorites'), // Aba 2
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Conteúdo da Aba 1
              TelaHome(),
              // Conteúdo da Aba 2
            
            ],
          ),
        ),
      ),
    );
  }
}


