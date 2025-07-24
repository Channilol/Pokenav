import 'package:flutter/material.dart';
import 'package:pokenav/api_call.dart';
import 'package:pokenav/components/animated_pokenav.dart';

class ProgressStream extends StatelessWidget {
  const ProgressStream({super.key, required this.generation, this.callback});
  final int generation;
  final Function? callback;

  @override
  Widget build(BuildContext context) {
    if (callback == 100) {
      Future.delayed(const Duration(seconds: 2), () => callback!());
    }
    return StreamBuilder(
      stream: apiCall.getGen(generation),
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
                Text('Trying to fetch data...'),
              ],
            ),
          );
        }

        final progress = snapshot.data!;

        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedPokenav(
                loadingPercent: double.parse(
                  (progress.progress * 100).toStringAsFixed(1),
                ),
              ),
              Expanded(
                child: Column(
                  spacing: 32,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Caricando la $generation generazione',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      width: 300,
                      child: LinearProgressIndicator(
                        value: progress.progress,
                        backgroundColor: Colors.blueGrey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        minHeight: 12,
                      ),
                    ),
                    Text('${(progress.progress * 100).toStringAsFixed(1)}%'),
                    Text(progress.message),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
