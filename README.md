QUESTÕES:
1) Crie o aplicativo “terceira_prova” que deve funcionar para dispositivos Android ou iOS. Crie a
Widget TelaHome que configura um Widget MaterialApp. Crie um Widget TelaHome que deve
apresentar informações sobre o aplicativo. Adicione um ícone customizado para o aplicativo utilizando
o pacote flutter_launcher_icons (https://pub.dev/packages/flutter_launcher_icons) (0,5 ponto)
2) Defina a data class para guardar dados de Pokémons com base nas informações que podem ser
obtidas através da PokeAPI (https://pokeapi.co/). Crie pelo menos 6 atributos. Implemente o uso de
banco de dados utilizando a biblioteca SQFLITE através da biblioteca Floor (não será aceito o uso
de SQFLITE puro). Você deve implementar métodos para: criar, deletar, listar todos, listar por ID.
(1,0 pontos).
3) Implemente uma widget TelaCaptura e adicione um ListView. Verifique se há internet disponível
(use o pacote https://pub.dev/packages/connectivity_plus ). Caso não haja internet informe com uma
mensagem e não exiba a ListView. Caso haja internet sorteie 6 números de 0 até 1017. Obtenha os
dados de todos os Pokémons (https://pokeapi.co/api/v2/pokemon/), mas mantenha na lista apenas os
6 sorteados (ou crie uma lista com os sorteados). Use os dados dos Pokémons sorteados para
preencher os itens do ListView. Cada item do ListView deverá ter um botão para capturar o Pokémon.
Esse botão deve parecer uma Pokébola. Se o Pokémon já estiver capturado (veja a questão 4), o
botão de captura deve aparecer cinza e desativado. (2,0 pontos)
4) Implemente o botão Capturar Pokémon da widget TelaCaptura que deve salvar os dados do
Pokémon relacionado da ListView. Os dados dos Pokémons capturados devem ser salvos no banco
de dados local. (1,0 pontos)
5) Implemente uma widget TelaPokemonCapturado e adicione um ListView. Liste todos os Pokémons
capturados que estão cadastrados no banco de dados local. Caso não haja nenhum Pokémon
capturado ainda, crie uma Widget de Text informando essa condição. (1,0 ponto)
6) Adicione uma widget de GestureDetector nos ListItems da TelaPokemonCapturado para que com
um toque simples a aplicação navegue para o TelaDetalhesPokemon e com o toque longo a
aplicação navegue para o TelaSoltarPokemon. (1,0 ponto)
7) Crie uma widget chamada TelaDetalhesPokemon que recebe como parâmetro um ID e possui
Texts e Imagens com os dados do registro. Carregue os dados do através da API e do banco de
dados para mostrar informações completas sobre o Pokémon. (0,5 ponto)
8) Crie uma widget chamada TelaSoltarPokemon que recebe como parâmetro um ID e possui Texts e
Imagens com os dados do registro. Carregue os dados do banco de dados. Adicione dois botões,
uma para confirmar que o Pokémon será solto (delete do banco de dados local) e outro para
cancelar. (1,0 ponto)
9) Organize seu aplicativo com o menu sorteado para seu grupo. Crie acessos para TelaCaptura e
TelaPokemonCapturado.(1,5 ponto)
10) Crie uma widget chamada TelaSobre que mantem informações estáticas sobre os(as)
desenvolvedores(as) do aplicativo. Adicione aos Scaffolds do seu aplicativo