import 'package:flutter/cupertino.dart';
import 'package:pokenav/api_call.dart';
import 'package:pokenav/models/progress.dart';

class MessageDisplay extends StatelessWidget {
  final int generation;
  const MessageDisplay({Key? key, required this.generation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PokedexProgress>(
      stream: apiCall.getPokedex(generation),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text('Aspettando il primo messaggio...'));
        }

        final progress = snapshot.data!;

        return Center(
          child: Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Text(progress.message, style: TextStyle(fontSize: 16)),
          ),
        );
      },
    );
  }
}
