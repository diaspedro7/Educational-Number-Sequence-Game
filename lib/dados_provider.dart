import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DadosController extends GetxController {
  List<String> listaNumeros = [];
  List<String> listaInicial = [];
  List<bool> listaBooleanaNumeros = [];
  List<String> listaOpcoesNumeros = [];
  List<String> gabarito = [];

  List<bool> visibilidadeOpcoesNumeros = [];

  void tornarBotoesVisiveis() {
    visibilidadeOpcoesNumeros =
        List.generate(listaOpcoesNumeros.length, (_) => true);

    update();
  }

  void gerarSequenciaNumerica() {
    //int numeroRandom = Random().nextInt(5) + 1;
    //debugPrint("NumeroRandom: $numeroRandom");
    // Define uma sequência correta de números (exemplo: 1 a 5)
    gabarito = List.generate(10, (index) => (index + 1).toString());

    // Gera uma cópia da sequência com números aleatórios removidos
    listaNumeros = List.from(gabarito);
    listaBooleanaNumeros = List.generate(gabarito.length, (index) => true);

    // Define a quantidade de números que serão escondidos
    int numerosParaRemover = Random().nextInt(7) + 3;
    List<int> indicesRemover = [];

    // Seleciona aleatoriamente os índices para esconder os números
    while (indicesRemover.length < numerosParaRemover) {
      int indice = Random().nextInt(listaNumeros.length);
      if (indice != 0 && indice != 9 && !indicesRemover.contains(indice)) {
        indicesRemover.add(indice);
        listaNumeros[indice] = '';
        listaBooleanaNumeros[indice] = false;
      }
    }

    // Gera a lista de opções (números que faltam na sequência)
    listaOpcoesNumeros =
        indicesRemover.map((index) => gabarito[index]).toList();
    listaOpcoesNumeros.shuffle(); // Embaralha as opções

    // Define a lista inicial para reset
    listaInicial = List.from(listaNumeros);

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
