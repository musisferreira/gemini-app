import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Gemini'), centerTitle: true),
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.pink,
              child: Icon(Icons.person_outline),
            ),
            title: const Text('Prompt básico a Gemini'),
            subtitle: const Text('Usando um modelo de Flash'),
            onTap: () => context.push('/basic-prompt'),
          ),
        ],
      ),
    );
  }
}
