import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:pokenav/models/progress.dart';

class ApiCall {
  static final ApiCall _apiCall = ApiCall._private();
  ApiCall._private();
  final _url = 'https://pokeapi.co/api/v2/';
  Map<int, Map<String, int>> pokedex = {
    1: {'count': 151, 'offset': 0},
    2: {'count': 100, 'offset': 151},
    3: {'count': 135, 'offset': 251},
    4: {'count': 107, 'offset': 386},
    5: {'count': 156, 'offset': 493},
    6: {'count': 72, 'offset': 649},
    7: {'count': 81, 'offset': 721},
    8: {'count': 89, 'offset': 802},
    9: {'count': 120, 'offset': 905},
  };

  Stream<PokedexProgress> getPokedex(int genNum) async* {
    final gen = Generation.fromNumber(genNum);
    if (gen == null) throw Exception('Gen must be between 1 and 9');

    Map<int, Map<String, dynamic>> result = {};
    int successCount = 0;
    int errorCount = 0;

    try {
      yield PokedexProgress(
        current: 0,
        total: gen.count,
        message: 'Fetching pokemon list...',
      );

      String uri = '${_url}pokemon?limit=${gen.count}&offset=${gen.offset}';
      final pokemonListRes = await http.get(Uri.parse(uri));

      if (pokemonListRes.statusCode != 200) {
        yield PokedexProgress(
          current: 0,
          total: 0,
          message:
              'Error: Unable to fetch pokemon list (HTTP ${pokemonListRes.statusCode})',
          hasError: true,
        );
        return;
      }

      final pokedexData = json.decode(pokemonListRes.body);
      final pokemonList = pokedexData['results'];

      for (int i = 0; i < pokemonList.length; i++) {
        var pokemon = pokemonList[i];

        yield PokedexProgress(
          current: i,
          total: gen.count,
          message: 'Loading ${pokemon['name']}...',
          successCount: successCount,
          errorCount: errorCount,
        );

        try {
          final pokemonRes = await http.get(Uri.parse(pokemon['url']));
          if (pokemonRes.statusCode == 200) {
            final pokemonData = json.decode(pokemonRes.body);
            result[pokemonData['id']] = pokemonData;
            successCount++;
          } else {
            debugPrint(
              'Failed to load ${pokemon['name']}: HTTP ${pokemonRes.statusCode}',
            );
            errorCount++;
          }
        } catch (e) {
          debugPrint('Failed to load ${pokemon['name']}');
          errorCount++;
        }
      }

      String finalMessage = errorCount > 0
          ? 'Completed with $successCount loaded pokemon and with $errorCount errors!'
          : 'All $successCount pokemon loaded!';

      yield PokedexProgress(
        current: pokemonList.length,
        total: pokemonList.length,
        message: finalMessage,
      );
    } catch (e) {
      yield PokedexProgress(
        current: 0,
        total: 0,
        message: 'Critical error: $e',
        hasError: true,
      );
    }
  }
}

enum Generation {
  gen1(1, count: 151, offset: 0),
  gen2(2, count: 100, offset: 151),
  gen3(3, count: 135, offset: 251),
  gen4(4, count: 107, offset: 386),
  gen5(5, count: 156, offset: 493),
  gen6(6, count: 72, offset: 649),
  gen7(7, count: 81, offset: 721),
  gen8(8, count: 89, offset: 802),
  gen9(9, count: 120, offset: 905);

  const Generation(this.number, {required this.count, required this.offset});

  final int number;
  final int count;
  final int offset;

  static const Map<int, Generation> _byNumber = {
    1: Generation.gen1,
    2: Generation.gen2,
    3: Generation.gen3,
    4: Generation.gen4,
    5: Generation.gen5,
    6: Generation.gen6,
    7: Generation.gen7,
    8: Generation.gen8,
    9: Generation.gen9,
  };

  static Generation? fromNumber(int number) => _byNumber[number];
}

final apiCall = ApiCall._apiCall;
