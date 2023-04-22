import 'dart:convert';
import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:frontend_events/models/user.dart';
import 'package:frontend_events/utils/http_service.dart';
import 'package:google_fonts/google_fonts.dart';
import '../global.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'Entre com seus dados para acessar a plataforma de eventos!',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    fontSize: 30, fontWeight: FontWeight.bold),
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
                  _login();
                },
                style: const ButtonStyle(),
                child: Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/cadastrar');
                },
                child: Text(
                  'Não possue conta ainda, clique aqui e cadastre-se!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  void _login() async {
    var body = ({
      'email': _controllerEmail.text,
      'password': _controllerPassword.text
    });
    var response = await HttpService().post("8080", "user/login",
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: body);

    if (response.statusCode == 201) {
      var jsonResponse =
          await jsonDecode(response.body) as Map<String, dynamic>;
      _navigate(User.fromJson(jsonResponse));
    } else {
      var jsonResponse =
          await jsonDecode(response.body) as Map<String, dynamic>;
      SnackBar snackBar =
          customSnackBar("Erro ao autenticar", jsonResponse['error']);
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }

  void _navigate(user) {
    Navigator.pushNamedAndRemoveUntil(
        context, '/home', arguments: user, (route) => false);
  }

  SnackBar customSnackBar(title, message) {
    final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: AwesomeSnackbarContent(
          color: Colors.redAccent,
          title: title,
          message: message,
          contentType: ContentType.failure,
        ),
        backgroundColor: Colors.transparent);
    return snackBar;
  }
}
