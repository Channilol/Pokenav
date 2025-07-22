import 'package:flutter/material.dart';
import 'package:pokenav/api_call.dart';

class ProgressStream extends StatelessWidget {
  final int generation;
  const ProgressStream({super.key, required this.generation});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: apiCall.getPokedex(1),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Column(
              spacing: 16,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                ),
                Text('Iniziando la fetch dati...'),
              ],
            ),
          );
        }

        final progress = snapshot.data!;

        return Center(
          child: Column(
            spacing: 32,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Caricando la $generation generazione',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: 500,
                child: LinearProgressIndicator(
                  value: progress.progress,
                  backgroundColor: Colors.blueGrey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  minHeight: 8,
                ),
              ),
              Text('${progress.current}/${progress.total}'),
              Text('${(progress.progress * 100).toStringAsFixed(1)}%'),
              Text(progress.message),
            ],
          ),
        );
      },
    );
  }
}
