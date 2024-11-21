import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:sequencia_numerica/dados_provider.dart';
import 'package:sequencia_numerica/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(DadosController());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
      '/jogo': (context) => const GamePage(),
      '/home': (context) => const HomePage(),
    }, debugShowCheckedModeBanner: false, home: const HomePage());
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  //late DadosController _dadosController;

  late ConfettiController _confettiController;
  bool botaoLevantado = false;

  final double altBotao = 90.0;
  final double largBotao = 200.0;

  final Color corEscura = Colors.lightBlue.shade400;
  final Color corFundo = Colors.white;
  final Color corTexto = Colors.black;
  //final Color corTexto = Colors.lightBlue.shade400;

  @override
  void initState() {
    super.initState();

    // _dadosController = Get.find<DadosController>();
    // _dadosController.gerarSequenciaNumerica();
    // _dadosController.tornarBotoesVisiveis();

    // gerarSequenciaNumerica();
    // // Inicializa a lista de visibilidade com todos os itens visíveis
    // tornarBotoesVisiveis();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  // @override
  // void dispose() {
  //   _confettiController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DadosController>(
        init: DadosController(),
        builder: (_) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: Stack(children: [
                Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    'assets/background_app.png',
                    fit: BoxFit.cover, // Garante que a imagem cubra o fundo
                    width: double.infinity, // Preenche a largura
                    height: double.infinity, // Preenche a altura
                  ),
                ),
                SafeArea(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 80),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Wrap(
                                      spacing: 5,
                                      alignment: WrapAlignment.center,
                                      children: List.generate(
                                        5,
                                        (index) => quadradoSelecionado(index),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Wrap(
                                      spacing: 5,
                                      alignment: WrapAlignment.center,
                                      children: List.generate(
                                        5,
                                        (index) =>
                                            quadradoSelecionado(index + 5),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 120),
                            Column(
                              children: [
                                Wrap(
                                  spacing: 5,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                    _.listaOpcoesNumeros.length,
                                    (index) => quadradoOpcoesNumeros(index),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                            onTapDown: (TapDownDetails details) {
                              setState(() {
                                botaoLevantado = true;
                              });
                            },
                            onTapUp: (TapUpDetails details) {
                              setState(() {
                                botaoLevantado = false;
                              });
                            },
                            onTap: () async {
                              debugPrint("Apertou o botão");
                              try {
                                if (listEquals(_.gabarito, _.listaNumeros)) {
                                  debugPrint("Parabéns você venceu!!");
                                  debugPrint("Sequência correta detectada!");

                                  _confettiController.play();

                                  debugPrint("Iniciando nova sequência");

                                  _.gerarSequenciaNumerica();

                                  debugPrint("Passou do sufoco ja");
                                  _.tornarBotoesVisiveis();
                                } else {
                                  debugPrint("Ops, você errou!");
                                  _.resetarLista();
                                  debugPrint(_.listaNumeros.toString());
                                }
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              )
                                  .animate(
                                    target: botaoLevantado ? 1 : 0,
                                    onPlay: (controller) => controller.repeat(),
                                  )
                                  .scaleXY(
                                      curve: Curves.linear,
                                      duration:
                                          const Duration(milliseconds: 90),
                                      begin: 1.0,
                                      end: 0.9),
                            )),
                      ]),
                ),
                Align(
                  alignment: Alignment.center,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    numberOfParticles: 30,
                    emissionFrequency: 0.01,
                    gravity: 0.4,
                    maxBlastForce: 30,
                    minBlastForce: 10,
                  ),
                ),
              ]));
        });
  }

  Widget quadradoSelecionado(int numero) {
    return GetBuilder<DadosController>(
        init: DadosController(),
        builder: (_) {
          return DragTarget<String>(
            onAcceptWithDetails: (valor) {
              if (_.listaBooleanaNumeros[numero] == false) {
                _.atribuirValorBotao(numero, valor.data);
              }
              debugPrint("ListaNumeros: ${_.listaNumeros.toString()}");
            },
            builder: (context, candidateData, rejectedData) {
              return _.listaNumeros[numero] != '' &&
                      _.listaBooleanaNumeros[numero] == false
                  ? Draggable<String>(
                      data: _.listaNumeros[numero],
                      onDragCompleted: () {
                        _.resetarValorBotao(numero);
                      },
                      feedback: Container(
                          height:
                              80, //Eu diminui o tamanho, para dar efeito. O tam original era 100
                          width: 50, //O tam original era 60
                          decoration: BoxDecoration(
                              color: corFundo,
                              borderRadius: BorderRadius.circular(7),
                              boxShadow: [
                                BoxShadow(
                                  color: corEscura,

                                  offset: const Offset(3, 4),
                                  spreadRadius: 3.5,
                                  // blurStyle: BlurStyle.solid
                                ),
                                BoxShadow(
                                  color: corEscura,

                                  offset: const Offset(-1, -1),
                                  spreadRadius: 2,
                                  // blurStyle: BlurStyle.solid
                                ),
                              ]),
                          child: Center(
                            child: Text(
                              _.listaNumeros[numero],
                              style: estiloTexto(corTexto),
                              textAlign: TextAlign.center,
                            ),
                          )),
                      //Como fica o widget debaixo quando eu estou arrastando ele
                      childWhenDragging: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          child: Container(
                            height: 100,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade800.withOpacity(0.5),
                                shape: BoxShape.circle),
                          ),
                        ),
                      ),
                      //Ele parado apos ter botado um numero
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                            height: 100,
                            width: 60,
                            decoration: BoxDecoration(
                                color: corFundo,
                                borderRadius: BorderRadius.circular(7),
                                boxShadow: [
                                  BoxShadow(
                                    color: corEscura,
                                    offset: const Offset(3, 4),
                                    spreadRadius: 3.5,
                                    // blurStyle: BlurStyle.solid
                                  ),
                                  BoxShadow(
                                    color: corEscura,

                                    offset: const Offset(-1, -1),
                                    spreadRadius: 2,
                                    // blurStyle: BlurStyle.solid
                                  ),
                                ]),
                            child: Center(
                              child: Text(
                                _.listaNumeros[numero],
                                style: estiloTexto(corTexto),
                                textAlign: TextAlign.center,
                              ),
                            )),
                      ),
                    )

                  //Quadrado ja estabelecidos por padrao
                  : _.listaNumeros[numero] != ''
                      ? Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                              height: 100,
                              width: 60,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black,
                                      offset: Offset(3, 4),
                                      spreadRadius: 3.5,
                                      // blurStyle: BlurStyle.solid
                                    ),
                                    BoxShadow(
                                      color: Colors.black,

                                      offset: Offset(-1, -1),
                                      spreadRadius: 2,
                                      // blurStyle: BlurStyle.solid
                                    ),
                                  ]),
                              child: Center(
                                child: Text(
                                  _.listaNumeros[numero],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SizedBox(
                            child: Container(
                              height: 100,
                              width: 60,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade800.withOpacity(0.5),
                                  shape: BoxShape.circle),
                            ),
                          ),
                        );
            },
          );
        });
  }

  Widget quadradoOpcoesNumeros(int numero) {
    return GetBuilder<DadosController>(
        init: DadosController(),
        builder: (_) {
          return Visibility(
            visible: _.listaNumeros.contains(_.listaOpcoesNumeros[numero])
                ? false
                : true,
            child: Draggable<String>(
              data: _.listaOpcoesNumeros[numero],
              onDragStarted: () {
                _.trocarBoolVisibilidadeNumeros(numero, false);
              },
              onDraggableCanceled: (velocity, __) {
                _.trocarBoolVisibilidadeNumeros(numero, true);
              },
              onDragCompleted: () {
                _.trocarBoolVisibilidadeNumeros(numero, true);
              },
              feedback: Container(
                  height: 80,
                  width: 50,
                  decoration: BoxDecoration(
                      color: corFundo,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                          color: corEscura,
                          offset: const Offset(3, 4),
                          spreadRadius: 3.5,
                          // blurStyle: BlurStyle.solid
                        ),
                        BoxShadow(
                          color: corEscura,
                          offset: const Offset(-1, -1),
                          spreadRadius: 2,
                          // blurStyle: BlurStyle.solid
                        ),
                      ]),
                  child: Center(
                    child: Text(
                      _.listaOpcoesNumeros[numero],
                      style: estiloTexto(corTexto),
                      textAlign: TextAlign.center,
                    ),
                  )),
              child: Visibility(
                  visible: _.visibilidadeOpcoesNumeros[numero],
                  child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                          height: 100,
                          width: 60,
                          decoration: BoxDecoration(
                              color: corFundo,
                              borderRadius: BorderRadius.circular(7),
                              boxShadow: [
                                BoxShadow(
                                  color: corEscura,

                                  offset: const Offset(3, 4),
                                  spreadRadius: 3.5,
                                  // blurStyle: BlurStyle.solid
                                ),
                                BoxShadow(
                                  color: corEscura,

                                  offset: const Offset(-1, -1),
                                  spreadRadius: 2,
                                  // blurStyle: BlurStyle.solid
                                ),
                              ]),
                          child: Center(
                            child: Text(
                              _.listaOpcoesNumeros[numero],
                              style: estiloTexto(corTexto),
                              textAlign: TextAlign.center,
                            ),
                          )))),
            ),
          );
        });
  }
}

TextStyle estiloTexto(Color corTexto) {
  return TextStyle(
      color: corTexto,
      fontSize: 50,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none,
      shadows: const [
        // Shadow(
        //   color: Colors.black,
        //   offset: Offset(1, 7),
        // ),
        // Shadow(
        //   color: Colors.black,
        //   offset: Offset(1, 5),
        // ),
      ]);
}

// ignore: camel_case_types
class botaoClashRoyale extends StatelessWidget {
  const botaoClashRoyale({
    super.key,
    required this.altBotao,
    required this.largBotao,
    required this.texto,
  });

  final double altBotao;
  final double largBotao;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: altBotao,
      width: largBotao,
      decoration: BoxDecoration(
        color: const Color.fromARGB(239, 254, 25, 29),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
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
                color: const Color.fromARGB(255, 254, 25, 28),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 2),
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
                    borderRadius: const BorderRadius.only(
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
                          borderRadius: const BorderRadius.only(
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
            texto,
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
            texto,
            style: const TextStyle(
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