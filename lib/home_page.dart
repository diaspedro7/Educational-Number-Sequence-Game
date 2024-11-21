import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sequencia_numerica/dados_provider.dart';
import 'package:sequencia_numerica/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        GetBuilder<DadosController>(
            init: DadosController(),
            builder: (_) {
              return Center(
                child: GestureDetector(
                    onTap: () async {
                      _.gerarSequenciaNumerica();
                      await _.tornarBotoesVisiveis();
                      Navigator.pushReplacementNamed(context, '/jogo');
                    },
                    child: const botaoClashRoyale(
                        altBotao: 80, largBotao: 100, texto: 'Jogar')),
              );
            })
      ]),
    );
  }
}




//Navigator.pushReplacementNamed(context, '/jogo');
                      //                    Get.toNamed('/jogar');