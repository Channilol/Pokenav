class Pokemon {
  final String id;
  final String name;
  final List<Description> descriptions;
  final List<Type> types;
  final List<Evolution> evolutions;
  final String artwork;
  final Map<String, Sprite?> sprites;

  Pokemon({
    required this.id,
    required this.name,
    required this.descriptions,
    required this.types,
    required this.evolutions,
    required this.artwork,
    required this.sprites,
  });
}

class Sprite {
  final String frontDefault;
  final String frontShiny;
  final String? backDefault;
  final String? backShiny;

  Sprite({
    required this.frontDefault,
    required this.frontShiny,
    this.backDefault,
    this.backShiny,
  });
}

class Description {
  final int generation;
  final String description;

  Description({required this.generation, required this.description});
}

class Evolution {
  final int level;
  final String name;

  Evolution({required this.level, required this.name});
}
