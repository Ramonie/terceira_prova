import 'package:flutter/material.dart';

class TelaSobre extends StatelessWidget {
  const TelaSobre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Desenvolvedores:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildDesenvolvedor(
              nome: 'Luiz Felipe Henrique de Souza',
              papel: 'Bombril',
              imagemUrl: 'https://avatars.githubusercontent.com/u/51883536?v=4', // Substitua pela URL da imagem do Pokémon
            ),
            _buildDesenvolvedor(
              nome: 'Ramonie Martins de Lima',
              papel: 'Bombril',
              imagemUrl: 'https://avatars.githubusercontent.com/u/55808322?v=4', // Substitua pela URL da imagem do Pokémon
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesenvolvedor({
    required String nome,
    required String papel,
    required String imagemUrl,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(imagemUrl),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nome: $nome',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Função: $papel',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TelaSobre(),
  ));
}
