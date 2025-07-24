class PokedexProgress {
  final int current;
  final int total;
  final String message;
  final String? image;
  final Map<int, Map<String, dynamic>>? data;
  final bool hasError;
  final int successCount;
  final int errorCount;

  PokedexProgress({
    required this.current,
    required this.total,
    required this.message,
    this.image,
    this.data,
    this.hasError = false,
    this.successCount = 0,
    this.errorCount = 0,
  });

  double get progress => total > 0 ? current / total : 0;
  bool get isComplete => current == total && data != null && !hasError;
  bool get hasPartialErrors => errorCount > 0 && !hasError;
}
