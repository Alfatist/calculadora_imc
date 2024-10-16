import 'package:flutter/material.dart';
import "package:calculadora_imc/assets/imc.dart" as imcData;

class Datarows {
  List<DataRow> datarowsList = [];
  Datarows();
  int _index = 1;

  static const List<List<String>> LINHASIMC = imcData.LINHASIMC;
  static Map<double, String> RELACAOMENORVALORTEXTO =
      imcData.RELACAOMENORVALORTEXTO;
  static List<double> chaves = imcData.RELACAOMENORVALORTEXTO.keys.toList();

  void addDataRowByIMC(double peso, double altura) {
    double imc = peso / (altura * altura);
    List<String> listaTextos = [
      peso == peso.toInt() ? peso.toString() : peso.toStringAsFixed(2),
      altura == altura.toInt() ? altura.toString() : altura.toStringAsFixed(2),
      imc == imc.toInt() ? imc.toString() : imc.toStringAsFixed(2),
    ];
    for (double chave in chaves) {
      if (imc < chave) {
        listaTextos.add(RELACAOMENORVALORTEXTO[chave]!);
        break;
      }
    }
    datarowsList.add(
      DataRow.byIndex(
        index: _index,
        color: _index % 2 == 0 ? WidgetStatePropertyAll(Colors.black12) : null,
        cells: <DataCell>[
          ...listaTextos.map(
            (e) => DataCell(Text(e)),
          )
        ],
      ),
    );
    ++_index;
  }
}
