// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file_plus/open_file_plus.dart';

import 'model/caixa_de_dialogo.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<FileSystemEntity> subDiretorios = [];
  Directory? diretorioAtual;

  @override
  void initState() {
    super.initState();
    pedirPermissao();
  }

  Future<void> pedirPermissao() async {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();
    }

    if (status.isGranted) {
      listarSubDiretorios(Directory("storage/emulated/0"));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissão de armazenamento negada')),
      );
    }
  }

  Future<void> listarSubDiretorios(Directory diretorio) async {
    try {
      if (diretorio.path != "storage/emulated") {
        setState(() {
          diretorioAtual = diretorio;
          subDiretorios = diretorio.listSync();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não é possível voltar mais.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Foi encontrado um problema ao listar os arquivos.')),
      );
      print(e);
    }
  }

  Future<void> abrirArquivo(FileSystemEntity arquivo) async {
    if (arquivo is File) {
      await OpenFile.open(arquivo.path);
    }
  }

  Future<void> criarArquivo(String nomeArquivo) async {
    File novoArquivo = File("${diretorioAtual!.path}/$nomeArquivo");

    if (!await novoArquivo.exists()) {
      await novoArquivo.create(recursive: true);

    } else {
      File novoArquivoDiferente = File("${diretorioAtual!.path}/$nomeArquivo-${DateTime.now().toString()}.txt");
      await novoArquivoDiferente.create(recursive: true);
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Arquivo criado em: ${diretorioAtual.toString()}')),
    );
      
  }

  Future<void> criarDiretorio(String nomeDiretorio) async {
    Directory novoDiretorio = Directory("${diretorioAtual!.path}/$nomeDiretorio");
    
    if (!await novoDiretorio.exists()) {
      await novoDiretorio.create(recursive: true);

    } else {
      Directory novoDiretorioDiferente = Directory("${diretorioAtual!.path}/$nomeDiretorio-${DateTime.now().toString()}");
      await novoDiretorioDiferente.create(recursive: true);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pasta criada em: ${diretorioAtual.toString()}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(diretorioAtual?.path ?? 'Gerenciador de Arquivos'),
        leading: diretorioAtual != null &&
                diretorioAtual!.parent.path != diretorioAtual!.path
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  listarSubDiretorios(diretorioAtual!.parent);
                },
              )
            : null,
      ),
      body: ListView.builder(
        itemCount: subDiretorios.length,
        itemBuilder: (context, index) {
          FileSystemEntity entidade = subDiretorios[index];
          return ListTile(
            leading: Icon(
              entidade is Directory ? Icons.folder : Icons.insert_drive_file,
            ),
            title: Text(entidade.path.split('/').last),
            onTap: () {
              if (entidade is Directory) {
                setState(() {
                  diretorioAtual = entidade;
                  subDiretorios = entidade.listSync();
                });
              } else if (entidade is File) {
                setState(() {
                  abrirArquivo(entidade);
                });
              }
            },
          );
        },
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () async {
                  String? nomeArquivo = await GerenciadorDeDialogo.definirDialogo(
                      context, "input");
                  if (nomeArquivo.isNotEmpty) {
                    criarArquivo(nomeArquivo);
                  }
                },
                child: const Row(
                  children: [Text("criar arquivo"), Icon(Icons.note_add)],
                )),
            TextButton(
                onPressed: () async {

                  String? nomeDiretorio = await GerenciadorDeDialogo.definirDialogo(
                      context, "input");
                  if (nomeDiretorio.isNotEmpty) {
                    criarDiretorio(nomeDiretorio);
                  }
                },
                child: const Row(
                  children: [
                    Text("criar pasta"),
                    Icon(Icons.create_new_folder)
                  ],
                )),
          ],
        )
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(home: Home()));
}
