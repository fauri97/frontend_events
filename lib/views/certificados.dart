import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import '../models/event.dart';
import '../models/user.dart';
import '../utils/http_service.dart';
import '../widgets/custom_drawer.dart';

class CertificadoView extends StatefulWidget {
  const CertificadoView({super.key, required this.user});
  final User user;

  @override
  State<CertificadoView> createState() => _CertificadoViewState();
}

class _CertificadoViewState extends State<CertificadoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Certificado',
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
                          _gerarCertificadoPDF(snapshot.data![index].id);
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
        .get('8082', '/certificate/${widget.user.id}', headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${widget.user.token}"
    });
    if (response.statusCode == 200) {
      var event = jsonDecode(response.body) as List;
      events =
          event.map((eventJson) => Event.fromJson(eventJson['Event'])).toList();
    }
    return events;
  }

  void _gerarCertificadoPDF(eventId) async {
    final response = await HttpService().get(
        '8082', 'certificate/generate-pdf/${widget.user.id}/$eventId',
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${widget.user.token}"
        });

    if (response.statusCode != 200) {
      throw Exception('Falha ao baixar o arquivo PDF');
    }

    final bytes = response.bodyBytes;
    final directory = await getDownloadsDirectory();
    final file = File('${directory?.path}/certificado.pdf');
    await file.writeAsBytes(bytes);

    if (await file.exists()) {
      await Process.run('cmd', ['/c', 'start', file.path]);
    } else {
      throw Exception('Arquivo não encontrado');
    }
  }
}
