import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:pokenav/models/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiCall {
  // Singleton
  static final ApiCall _apiCall = ApiCall._private();
  ApiCall._private();

  // Url base API
  final _url = 'https://pokeapi.co/api/v2/';

  // Mappa generazioni
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

  //* Salva in cache - VERSIONE CORRETTA
  Future<void> salvaInCache(
    int generazione,
    Map<int, Map<String, dynamic>> datiPkmn,
  ) async {
    try {
      // Ottengo istanza di SharedPreferences
      final prefs = await SharedPreferences.getInstance();

      // IMPORTANTE: Creiamo una nuova Map con chiavi String
      Map<String, dynamic> datiConChiaviString = {};

      // Convertiamo ogni entry
      datiPkmn.forEach((id, pokemon) {
        // Converti la chiave da int a String
        Map<String, dynamic> filteredPkmn = {};
        pokemon.forEach((key, value) {
          if (key != 'moves') {
            filteredPkmn[key] = value;
          }
        });
        datiConChiaviString[id.toString()] = filteredPkmn;
      });

      // ORA possiamo fare jsonEncode senza errori
      String datiJson = jsonEncode(datiConChiaviString);

      // Salvo la gen come chiave univoca
      String key = 'gen$generazione';
      await prefs.setString(key, datiJson);

      debugPrint('✅ Dati $key salvati in cache');
      debugPrint(
        '💾 Dimensione cache: ${(datiJson.length / 1024).toStringAsFixed(1)} KB',
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Errore nel salvare la cache: $e');
      debugPrint('📍 Stack trace: $stackTrace');
    }
  }

  //* Leggi da cache
  Future<Map<int, Map<String, dynamic>>?> leggiCache({int? gen}) async {
    // Ottengo l'istanza di SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Se gen é nullo leggo tutta la cache
    if (gen == null) {
      String gensJson = '';
      for (var i = 0; i < pokedex.entries.last.key; i++) {
        gensJson += prefs.getString('gen$i') ?? '';
      }

      if (gensJson == '') {
        debugPrint('Nessuna generazione trovata salvata nella cache');
        return null;
      }
    }

    // Leggo i dati per capire se c'é la gen salvata
    String? datiJson = prefs.getString('gen$gen');

    // Se non ci sono dati, ritorna null
    if (datiJson == null) {
      debugPrint('Dati gen$gen non trovati in cache');
      return null;
    }

    // Se ci sono, facciamo il jsonDecode
    try {
      Map<String, dynamic> dati = jsonDecode(datiJson);

      Map<int, Map<String, dynamic>> result = {};
      dati.forEach((key, value) {
        result[int.parse(key)] = Map<String, dynamic>.from(value);
      });
      debugPrint('Dati gen$gen trovati in cache');
      return result;
    } catch (e) {
      debugPrint('Dati gen$gen non trovati in cache');
      return null;
    }
  }

  // Pulisci cache in base alla gen (se é nulla pulisci tutto)
  Future<void> pulisciCache([int? gen]) async {
    final prefs = await SharedPreferences.getInstance();
    if (gen != null) {
      String key = 'gen$gen';
      await prefs.remove(key);
    } else {
      for (int i = 0; i < pokedex.entries.length; i++) {
        await prefs.remove('gen${i + 1}');
      }
    }
  }

  // Check se esiste la cache
  Future<bool> checkCache(int gen) async {
    final prefs = await SharedPreferences.getInstance();
    String key = 'gen$gen';
    return prefs.containsKey(key);
  }

  // Stream generazioni
  Stream<PokedexProgress> getGen(int genNum) async* {
    final gen = Generation.fromNumber(genNum);
    if (gen == null) throw Exception('Gen must be between 1 and 9');

    Map<int, Map<String, dynamic>> result = {};
    int successCount = 0;
    int errorCount = 0;

    try {
      debugPrint('Controllo la cache per la gen$genNum');
      Map<int, Map<String, dynamic>>? datiCache = await leggiCache(gen: genNum);

      if (datiCache != null && datiCache.length == gen.count) {
        debugPrint('Dati gen$genNum NON CORROTTI trovati in cache');
        debugPrint('Inizio caricamento dati dalla cache');

        yield PokedexProgress(
          current: 0,
          total: gen.count,
          message: 'Loading pokemon list from cache...',
        );

        int loaded = 0;

        for (var entry in datiCache.entries) {
          result[entry.key] = entry.value;
          loaded++;

          if (loaded % 5 == 0 || loaded == datiCache.length) {
            yield PokedexProgress(
              current: loaded,
              total: gen.count,
              message: 'Fast loading $loaded/${gen.count}',
            );

            await Future.delayed(Duration(milliseconds: 50));
          }
        }

        yield PokedexProgress(
          current: gen.count,
          total: gen.count,
          message: 'Caricato dalla cache! ⚡',
          successCount: gen.count,
        );

        return;
      } else if (datiCache != null && datiCache.length != gen.count) {
        debugPrint('Dati gen$genNum CORROTTI trovati in cache!!');
      }

      debugPrint('Dati in cache non trovati, scarico da internet');

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

        try {
          final pokemonRes = await http.get(Uri.parse(pokemon['url']));
          if (pokemonRes.statusCode == 200) {
            final pokemonData = json.decode(pokemonRes.body);
            result[pokemonData['id']] = pokemonData;
            yield PokedexProgress(
              current: i,
              total: gen.count,
              message: 'Loading ${pokemonData['name']}...',
              image: pokemonData['sprites']?['front_default'] ?? 'no data',
              successCount: successCount,
              errorCount: errorCount,
            );
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

      if (errorCount == 0 && result.length == gen.count) {
        await salvaInCache(genNum, result);
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
