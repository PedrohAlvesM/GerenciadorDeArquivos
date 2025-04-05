import 'package:flutter/material.dart';

class GerenciadorDeDialogo {
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

  static Future<bool> mostrarDialogoConfirmacao(BuildContext context) async {
    return await showDialog<bool>(
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
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('CONFIRMAR'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((result) {
      return result!;
    });
  }

  static Future<bool> mostrarDialogoPropriedades(
      BuildContext context, Map<String, String> propriedades) async {
    List<MapEntry<String, String>> listar = propriedades.entries.toList();

    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Propriedades de ${propriedades["caminho"]}'),
          content: SizedBox(
            width: double.maxFinite,
            height: double.maxFinite, 
            child: ListView.builder(
              shrinkWrap: true, 
              itemCount: listar.length,
              itemBuilder: (context, index) {
                return Text("${listar[index].key}: ${listar[index].value}");
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Voltar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ).then((result) {
      return result!;
    });
  }

  static Future<int> mostrarDialogoOpcoesArquivo(BuildContext context) async {
    return await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const Text('O que deseja fazer'),
          actions: <Widget>[
            TextButton(
              child: const Text('Mover arquivo'),
              onPressed: () {
                Navigator.of(context).pop(1);
              },
            ),
            TextButton(
              child: const Text('Copiar arquivo'),
              onPressed: () {
                Navigator.of(context).pop(2);
              },
            ),
            TextButton(
              child: const Text('Renomear arquivo'),
              onPressed: () {
                Navigator.of(context).pop(3);
              },
            ),
            TextButton(
              child: const Text('Deletar arquivo'),
              onPressed: () {
                Navigator.of(context).pop(4);
              },
            ),
            TextButton(
              child: const Text('Propriedades do arquivo'),
              onPressed: () {
                Navigator.of(context).pop(5);
              },
            ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(0);
              },
            ),
          ],
        );
      },
    ).then((result) {
      return result!;
    });
  }

  static Future<int> mostrarDialogoOpcoesDiretorio(BuildContext context) async {
    return await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const Text('O que deseja fazer'),
          actions: <Widget>[
            TextButton(
              child: const Text('Mover pasta'),
              onPressed: () {
                Navigator.of(context).pop(1);
              },
            ),
            TextButton(
              child: const Text('Copiar pasta'),
              onPressed: () {
                Navigator.of(context).pop(2);
              },
            ),
            TextButton(
              child: const Text('Renomear pasta'),
              onPressed: () {
                Navigator.of(context).pop(3);
              },
            ),
            TextButton(
              child: const Text('Deletar pasta'),
              onPressed: () {
                Navigator.of(context).pop(4);
              },
            ),
            TextButton(
              child: const Text('Propriedades da pasta'),
              onPressed: () {
                Navigator.of(context).pop(5);
              },
            ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(0);
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
