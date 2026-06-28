import 'dart:async';

import 'package:flutter/material.dart';

import 'homePage.dart';

class PaginaAbertura extends StatefulWidget {
  const PaginaAbertura({super.key});

  @override
  State<PaginaAbertura> createState() => _EstadoPaginaAbertura();
}

class _EstadoPaginaAbertura extends State<PaginaAbertura> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const PaginaInicial()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud, size: 72, color: Colors.blue),
            SizedBox(height: 16),
            Text('WeatherApp', style: TextStyle(fontSize: 28)),
            SizedBox(height: 8),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
