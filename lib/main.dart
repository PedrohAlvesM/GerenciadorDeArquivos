// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:open_file_plus/open_file_plus.dart';

import 'model/caixa_de_dialogo.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<FileSystemEntity> subDiretorios = [];
  Directory? diretorioAtual;

  bool modoSelecao = false;
  bool modoCopiar = false;
  bool modoColar = false;
  List<FileSystemEntity> entidadesSelecionadas = [];

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
      // await OpenFile.open(arquivo.path);
    }
  }

  Future<void> criarArquivo(String nomeArquivo, String caminhoCriar) async {
    File novoArquivo = File("$caminhoCriar/$nomeArquivo");

    if (!await novoArquivo.exists()) {
      await novoArquivo.create(recursive: true);
    } else {
      File novoArquivoDiferente =
          File("$caminhoCriar/$nomeArquivo-${DateTime.now().toString()}");
      await novoArquivoDiferente.create(recursive: true);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Arquivo criado em: $caminhoCriar')),
    );
  }

  Future<void> criarDiretorio(String nomeDiretorio, String caminhoCriar) async {
    Directory novoDiretorio = Directory("$caminhoCriar/$nomeDiretorio");

    if (!await novoDiretorio.exists()) {
      await novoDiretorio.create(recursive: true);
    } else {
      Directory novoDiretorioDiferente = Directory(
          "$caminhoCriar/$nomeDiretorio-${DateTime.now().toString()}");
      await novoDiretorioDiferente.create(recursive: true);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pasta criada em: $caminhoCriar')),
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
  Future<void> copiarArquivo(
      String caminhoOriginal, String caminhoCopiar) async {
    File novoArquivo = File(caminhoOriginal);

    String nomeArquivo = caminhoOriginal.split("/").last;

    await novoArquivo.copy("$caminhoCopiar/$nomeArquivo");
  }

  Future<void> colarEntidades(
      String raiz, List<FileSystemEntity> diretorioCopiar) async {
    for (FileSystemEntity entidade in diretorioCopiar) {
      if (entidade is File) {
        await copiarArquivo(entidade.path, raiz);
      } else if (entidade is Directory) {
        String nomeDiretorio = entidade.path.split("/").last;
        String novoDiretorioPath = "$raiz/$nomeDiretorio";
        await criarDiretorio(nomeDiretorio, raiz);

        List<FileSystemEntity> conteudoDiretorioOriginal = entidade.listSync();

        await colarEntidades(novoDiretorioPath, conteudoDiretorioOriginal);
      }
    }
  }

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
    DateTime dataModificacao =
        await entidade.stat().then((stat) => stat.modified);
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
        propriedades["extensão"] = extensao[extensao.length - 1];
      }
    }

    await GerenciadorDeDialogo.mostrarDialogoPropriedades(
        context, propriedades);
  }

  bool eArquivoImagem(FileSystemEntity arquivo) {
    if (arquivo is File) {
      List<String> extensions = [
        'jpg',
        'jpeg',
        'png',
        'gif',
        'tiff',
        'webp',
        'bmp'
      ];
      String extension = arquivo.path.split('.').last.toLowerCase();
      return extensions.contains(extension);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> acoesPersistentes() {
      return [
        TextButton(
          onPressed: () async {
            String? nomeArquivo =
                await GerenciadorDeDialogo.mostrarDialogoInput(context);
            if (nomeArquivo.isNotEmpty) {
              criarArquivo(nomeArquivo, diretorioAtual!.path);
            }
          },
          child: const Icon(Icons.note_add),
        ),
        TextButton(
          onPressed: () async {
            String? nomeDiretorio =
                await GerenciadorDeDialogo.mostrarDialogoInput(context);
            if (nomeDiretorio.isNotEmpty) {
              criarDiretorio(nomeDiretorio, diretorioAtual!.path);
            }
          },
          child: const Icon(Icons.create_new_folder),
        )
      ];
    }

    List<Widget> acoesPersistentesSelecao() {
      return [
        TextButton(
          onPressed: () {
            setState(() {
              modoCopiar = true;
              modoSelecao = false;
            });
          },
          child: const Icon(Icons.copy),
        ),
        TextButton(
          onPressed: () async {
            setState(() {
              modoSelecao = false;
              modoColar = true;
            });
          },
          child: const Icon(Icons.drive_file_move_outline),
        ),
        TextButton(
          onPressed: () async {
            await propriedades(entidadesSelecionadas.elementAt(0));
            setState(() {
              modoSelecao = false;
              entidadesSelecionadas.clear();
            });
          },
          child: const Icon(Icons.info),
        ),
        TextButton(
          onPressed: () async {
            String? nome =
                await GerenciadorDeDialogo.mostrarDialogoInput(context);
            if (nome.isNotEmpty) {
              if (entidadesSelecionadas.elementAt(0) is File) {
                renomearArquivo(
                    entidadesSelecionadas.elementAt(0) as File, nome);
              } else if (entidadesSelecionadas.elementAt(0) is Directory) {
                renomearDiretorio(
                    entidadesSelecionadas.elementAt(0) as Directory, nome);
              }
            }

            setState(() {
              modoSelecao = false;
              entidadesSelecionadas.clear();
            });
          },
          child: const Icon(Icons.drive_file_rename_outline),
        ),
        TextButton(
          onPressed: () {
            for (FileSystemEntity entidade in entidadesSelecionadas) {
              if (entidade is File) {
                deletarArquivo(entidade);
              } else if (entidade is Directory) {
                deletarDiretorio(entidade);
              }
            }
            setState(() {
              modoSelecao = false;
              entidadesSelecionadas.clear();
            });
          },
          child: const Icon(Icons.delete),
        ),
      ];
    }

    List<Widget> acoesPersistentesCopiarColar() {
      return [
        TextButton(
            onPressed: () async {
              await colarEntidades(diretorioAtual!.path, entidadesSelecionadas);

              if (modoColar) {
                for (FileSystemEntity entidade in entidadesSelecionadas) {
                  if (entidade is File) {
                    deletarArquivo(entidade);
                  } else if (entidade is Directory) {
                    deletarDiretorio(entidade);
                  }
                }
              }

              setState(() {
                entidadesSelecionadas.clear();
                modoCopiar = false;
                modoColar = false;
              });
            },
            child: const Icon(Icons.paste)),
        TextButton(
          onPressed: () {
            setState(() {
              modoCopiar = false;
              modoColar = false;
              entidadesSelecionadas.clear();
            });
          },
          child: const Icon(Icons.cancel),
        )
      ];
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(modoSelecao
              ? "Selecione os itens"
              : (modoCopiar ? "Selecione o destino" : diretorioAtual!.path)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (modoSelecao) {
                setState(() {
                  modoSelecao = false;
                  entidadesSelecionadas.clear();
                });
              } else {
                listarSubDiretorios(diretorioAtual!.parent);
              }
            },
          )),
      body: ListView.builder(
        itemCount: subDiretorios.length,
        itemBuilder: (context, index) {
          FileSystemEntity entidade = subDiretorios[index];
          return GestureDetector(
            onTap: () {
              if (modoSelecao) {
                setState(() {
                  if (entidadesSelecionadas.contains(entidade)) {
                    entidadesSelecionadas.remove(entidade);
                  } else {
                    entidadesSelecionadas.add(entidade);
                  }

                  if (entidadesSelecionadas.isEmpty) {
                    modoSelecao = false;
                  }
                });
              } else {
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
              }
            },
            onLongPress: () {
              setState(() {
                modoSelecao = true;
                entidadesSelecionadas.add(entidade);
              });
            },
            child: ListTile(
              selected: entidadesSelecionadas.contains(entidade),
              leading: eArquivoImagem(entidade)
                  ? Image.file(File(entidade.path), width: 24)
                  : (entidade is File
                      ? const Icon(Icons.insert_drive_file)
                      : const Icon(Icons.folder)),
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
            if (modoSelecao)
              ...acoesPersistentesSelecao()
            else if (modoCopiar || modoColar)
              ...acoesPersistentesCopiarColar()
            else
              ...acoesPersistentes()
          ],
        )
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData(

    ),
    home: const Home()
  ));
}
