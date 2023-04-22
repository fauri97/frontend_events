import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global.dart';
import '../models/event.dart';
import '../models/user.dart';
import '../utils/http_service.dart';
import '../widgets/custom_drawer.dart';

class CheckInView extends StatefulWidget {
  const CheckInView({super.key, required this.user});
  final User user;

  @override
  State<CheckInView> createState() => _CheckInViewState();
}

class _CheckInViewState extends State<CheckInView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Check In',
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
                        subtitle: Text(
                          event.description!,
                          style: GoogleFonts.roboto(fontSize: 18),
                        ),
                        onTap: () async {
                          _realizarCheckIn(snapshot.data![index].id!);
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
    final response = await HttpService()
        .get('8081', 'event/user/${widget.user.id}', headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${widget.user.token}"
    });
    if (response.statusCode == 200) {
      var event = jsonDecode(response.body) as List;
      events = event.map((eventJson) => Event.fromJson(eventJson)).toList();
    }
    return events;
  }

  void _realizarCheckIn(eventId) async {
    await HttpService().post('8081', '/event/checkin', headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${widget.user.token}"
    }, body: {
      'userId': widget.user.id,
      'eventId': eventId
    });
    var snackBar = customSnackBar('Sucesso ao efetuar o CheckIn!',
        'Você receberá um email com a confirmação do checkIn no evento!');

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
