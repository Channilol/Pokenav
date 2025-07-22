import 'package:flutter_riverpod/legacy.dart';

class ProviderPokedex extends StateNotifier<Map<String, dynamic>> {
  ProviderPokedex() : super({});

  void setPokedex({String? genId}) {}
}

final pokedexProvider =
    StateNotifierProvider<ProviderPokedex, Map<String, dynamic>>((ref) {
      return ProviderPokedex();
    });
