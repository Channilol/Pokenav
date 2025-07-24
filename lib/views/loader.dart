import 'package:flutter/material.dart';
import 'package:pokenav/api_call.dart';
import 'package:pokenav/components/progress_stream.dart';

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => apiCall.pulisciCache(),
              child: const Text('Pulisci cache'),
            ),
            ProgressStream(generation: 1),
          ],
        ),
      ),
    );
  }
}
