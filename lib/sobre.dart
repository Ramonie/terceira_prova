import 'package:flutter/material.dart';

class TelaSobre extends StatelessWidget {
  const TelaSobre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Desenvolvedores do Aplicativo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
               DesenvolvedorCard(
              nome: 'Luiz Felipe Henrique de Souza',
              cargo: 'Desenvolvedor',
              avatarUrl: 'https://avatars.githubusercontent.com/u/51883536?v=4',
               ),
            DesenvolvedorCard(
              nome: 'Ramonie Martins de Lima',
              cargo: 'Desenvolvedor',
              avatarUrl: 'https://avatars.githubusercontent.com/u/55808322?v=4',
            ),
            // Adicione mais cards conforme necessário
          ],
        ),
      ),
    );
  }
}

class DesenvolvedorCard extends StatelessWidget {
  final String nome;
  final String cargo;
  final String avatarUrl;

  const DesenvolvedorCard({
    Key? key,
    required this.nome,
    required this.cargo,
    required this.avatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(avatarUrl),
        ),
        title: Text(nome),
        subtitle: Text(cargo),
      ),
    );
  }
}
