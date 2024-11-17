// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
      .then((_) {
    runApp(const MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int numeroEscolhido = 0;
  List<String> listaNumeros = [];
  List<String> listaInicial = [];
  List<bool> listaBooleanaNumeros = [];
  List<String> listaOpcoesNumeros = [];
  List<String> gabarito = [];

  List<bool> visibilidadeOpcoesNumeros = [];

  late ConfettiController _confettiController;
  bool botaoLevantado = false;

  final double altBotao = 90.0;
  final double largBotao = 200.0;

  // void updateNumeroEscolhido() {
  //   while (listaNumeros[numeroEscolhido] != '' &&
  //       numeroEscolhido < listaNumeros.length - 1 &&
  //       listaNumeros.contains('')) {
  //     setState(() {
  //       numeroEscolhido =
  //           (numeroEscolhido + 1) % (listaNumeros.length - 1); //soma circular
  //     });
  //   }
  // }

  // void updateNumeroEscolhido() {
  //   setState(() {
  //     do {
  //       debugPrint("Dentro do loop");
  //       numeroEscolhido = (numeroEscolhido + 1) % (listaNumeros.length - 1);
  //     } while (numeroEscolhido < listaNumeros.length &&
  //         listaNumeros[numeroEscolhido] != '');
  //   });
  // }

  void updateNumeroEscolhido() {
    int proximoNumero = numeroEscolhido;
    // Avança para o próximo índice vazio, se existir.
    for (int i = 0; i < listaNumeros.length; i++) {
      debugPrint("Dentro do loop");
      proximoNumero = (proximoNumero + 1) % listaNumeros.length;
      if (listaNumeros[proximoNumero] == '') {
        break;
      }
    }
    setState(() {
      numeroEscolhido = proximoNumero;
    });
  }

  @override
  void initState() {
    super.initState();
    gerarSequenciaNumerica();
    // Inicializa a lista de visibilidade com todos os itens visíveis
    tornarBotoesVisiveis();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void tornarBotoesVisiveis() {
    visibilidadeOpcoesNumeros =
        List.generate(listaOpcoesNumeros.length, (_) => true);
  }

  void gerarSequenciaNumerica() {
    setState(() {
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
        if (indice != 0 && !indicesRemover.contains(indice)) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 573,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: [
                        Wrap(
                          spacing: 5,
                          alignment: WrapAlignment.center,
                          children: List.generate(
                            3,
                            (index) => quadradoSelecionado(index),
                          ),
                        ),
                        Wrap(
                          spacing: 5,
                          alignment: WrapAlignment.center,
                          children: List.generate(
                            3,
                            (index) => quadradoSelecionado(index + 3),
                          ),
                        ),
                        Wrap(
                          spacing: 5,
                          alignment: WrapAlignment.center,
                          children: List.generate(
                            3,
                            (index) => quadradoSelecionado(index + 6),
                          ),
                        ),
                        Wrap(
                          spacing: 5,
                          alignment: WrapAlignment.center,
                          children: List.generate(
                            1,
                            (index) => quadradoSelecionado(index + 9),
                          ),
                        ),
                      ],
                    )),
              ],
            ),

            SizedBox(
                height: 140,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: List.generate(
                        listaOpcoesNumeros.length,
                        (index) => quadradoOpcoesNumeros(index),
                      ),
                    ),
                  ],
                )),
            // GestureDetector(
            //     onTapDown: (TapDownDetails details) {
            //       setState(() {
            //         botaoLevantado = true;
            //       });
            //     },
            //     onTapUp: (TapUpDetails details) {
            //       setState(() {
            //         botaoLevantado = false;
            //       });
            //     },
            //     onTap: () async {
            //       if (listEquals(gabarito, listaNumeros)) {
            //         debugPrint("Parabéns você venceu!!");
            //         _confettiController.play();
            //         await Future.delayed(Duration(milliseconds: 500));

            //         gerarSequenciaNumerica();
            //         tornarBotoesVisiveis();
            //       } else {
            //         debugPrint("Ops, você errou!");
            //         setState(() {
            //           listaNumeros = List.from(listaInicial);
            //         });
            //         debugPrint(listaNumeros.toString());
            //       }
            //     },
            //     child: botaoClashRoyale(altBotao: altBotao, largBotao: largBotao)
            //         .animate(
            //           target: botaoLevantado ? 1 : 0,
            //           onPlay: (controller) => controller.repeat(),
            //         )
            //         .scaleXY(
            //             curve: Curves.linear,
            //             duration: Duration(milliseconds: 130),
            //             begin: 1.0,
            //             end: 0.9)),
          ]),
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 30,
              emissionFrequency: 0.05,
              gravity: 0.1,
            ),
          ),
        ]));
  }

  Widget quadradoSelecionado(int numero) {
    return DragTarget<String>(
      onAcceptWithDetails: (valor) {
        if (listaBooleanaNumeros[numero] == false) {
          setState(() {
            listaNumeros[numero] = valor.data;
          });
        }
        debugPrint("ListaNumeros: ${listaNumeros.toString()}");
      },
      builder: (context, candidateData, rejectedData) {
        return listaNumeros[numero] != '' &&
                listaBooleanaNumeros[numero] == false
            ? Draggable<String>(
                data: listaNumeros[numero],
                onDragCompleted: () {
                  setState(() {
                    listaNumeros[numero] = '';
                  });
                },
                feedback: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color.fromARGB(255, 255, 76, 136),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      listaNumeros[numero],
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ),
                childWhenDragging: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: listaBooleanaNumeros[numero] == false
                          ? Color.fromARGB(255, 255, 76, 136)
                          : Color.fromARGB(255, 56, 8, 159),
                      width: 2,
                    ),
                  ),
                ),
                child: SizedBox(
                  height: 143,
                  width: listaNumeros[numero] != '10' ? 70 : 150,
                  child: Center(
                    child: Text(
                      listaNumeros[numero],
                      style:
                          TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ) //Ele parado por padrão
            : SizedBox(
                height: 143,
                width: listaNumeros[numero] != '10' ? 70 : 150,
                child: listaNumeros[numero] != ''
                    ? Center(
                        child: Text(
                          listaNumeros[numero],
                          style: TextStyle(
                              fontSize: 100, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Center(
                        child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle),
                      )),
              );
      },
    );
  }

  Widget quadradoOpcoesNumeros(int numero) {
    return Visibility(
      visible: listaNumeros.contains(listaOpcoesNumeros[numero]) ? false : true,
      child: Draggable<String>(
        data: listaOpcoesNumeros[numero],
        onDragStarted: () {
          setState(() {
            visibilidadeOpcoesNumeros[numero] = false;
          });
        },
        onDraggableCanceled: (_, __) {
          setState(() {
            visibilidadeOpcoesNumeros[numero] = true;
          });
        },
        onDragCompleted: () {
          setState(() {
            visibilidadeOpcoesNumeros[numero] = true;
          });
        },
        feedback: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: const Color.fromARGB(255, 255, 76, 136), width: 2)),
          child: Center(
            child: Text(
              listaOpcoesNumeros[numero],
              //numeroString,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration.none),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        child: Visibility(
          visible: visibilidadeOpcoesNumeros[numero],
          child: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: const Color.fromARGB(255, 255, 76, 136), width: 2)),
            child: Center(
              child: Text(
                listaOpcoesNumeros[numero],
                //numeroString,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class botaoClashRoyale extends StatelessWidget {
  const botaoClashRoyale({
    super.key,
    required this.altBotao,
    required this.largBotao,
  });

  final double altBotao;
  final double largBotao;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: altBotao,
      width: largBotao,
      decoration: BoxDecoration(
        color: Color.fromARGB(239, 254, 25, 29),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Color.fromARGB(238, 185, 17, 20),
              offset: Offset(0, 4),
              spreadRadius: 1.5,
              blurStyle: BlurStyle.solid)
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: altBotao - 15,
            width: 185,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 254, 25, 28),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(0, 2),
                      blurRadius: 1,
                      spreadRadius: 0.3)
                ]),
            child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: altBotao / 2,
                  width: largBotao - 15,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 135, 126)
                        .withOpacity(0.7),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(4),
                          )),
                    ),
                  ),
                )),
          ),
          Text(
            "Responder",
            style: TextStyle(
              fontSize: 30,
              // color: Colors.white,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2
                ..color = Colors.black,
            ),
          ),
          Text(
            "Responder",
            style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(-1, 2),
                    blurRadius: 1.0,
                  ),
                  Shadow(
                    color: Colors.black,
                    offset: Offset(-1.5, 2.5),
                    blurRadius: 1.0,
                  )
                ]),
          )
        ],
      ),
    );
  }
}


// if (listEquals(gabarito, listaNumeros)) {
//                         debugPrint("Parabéns você venceu!!");
//                         _confettiController.play();
//                         await Future.delayed(Duration(milliseconds: 500));

//                         gerarSequenciaNumerica();
//                         tornarBotoesVisiveis();
//                       } else {
//                         debugPrint("Ops, você errou!");
//                         setState(() {
//                           listaNumeros = List.from(listaInicial);
//                         });
//                         debugPrint(listaNumeros.toString());
//                       }


// Stack(
//                       children: [
//                         Text(
//                           "Responder",
//                           style: TextStyle(
//                             fontSize: 30,
//                             // color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             foreground: Paint()
//                               ..style = PaintingStyle.stroke
//                               ..strokeWidth = 1
//                               ..color = Colors.black,
//                           ),
//                         ),
//                         Text(
//                           "Responder",
//                           style: TextStyle(
//                               fontSize: 30,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               shadows: [
//                                 Shadow(
//                                   color: Colors.black,
//                                   offset: Offset(-1, 2),
//                                   blurRadius: 1.0,
//                                 )
//                               ]),
//                         )
//                       ],
//                     ),



