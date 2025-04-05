class Usuario {
  List database = [];

  String? email;
  String? usuario;
  String? senha;

  Usuario({required this.email, required this.usuario, required this.senha});

  Future<bool> entrar(Usuario usuario) async {
    return true;
  }

  Future<bool> criarConta(usuario) async {
    return true;
  }

  Map toMap(Usuario novoUsuario) {
    return {
      'email': novoUsuario.email,
      'usuario': novoUsuario.usuario,
      'senha': novoUsuario.senha
    };
  }

  Usuario fromMap(Map userMap) {
    return Usuario(
        email: userMap['email'],
        usuario: userMap['usuario'],
        senha: userMap['senha']);
  }

  String? eUsuarioValido(value) {
    if (value.isEmpty) {
      return 'O campo de e-mail não pode estar vazio';
    }
    return null;
  }


  String? eEmailValido(value) {
    if (value == null || value.isEmpty) {
      return 'O campo de e-mail não pode estar vazio';
    }
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Insira um e-mail válido';
    }
    return null;
  }

  String? eSenhaValida(value) {
    if (value == null || value.isEmpty) {
      return 'A senha não pode estar vazia';
    }

    if (value.length < 6) {
      return 'A senha deve conter pelo menos 6 caracteres';
    }

    String pattern = r'^(?=.*[0-9]).+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'A senha deve conter pelo menos 1 caractere numérico.';
    }
    return null;
  }
}
