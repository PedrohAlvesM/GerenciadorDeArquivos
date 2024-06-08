// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      File novoArquivoDiferente = File(
          "${diretorioAtual!.path}/$nomeArquivo-${DateTime.now().toString()}.txt");
      await novoArquivoDiferente.create(recursive: true);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Arquivo criado em: ${diretorioAtual.toString()}')),
    );
  }

  Future<void> criarDiretorio(String nomeDiretorio) async {
    Directory novoDiretorio =
        Directory("${diretorioAtual!.path}/$nomeDiretorio");

    if (!await novoDiretorio.exists()) {
      await novoDiretorio.create(recursive: true);
    } else {
      Directory novoDiretorioDiferente = Directory(
          "${diretorioAtual!.path}/$nomeDiretorio-${DateTime.now().toString()}");
      await novoDiretorioDiferente.create(recursive: true);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pasta criada em: ${diretorioAtual.toString()}')),
    );
  }

  Future<void> deletarArquivo(File arquivoDeletar) async {
    if (await arquivoDeletar.exists()) {
      await arquivoDeletar.delete(recursive: true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$arquivoDeletar foi deletado')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível deletar o arquivo')),
      );
    }
  }

  Future<void> deletarDiretorio(Directory diretorioDeletar) async {
    if (await diretorioDeletar.exists()) {
      await diretorioDeletar.delete(recursive: true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$diretorioDeletar foi deletado')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível deletar o arquivo')),
      );
    }
  }

  Future<void> moverArquivo() async {}
  Future<void> moverDiretorio() async {}
  Future<void> copiarArquivo() async {}
  Future<void> copiarDiretorio() async {}

  Future<void> renomearArquivo(File arquivo, String novoNome) async {
    if (await arquivo.exists()) {
      String novoCaminho = "${diretorioAtual!.path}/$novoNome";
      await arquivo.rename(novoCaminho);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Arquivo renomeado para $novoCaminho')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível renomear o arquivo')),
      );
    }
  }

  Future<void> renomearDiretorio(Directory diretorio, String novoNome) async {
    if (await diretorio.exists()) {
      String novoCaminho = "${diretorioAtual!.path}/$novoNome";
      await diretorio.rename(novoCaminho);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Arquivo renomeado para $novoCaminho')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível renomear o arquivo')),
      );
    }
  }

  Future<void> propriedades(FileSystemEntity entidade) async {
    String caminho = entidade.path.split('/').last;
    DateTime dataModificacao = await entidade.stat().then((stat) => stat.modified);
    int tamanho = await entidade.stat().then((stat) => stat.size);
    String tipo = entidade is File ? "arquivo" : "pasta";

    String tamanhoMedida = "";
    const int kB = 1024;
    const int MB = 1024 * kB;
    const int GB = 1024 * MB;
    const int TB = 1024 * GB;

    if (tamanho >= TB) {
      tamanhoMedida = '${(tamanho / TB).toStringAsFixed(2)} TB';
    } else if (tamanho >= GB) {
      tamanhoMedida = '${(tamanho / GB).toStringAsFixed(2)} GB';
    } else if (tamanho >= MB) {
      tamanhoMedida = '${(tamanho / MB).toStringAsFixed(2)} MB';
    } else if (tamanho >= kB) {
      tamanhoMedida = '${(tamanho / kB).toStringAsFixed(2)} KB';
    } else {
      tamanhoMedida = '$tamanho bytes';
    }
    
    Map<String, String> propriedades = {
      "caminho": caminho,
      "localização": entidade.path,
      "data de modificação": dataModificacao.toString(),
      "tamanho": tamanhoMedida,
      "tipo": tipo,
    };

    if (entidade is File) {
      List<String> extensao = entidade.path.split(".");

      if (extensao.isNotEmpty) {
        propriedades["extensão"] = extensao[extensao.length -1];
      }
    }

    await GerenciadorDeDialogo.mostrarDialogoPropriedades(context, propriedades);
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
          return GestureDetector(
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
            onLongPress: () async {
              if (entidade is File) {
                Map<int, Function> opcoesPossiveis = {
                  0: () {},
                  1: moverArquivo,
                  2: copiarArquivo,
                  3: renomearArquivo,
                  4: deletarArquivo,
                  5: propriedades,
                };

                int opcaoEscolhida =
                    await GerenciadorDeDialogo.mostrarDialogoOpcoesArquivo(
                        context);

                if (opcaoEscolhida == 3) {
                  String novoNome = await GerenciadorDeDialogo.mostrarDialogoInput(context);
                  await opcoesPossiveis[opcaoEscolhida]!(entidade, novoNome);
                }
                else {
                  await opcoesPossiveis[opcaoEscolhida]!(entidade);
                }
                
              } else if (entidade is Directory) {
                Map<int, Function> opcoesPossiveis = {
                  0: () {},
                  1: moverDiretorio,
                  2: copiarDiretorio,
                  3: renomearDiretorio,
                  4: deletarDiretorio,
                  5: propriedades,
                };

                int opcaoEscolhida =
                    await GerenciadorDeDialogo.mostrarDialogoOpcoesDiretorio(
                        context);

                if (opcaoEscolhida == 3) {
                  String novoNome = await GerenciadorDeDialogo.mostrarDialogoInput(context);
                  await opcoesPossiveis[opcaoEscolhida]!(entidade, novoNome);
                }
                else {
                  await opcoesPossiveis[opcaoEscolhida]!(entidade);
                }
              }
            },
            child: ListTile(
              leading: Icon(
                entidade is Directory ? Icons.folder : Icons.insert_drive_file,
              ),
              title: Text(entidade.path.split('/').last),
            ),
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
                  String? nomeArquivo =
                      await GerenciadorDeDialogo.mostrarDialogoInput(context);
                  if (nomeArquivo.isNotEmpty) {
                    criarArquivo(nomeArquivo);
                  }
                },
                child: const Row(
                  children: [Text("criar arquivo"), Icon(Icons.note_add)],
                )),
            TextButton(
                onPressed: () async {
                  String? nomeDiretorio =
                      await GerenciadorDeDialogo.mostrarDialogoInput(context);
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
