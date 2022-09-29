import 'package:coronavirus_rest_api_flutter_course/app/services/api.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/endpoint_data.dart';

class EndpointsData {
  const EndpointsData({required this.values});
  final Map<Endpoint, EndpointData> values;

  EndpointData get cases =>
      values[Endpoint.cases] ??
      EndpointData(
        value: 0,
        date: DateTime.now(),
      );

  EndpointData get casesSuspected =>
      values[Endpoint.casesSuspected] ??
      EndpointData(
        value: 0,
        date: DateTime.now(),
      );

  EndpointData get casesConfirmed =>
      values[Endpoint.casesConfirmed] ??
      EndpointData(
        value: 0,
        date: DateTime.now(),
      );

  EndpointData get deaths =>
      values[Endpoint.deaths] ??
      EndpointData(
        value: 0,
        date: DateTime.now(),
      );

  EndpointData get recovered =>
      values[Endpoint.recovered] ??
      EndpointData(
        value: 0,
        date: DateTime.now(),
      );

  @override
  toString() =>
      'cases: $cases\ncasesSuspected: $casesSuspected\ncasesConfirmed: $casesConfirmed\ndeaths: $deaths\nrecovered: $recovered';
}
