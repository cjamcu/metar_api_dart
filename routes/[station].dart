import 'package:dart_frog/dart_frog.dart';
import 'package:http/http.dart' as http;

Future<Response> onRequest(RequestContext context, String station) async {
  final stationUpper = station.toUpperCase();

  final headerResponse = {
    'Content-Type': 'text/plain; charset=utf-8',
  };

  if (stationUpper.length < 4) {
    return Response(
      statusCode: 400,
      headers: headerResponse,
      body: 'La estación debe tener al menos 4 caracteres',
    );
  }

  final url =
      'https://tgftp.nws.noaa.gov/data/observations/metar/stations/$stationUpper.TXT';

  final res = await http.get(Uri.parse(url));

  if (res.statusCode == 200) {
    final metar = res.body.split('\n')[1];
    return Response(
      headers: headerResponse,
      body: metar,
    );
  }

  return Response(
    statusCode: 404,
    headers: headerResponse,
    body: 'No se encontró la estación $stationUpper',
  );
}
