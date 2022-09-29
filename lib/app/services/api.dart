import 'package:coronavirus_rest_api_flutter_course/app/services/api_keys.dart';

enum Endpoint {
  cases,
  casesSuspected,
  casesConfirmed,
  deaths,
  recovered,
}

class API {
  const API({required this.apiKey});
  final String apiKey;

  factory API.sandbox() => API(apiKey: APIkeys.ncovSandboxKey);

  static const String host = 'ncov2019-admin.firebaseapp.com';

  /*
  See Screen shot at the first of opening the project
   and understand what we are going to do in these line of code.
  */

  Uri getTokenUri() => Uri(
        host: host,
        scheme: 'https',
        path: 'token',
      );

  Uri getEndpointUri(Endpoint endpoint) => Uri(
        host: host,
        scheme: 'https',
        path: _paths[endpoint],
      );

  static const Map<Endpoint, String> _paths = {
    Endpoint.cases: 'cases',
    Endpoint.casesSuspected: 'casesSuspected',
    Endpoint.casesConfirmed: 'casesConfirmed',
    Endpoint.deaths: 'deaths',
    Endpoint.recovered: 'recovered',
  };
}
