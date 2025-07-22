import 'package:async_wrapper/async_wrapper.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.brown.shade300,
      child: Row(
        children: [
          // AsyncWrapper(fetch: fetch, builder: builder)
        ],
      ),
    );
  }
}
