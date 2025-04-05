import 'package:flutter/material.dart';
import 'package:gerenciador_de_arquivos/model/usuario_app.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController usuarioController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  Usuario usuario = Usuario(email: '', usuario: '', senha: '');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bem Vindo de volta'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.folder,
                      size: 64.0,
                      color: Colors.blue
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    TextFormField(
                      controller: emailController,
                      validator: usuario.eEmailValido,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: 'Email',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: senhaController,
                      validator: usuario.eSenhaValida,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.password),
                        labelText: 'Senha',
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Ainda não tem uma conta? '),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/registrar');
                          },
                          child: const Text(
                            'Registrar',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), 
                              spreadRadius: 2, 
                              blurRadius: 2, 
                              offset: const Offset(0, 0), 
                          ),
                        ],
                      ),
                      
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() == true) {
                            Usuario novoUsuario = Usuario(
                              email: emailController.text,
                              usuario: usuarioController.text,
                              senha: senhaController.text,
                            );
                            if (await usuario.entrar(novoUsuario)) {
                              print('___USUARIO CRIADO___');
                            }
                            print('___USUARIO NÃO FOI CRIADO___');
                          }
                        },
                        icon: const Icon(
                          Icons.login,
                          color: Colors.white,
                          size: 16.0,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        label: const Text(
                          'Entrar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Image.network(
                          'https://www.gstatic.com/marketing-cms/assets/images/d5/dc/cfe9ce8b4425b410b49b7f2dd3f3/g.webp=s96-fcrop64=1,00000000ffffffff-rw',
                          width: 16.0,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        label: const Text(
                          'Entrar com Google',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}