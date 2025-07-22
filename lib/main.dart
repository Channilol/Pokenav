import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokenav/views/loader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: Pokenav()));
}

class Pokenav extends ConsumerStatefulWidget {
  const Pokenav({super.key});

  @override
  ConsumerState<Pokenav> createState() => _PokenavState();
}

class _PokenavState extends ConsumerState<Pokenav> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokenav',
      debugShowCheckedModeBanner: false,
      home: Loader(),
    );
  }
}
