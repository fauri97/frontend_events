import 'dart:convert';
import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:frontend_events/models/event.dart';
import 'package:frontend_events/models/user.dart';
import 'package:frontend_events/widgets/custom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../global.dart';
import '../utils/http_service.dart';

class EventView extends StatefulWidget {
  const EventView({super.key, required this.user});
  final User user;

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Eventos',
          style: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: MyCustomDrawer(user: widget.user),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.3,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(16)),
            child: FutureBuilder(
              future: _events(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final event = snapshot.data![index];
                      return ListTile(
                        title: Text(
                          event.name!,
                          style: GoogleFonts.roboto(fontSize: 23),
                        ),
                        trailing: Text(
                            '${snapshot.data![index].vacanciesFilled}/${snapshot.data![index].vacancies}'),
                        subtitle: Text(
                          event.description!,
                          style: GoogleFonts.roboto(fontSize: 18),
                        ),
                        onTap: () async {
                          bool userOnEvent =
                              await _getUserOnEvent(snapshot.data![index].id);
                          if (userOnEvent) {
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Desfazer Registro?"),
                                  content: const Text(
                                      "Você já está registrado nesse evento, deseja cancelar a inscrição?"),
                                  actionsAlignment:
                                      MainAxisAlignment.spaceAround,
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          _cancelarInscricao(
                                              snapshot.data![index].id);

                                          setState(() {
                                            snapshot.data![index]
                                                .vacanciesFilled = snapshot
                                                    .data![index]
                                                    .vacanciesFilled! -
                                                1;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child:
                                            const Text("Cancelar Inscrição")),
                                    TextButton(
                                      child: const Text("Fechar"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Realizar Registro?"),
                                  content: Text(
                                      "Você deseja fazer a inscrição no evento: ${snapshot.data![index].name}?"),
                                  actionsAlignment:
                                      MainAxisAlignment.spaceAround,
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          _realizarInscricao(
                                              snapshot.data![index].id);

                                          setState(() {
                                            snapshot.data![index]
                                                .vacanciesFilled = snapshot
                                                    .data![index]
                                                    .vacanciesFilled! +
                                                1;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child:
                                            const Text("Realizar Inscrição?")),
                                    TextButton(
                                      child: const Text("Fechar"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Event>> _events() async {
    List<Event> events = [];
    final response = await HttpService().get('8081', 'event/', headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${widget.user.token}"
    });
    if (response.statusCode == 200) {
      var event = jsonDecode(response.body) as List;
      events = event.map((eventJson) => Event.fromJson(eventJson)).toList();
    }
    return events;
  }

  Future<bool> _getUserOnEvent(eventId) async {
    final response = await HttpService()
        .get('8081', 'event/user/${widget.user.id}/$eventId', headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${widget.user.token}"
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  void _cancelarInscricao(eventId) async {
    await HttpService().delete(
        '8081', 'event/registration/${widget.user.id}/$eventId',
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${widget.user.token}"
        },
        body: {});
    var snackBar = customSnackBar('Sucesso ao cancelar o registro!',
        'Você receberá um email com a confirmação do cancelamento da inscrição do evento!');

    snackbarKey.currentState?.showSnackBar(snackBar);
  }

  void _realizarInscricao(eventId) async {
    await HttpService().post('8081', 'event/registration/', headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${widget.user.token}"
    }, body: {
      'userId': widget.user.id,
      'eventId': eventId
    });
    var snackBar = customSnackBar('Sucesso ao se registrar no evento!',
        'Você receberá um email com a confirmação da inscrição no evento!');

    snackbarKey.currentState?.showSnackBar(snackBar);
  }

  SnackBar customSnackBar(title, message) {
    final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: AwesomeSnackbarContent(
          color: Colors.lightGreen,
          title: title,
          message: message,
          contentType: ContentType.success,
        ),
        backgroundColor: Colors.transparent);
    return snackBar;
  }
}
