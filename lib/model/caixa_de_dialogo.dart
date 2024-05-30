import 'package:flutter/material.dart';

class GerenciadorDeDialogo {
  static Future<String> definirDialogo(BuildContext context, String tipo) async {
    switch (tipo) {
      case "input":
        return mostrarDialogoInput(context);
      case "confirmação":
        return mostrarDialogoConfirmacao(context);
    }
    return "";
  }

  static Future<String> mostrarDialogoInput(BuildContext context) async {
    TextEditingController controlador = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Digite seu nome'),
          content: TextField(
            controller: controlador,
            decoration: const InputDecoration(hintText: 'Nome'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCELAR'),
              onPressed: () {
                Navigator.of(context).pop("");
              },
            ),
            TextButton(
              child: const Text('CONFIRMAR'),
              onPressed: () {
                Navigator.of(context).pop(controlador.text);
              },
            ),
          ],
        );
      },
    ).then((result) {
      return result!;
    });
  }

  static Future<String> mostrarDialogoConfirmacao(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content:
              const Text('Você tem certeza que deseja executar esta ação?'),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCELAR'),
              onPressed: () {
                Navigator.of(context).pop("");
              },
            ),
            TextButton(
              child: const Text('CONFIRMAR'),
              onPressed: () {
                Navigator.of(context).pop("true");
              },
            ),
          ],
        );
      },
    ).then((result) {
      return result!;
    });
  }
}
