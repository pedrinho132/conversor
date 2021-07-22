import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

var request = Uri.parse('https://api.hgbrasil.com/finance');

void main() async {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realControler = TextEditingController();
  final euroControler = TextEditingController();
  final dolarControler = TextEditingController();

  void _realChanged(String text) {
    double real = double.parse(text);
    dolarControler.text = (real / dolar).toStringAsFixed(2);
    euroControler.text = (real / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euroText = double.parse(text);
    realControler.text = (euro * euroText).toStringAsFixed(2);
    dolarControler.text = (euroText * euro / dolar).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    double dolarText = double.parse(text);
    realControler.text = (dolar * dolarText).toStringAsFixed(2);
    euroControler.text = (dolarText * dolar / euro).toStringAsFixed(2);
  }

  double dolar;
  double euro;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black26,
        centerTitle: true,
        title: Text(
          "Conersor de Moedas",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Dados",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao carregar dados",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 100.0,
                        color: Colors.green,
                      ),
                      Divider(),
                      buildTextField(
                          "Reais", "R\$", realControler, _realChanged),
                      Divider(),
                      buildTextField(
                          "Euros", "EUR", euroControler, _euroChanged),
                      Divider(),
                      buildTextField(
                          "Dolares", "USD", dolarControler, _dolarChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

Widget buildTextField(String label, String prefix,
    TextEditingController controllerText, Function f) {
  return TextField(
    keyboardType: TextInputType.number,
    controller: controllerText,
    decoration: InputDecoration(
        labelText: "$label",
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(),
        prefixText: "$prefix",
        prefixStyle: TextStyle(color: Colors.green)),
    style: TextStyle(color: Colors.black),
    onChanged: f,
  );
}

//  theme: ThemeData(
//     hintColor: Colors.amber,
//     primaryColor: Colors.white,
//   inputDecorationTheme: InputDecorationTheme(
//   enabledBorder:
//     OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
// focusedBorder:
//   OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
// hintStyle: TextStyle(color: Colors.amber),
//    )),
// ));
