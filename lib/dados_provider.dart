import 'dart:math';

import 'package:get/get.dart';

class DadosController extends GetxController {
  List<String> listaNumeros = [];
  List<String> listaInicial = [];
  List<bool> listaBooleanaNumeros = [];
  List<String> listaOpcoesNumeros = [];
  List<String> gabarito = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

  List<List<String>> listaPrePronta = [
    ['1', '', '3', '', '5', '6', '', '8', '', '10'], // Variação 1
    ['1', '2', '', '4', '', '6', '7', '', '9', '10'], // Variação 2
    ['1', '', '3', '4', '', '6', '', '8', '', '10'], // Variação 3
    ['1', '2', '', '', '5', '6', '', '8', '', '10'], // Variação 4
    ['1', '', '3', '', '', '6', '7', '', '9', '10'], // Variação 5
    ['1', '2', '', '', '', '6', '7', '8', '', '10'], // Variação 6
    ['1', '', '3', '', '5', '6', '7', '', '', '10'], // Variação 7
    ['1', '', '3', '', '', '6', '', '8', '', '10'], // Variação 8
    ['', '2', '', '4', '', '6', '7', '', '9', '10'], // Variação 9
    ['1', '', '3', '', '5', '', '7', '8', '', '10'], // Variação 10
    ['', '2', '3', '', '', '6', '', '8', '9', '10'], // Variação 11
    ['1', '2', '', '', '5', '', '7', '8', '', '10'], // Variação 12
    ['1', '', '3', '', '5', '6', '', '', '9', '10'], // Variação 13
    ['1', '', '3', '', '', '6', '7', '', '', '10'], // Variação 14
    ['1', '2', '', '', '5', '', '', '8', '9', '10'], // Variação 15
    ['', '2', '3', '4', '', '6', '', '', '9', '10'], // Variação 16
    ['1', '', '', '4', '', '6', '7', '', '9', '10'], // Variação 17
    ['1', '2', '', '4', '', '6', '', '8', '', '10'], // Variação 18
    ['1', '', '', '', '5', '6', '7', '', '9', '10'], // Variação 19
    ['', '', '3', '4', '', '6', '', '8', '9', '10'], // Variação 20
  ];

  List<bool> visibilidadeOpcoesNumeros = [];

  bool isLoading = false;

  tornarBotoesVisiveis() {
    visibilidadeOpcoesNumeros =
        List.generate(listaOpcoesNumeros.length, (_) => true);

    update();
  }

  // void gerarSequenciaNumerica() {
  //   //int numeroRandom = Random().nextInt(5) + 1;
  //   //debugPrint("NumeroRandom: $numeroRandom");
  //   // Define uma sequência correta de números (exemplo: 1 a 5)
  //   gabarito = List.generate(10, (index) => (index + 1).toString());

  //   // Gera uma cópia da sequência com números aleatórios removidos
  //   listaNumeros = List.from(gabarito);
  //   listaBooleanaNumeros = List.generate(gabarito.length, (index) => true);

  //   // Define a quantidade de números que serão escondidos
  //   int numerosParaRemover = Random().nextInt(7) + 3;
  //   Set<int> indicesRemover = [];

  //   // Seleciona aleatoriamente os índices para esconder os números
  //   while (indicesRemover.length < numerosParaRemover) {
  //     int indice = Random().nextInt(listaNumeros.length);
  //     if (indice != 0 && indice != 9 && !indicesRemover.contains(indice)) {
  //       indicesRemover.add(indice);
  //       listaNumeros[indice] = '';
  //       listaBooleanaNumeros[indice] = false;
  //     }
  //   }

  //   // Gera a lista de opções (números que faltam na sequência)
  //   listaOpcoesNumeros =
  //       indicesRemover.map((index) => gabarito[index]).toList();
  //   listaOpcoesNumeros.shuffle(); // Embaralha as opções

  //   // Define a lista inicial para reset
  //   listaInicial = List.from(listaNumeros);

  //   update();
  // }

  gerarSequenciaNumerica() {
    int indiceAleatorio = Random().nextInt(listaPrePronta.length);
    listaNumeros = List.from(listaPrePronta[indiceAleatorio]);

    listaBooleanaNumeros =
        listaNumeros.map((numero) => numero.isNotEmpty).toList();

    listaOpcoesNumeros = gabarito
        .asMap()
        .entries
        .where((entry) => listaNumeros[entry.key].isEmpty)
        .map((entry) => entry.value)
        .toList()
      ..shuffle();

    // Salva a lista inicial para possível reset
    listaInicial = List.from(listaNumeros);

    // Atualiza a interface
    update();
  }

  void atribuirValorBotao(int index, String data) {
    listaNumeros[index] = data;
    update();
  }

  void resetarValorBotao(int index) {
    listaNumeros[index] = '';
    update();
  }

  void resetarLista() {
    listaNumeros = List.from(listaInicial);
    update();
  }

  void trocarBoolVisibilidadeNumeros(int index, bool valor) {
    visibilidadeOpcoesNumeros[index] = valor;
    update();
  }
}
