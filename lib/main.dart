import 'dart:io';

import 'package:calculadora_imc/models/datarows.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import "package:path_provider/path_provider.dart" as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory documentsDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(documentsDirectory.path);
  await Hive.openBox("dataBox");
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late FocusNode inputPeso;
  late FocusNode inputAltura;
  double? _peso;
  double? _altura;

  Datarows datarows = Datarows("");

  @override
  void initState() {
    super.initState();
    inputPeso = FocusNode();
    inputAltura = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    // Clean up the focus node when the Form is disposed.
    inputPeso.dispose();
    inputAltura.dispose();
  }

  String? _errorMessagePeso;
  String? _errorMessageAltura;

  void _validateInputPeso(double? value) {
    if (value == 0) {
      setState(() {
        _errorMessagePeso = 'O valor não pode ser 0';
      });
    } else if (value == null) {
      _peso = null;
      setState(() {
        _errorMessagePeso = 'Insira um valor';
      });
    } else {
      setState(() {
        _errorMessagePeso = null;
      });
    }
  }

  void _validateInputAltura(double? value) {
    if (value == 0) {
      setState(() {
        _errorMessageAltura = 'O valor não pode ser 0';
      });
    } else if (value == null) {
      _altura = null;
      setState(() {
        _errorMessageAltura = 'Insira um valor';
      });
    } else {
      setState(() {
        _errorMessageAltura = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(),
          colorSchemeSeed: const Color.fromRGBO(232, 91, 129, 1),
        ),
        home: Scaffold(
            body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(47, 115, 47, 113),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => inputPeso.requestFocus(),
                  child: const Text(
                    "Peso",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                TextField(
                  focusNode: inputPeso,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
                  ],
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (value) => inputAltura.requestFocus(),
                  onChanged: (value) {
                    if (value == "") {
                      _peso = null;
                      _validateInputPeso(null);
                    } else {
                      _peso = double.parse(value);
                      _validateInputPeso(_peso);
                    }
                  },
                  decoration: InputDecoration(
                      errorText: _errorMessagePeso,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.only(
                          left: 25, right: 16, top: 13, bottom: 13)),
                ),
                const SizedBox(
                  height: 17,
                ),
                GestureDetector(
                  onTap: () => inputAltura.requestFocus(),
                  child: const Text(
                    "Altura",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                TextField(
                  focusNode: inputAltura,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
                  ],
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    if (value == "") {
                      _altura = null;
                      _validateInputAltura(null);
                    } else {
                      _altura = double.parse(value);
                      _validateInputAltura(_altura);
                    }
                  },
                  onSubmitted: (value) {
                    value == ""
                        ? _altura = double.parse(value)
                        : _validateInputAltura(null);
                    TextInputAction.done;
                  },
                  decoration: InputDecoration(
                      errorText: _errorMessageAltura,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.only(
                          left: 25, right: 16, top: 13, bottom: 13)),
                ),
                const SizedBox(
                  height: 24,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      onPressed: () {
                        _validateInputAltura(_altura);
                        _validateInputPeso(_peso);
                        if (_peso == 0 || _peso == null) {
                          inputPeso.requestFocus();
                        } else if (_altura == 0 || _altura == null) {
                          inputAltura.requestFocus();
                        } else {
                          datarows.addDataRowByIMC(_peso!, _altura!);
                        }
                      },
                      style: const ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4)))),
                        padding: WidgetStatePropertyAll(EdgeInsets.all(20)),
                        backgroundColor: WidgetStatePropertyAll(
                            Color.fromRGBO(232, 91, 129, 1)),
                      ),
                      child: Text(datarows.datarowsList.isEmpty
                          ? "Adicionar"
                          : "Calcular"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 38,
                ),
                datarows.datarowsList.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Scrollbar(
                              trackVisibility: true,
                              scrollbarOrientation: ScrollbarOrientation.bottom,
                              thumbVisibility: true,
                              child: Center(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      DataTable(
                                          key: const Key("tabelaPrincipal"),
                                          dividerThickness: double.minPositive,
                                          columns: const <DataColumn>[
                                            DataColumn(
                                                label: Expanded(
                                                    child: Text("Peso"))),
                                            DataColumn(
                                                label: Expanded(
                                                    child: Text("Altura"))),
                                            DataColumn(
                                                label: Expanded(
                                                    child: Text("IMC"))),
                                            DataColumn(
                                                label: Expanded(
                                                    child: Text("Resultado"))),
                                          ],
                                          headingTextStyle: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          rows: <DataRow>[
                                            ...datarows.datarowsList
                                          ]),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(70, 19, 70, 14),
                              child: Text(
                                textAlign: TextAlign.center,
                                "Saiba agora se está no seu peso ideal!",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(171, 171, 171, 1)),
                              ),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DataTable(
                          headingTextStyle: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color.fromRGBO(232, 91, 129, 1)),
                          headingRowColor: const WidgetStatePropertyAll(
                              Color.fromRGBO(244, 244, 244, 1)),
                          headingRowHeight: 48,
                          dataRowMaxHeight: double.infinity,
                          dataRowMinHeight: 40,
                          columns: const <DataColumn>[
                            DataColumn(label: Expanded(child: Text("IMC"))),
                            DataColumn(
                                label: Expanded(child: Text("Classificação"))),
                          ],
                          rows: <DataRow>[
                            ...Datarows.LINHASIMC.asMap().entries.map((e) {
                              int indice = e.key;
                              List<String> valores = e.value;
                              return DataRow.byIndex(
                                  index: indice,
                                  color: indice % 2 != 0
                                      ? const WidgetStatePropertyAll(
                                          Color.fromRGBO(244, 244, 244, 1))
                                      : null,
                                  cells: <DataCell>[
                                    ...valores.map((element) {
                                      return DataCell(Text(element));
                                    })
                                  ]);
                            })
                          ]),
                    ),
                  ],
                )
              ],
            ),
          ),
        )));
  }
}
