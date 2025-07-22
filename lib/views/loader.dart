import 'package:flutter/material.dart';
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
      body: ProgressStream(generation: 1),
      // AsyncWrapper(
      //   fetch: () => apiCall.getPokedex(1),
      //   autorun: true,
      //   builder: (fetch, state) {
      //     if (state.isPending) return CircularProgressIndicator.adaptive();
      //     if (state.isError) return Text(state.error.toString());
      //     if (state.isSuccess) return const Dashboard();
      //     return const Placeholder();
      //   },
      // ),
    );
  }
}
