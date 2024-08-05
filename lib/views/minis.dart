import 'package:flutter/material.dart';

class ListOfChips extends StatelessWidget {
  final Future<List<String>> future;
  const ListOfChips({super.key, required this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          } else if (snapshot.hasData) {
            final List<String> names = snapshot.data as List<String>;
            return ListView.builder(
              itemCount: names.length,
              prototypeItem: Chip(
                label: Text(names.first),
              ),
              itemBuilder: (context, index) {
                return Chip(
                  label: Text(names[index]),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No data available'),
            );
          }
        });
  }
}
