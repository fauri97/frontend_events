import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend_events/models/user.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/http_service.dart';

class MyCustomDrawer extends StatefulWidget {
  const MyCustomDrawer({super.key, required this.user});
  final User user;
  @override
  State<MyCustomDrawer> createState() => _MyCustomDrawerState();
}

class _MyCustomDrawerState extends State<MyCustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${widget.user.name}',
                  style: GoogleFonts.roboto(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    widget.user.email!,
                    style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            onTap: () {
              // Navegar para a tela de início
              if (ModalRoute.of(context)?.settings.name != '/home') {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', arguments: widget.user, (route) => false);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Eventos'),
            onTap: () {
              // Navegar para a tela de configurações
              Navigator.pushNamed(context, '/eventos', arguments: widget.user);
            },
          ),
          ListTile(
            leading: const Icon(Icons.present_to_all),
            title: const Text('CheckIn'),
            onTap: () {
              // Navegar para a tela de configurações
              Navigator.pushNamed(context, '/checkIn', arguments: widget.user);
            },
          ),
          ListTile(
            leading: const Icon(Icons.document_scanner),
            title: const Text('Certificado'),
            onTap: () {
              // Navegar para a tela de configurações
              Navigator.pushNamed(context, '/certificado',
                  arguments: widget.user);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Deslogar'),
            onTap: () {
              // Navegar para a tela de configurações
              _logout();
            },
          ),
        ],
      ),
    );
  }

  void _logout() async {
    var response = await HttpService().post("8080", "user/logout", headers: {
      HttpHeaders.authorizationHeader: "Bearer ${widget.user.token}"
    });
    if (response.statusCode == 201) {
      _navigate();
    }
  }

  void _navigate() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
