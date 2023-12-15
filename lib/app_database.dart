// Arquivo: app_database.dart
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:terceira_prova/pokemon.dart';

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
