import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  final String baseUrl = '177.44.248.80:';

  HttpService();

  get convert => null;

  Future<http.Response> post(String port, String endpoint,
      {required Map<String, String> headers, dynamic body}) async {
    var url = Uri.http(baseUrl + port, endpoint);
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> get(String port, String endpoint,
      {required Map<String, String> headers}) async {
    var url = Uri.http(baseUrl + port, endpoint);
    final response = await http.get(url, headers: headers);
    return response;
  }

  Future<http.Response> delete(String port, String endpoint,
      {required Map<String, String> headers,
      required Map<String, String> body}) async {
    var url = Uri.http(baseUrl + port, endpoint);
    final response =
        await http.delete(url, headers: headers, body: json.encode(body));
    return response;
  }

  Future<http.Response> put(String port, String endpoint,
      {required Map<String, String> headers,
      required Map<String, dynamic> body}) async {
    var url = Uri.http(baseUrl + port, endpoint);
    final response =
        await http.put(url, headers: headers, body: json.encode(body));
    return response;
  }
}
