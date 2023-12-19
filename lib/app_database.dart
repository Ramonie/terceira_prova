// Arquivo: app_database.dart
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:terceira_prova/pokemon.dart';
//2) Defina a data class para guardar dados de Pokémons com base nas informações que podem ser
//obtidas através da PokeAPI (https://pokeapi.co/). Crie pelo menos 6 atributos. Implemente o uso de
//banco de dados utilizando a biblioteca SQFLITE através da biblioteca Floor (não será aceito o uso
//de SQFLITE puro). Você deve implementar métodos para: criar, deletar, listar todos, listar por ID.
//(1,0 pontos).


@Database(version: 1, entities: [Pokemon])
abstract class AppDatabase extends FloorDatabase {
  PokemonDao get pokemonDao;
}

@dao
abstract class PokemonDao {
  @Query('SELECT * FROM Pokemon')
  Future<List<Pokemon>> findAllPokemons();

  @Query('SELECT * FROM Pokemon WHERE id = :id')
  Future<Pokemon?> findPokemonById(int id);

  @insert
  Future<void> insertPokemon(Pokemon pokemon);

  @delete
  Future<void> deletePokemon(Pokemon pokemon);
}
