import 'package:flutter/material.dart';
import 'package:frontend_events/models/user.dart';
import 'package:frontend_events/widgets/custom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key, required this.user});
  final User user;

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Plataforma de Eventos',
            style:
                GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        drawer: MyCustomDrawer(user: widget.user));
  }
}
