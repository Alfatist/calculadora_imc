import 'package:flutter/material.dart';
import "package:calculadora_imc/assets/imc.dart" as imcData;
import 'package:hive/hive.dart';

class Datarows {
  List<DataRow> datarowsList = [];
  String name;
  Datarows(this.name) {
    var box = Hive.box("dataBox");
    List<String> pesoAlturaList = box.get("datarows List $name") ?? [];
    if (pesoAlturaList.isNotEmpty) {
      for (var pair in pesoAlturaList) {
        List<String> par = pair.split(";");
        addDataRowByIMC(double.parse(par[0]), double.parse(par[1]),
            save: false);
      }
    }
  }
  int _index = 1;

  static const List<List<String>> LINHASIMC = imcData.LINHASIMC;
  static Map<double, String> RELACAOMENORVALORTEXTO =
      imcData.RELACAOMENORVALORTEXTO;
  static List<double> chaves = imcData.RELACAOMENORVALORTEXTO.keys.toList();

  void addDataRowByIMC(double peso, double altura, {bool save = true}) {
    if (save) {
      var box = Hive.box("dataBox");
      List<String> listaValores = box.get("datarows List $name") ?? [];
      listaValores.add("$peso;$altura");
      box.put("datarows List $name", listaValores);
    }
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
        color: _index % 2 == 0
            ? const WidgetStatePropertyAll(Colors.black12)
            : null,
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
