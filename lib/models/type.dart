class Type {
  final String id;
  final String name;
  final List<Type> immunity;
  final List<Type> resistances;
  final List<Type> effectiveness;
  final List<Type> superEffectiveness;

  Type({
    required this.id,
    required this.name,
    required this.immunity,
    required this.resistances,
    required this.effectiveness,
    required this.superEffectiveness,
  });
}
