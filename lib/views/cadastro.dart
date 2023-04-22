import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:frontend_events/models/user.dart';
import 'package:frontend_events/utils/http_service.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastro',
          style: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Container(
          width: 400,
          height: 500,
          margin: const EdgeInsets.all(25),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black, style: BorderStyle.solid, width: 3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Entre com seus dados para se registrar na plataforma de eventos!',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, left: 15, right: 30),
              child: TextField(
                controller: _controllerNome,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(36, 16, 32, 16),
                    hintText: "Nome",
                    icon: Icon(Icons.person),
                    iconColor: Colors.grey,
                    focusColor: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, left: 15, right: 30),
              child: TextField(
                controller: _controllerEmail,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(36, 16, 32, 16),
                    hintText: "Email",
                    icon: Icon(Icons.email),
                    iconColor: Colors.grey,
                    focusColor: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25, left: 15, right: 30),
              child: TextField(
                keyboardType: TextInputType.text,
                controller: _controllerPassword,
                obscureText: true,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(36, 16, 32, 16),
                    hintText: "Senha",
                    icon: Icon(Icons.password),
                    iconColor: Colors.grey,
                    focusColor: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 16.0, left: 15, right: 30),
              child: ElevatedButton(
                onPressed: () async {
                  _cadastrar();
                },
                style: const ButtonStyle(),
                child: Text(
                  "Cadastrar",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _cadastrar() async {
    final response = await HttpService().post('8080', 'user', headers: {
      HttpHeaders.contentTypeHeader: "application/json"
    }, body: {
      "name": _controllerNome.text,
      "email": _controllerEmail.text,
      "password": _controllerPassword.text
    });

    if (response.statusCode == 201) {
      User user = User.fromJson(jsonDecode(response.body));
      SnackBar snackBar = customSnackBar("Sucesso ao registrar!",
          "Encaminhando para home page", ContentType.success, Colors.green);
      snackbarKey.currentState?.showSnackBar(snackBar);
      _navegar(user);
    } else {
      SnackBar snackBar = customSnackBar(
          "Erro ao cadastrar!", response.body, ContentType.failure, Colors.red);
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }

  void _navegar(user) {
    Navigator.pushNamedAndRemoveUntil(
        context, '/home', arguments: user, (route) => false);
  }

  SnackBar customSnackBar(title, message, content, color) {
    final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: AwesomeSnackbarContent(
          color: color,
          title: title,
          message: message,
          contentType: content,
        ),
        backgroundColor: Colors.transparent);
    return snackBar;
  }
}
