import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
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
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(
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
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(
                          left: 25, right: 16, top: 13, bottom: 13)),
                ),
                const SizedBox(
                  height: 24,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4)))),
                        padding: WidgetStatePropertyAll(EdgeInsets.all(20)),
                        backgroundColor: WidgetStatePropertyAll(
                            Color.fromRGBO(232, 91, 129, 1)),
                      ),
                      child: const Text("Refazer"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )));
  }
}
