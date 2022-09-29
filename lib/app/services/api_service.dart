import 'dart:convert';

import 'package:coronavirus_rest_api_flutter_course/app/services/endpoint_data.dart';
import 'package:flutter/material.dart';

import 'api.dart';
import 'package:http/http.dart' as http;

class APIService {
  const APIService({required this.api});
  final API api;

  Future<String> getAccessToken() async {
    final http.Response response = await http.post(
      api.getTokenUri(),
      headers: {
        'Authorization': 'Basic ${api.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String accessToken = data['access_token']!;
      return accessToken;
    }
    debugPrint(
      'Request ${api.getTokenUri()} failed\nResponse: ${response.statusCode} ${response.reasonPhrase}',
    );
    throw response;
  }

  Future<EndpointData> getEndpointData({
    required String accessToken,
    required Endpoint endpoint,
  }) async {
    final Uri uri = api.getEndpointUri(endpoint);
    final http.Response response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        final Map<String, dynamic> endpointData = data[0];
        final String responseJsonKey = _responseJsonKeys[endpoint] ?? '';
        final String dateString = endpointData['date'];
        final DateTime date = DateTime.tryParse(dateString) ?? DateTime.now();
        final int value = endpointData[responseJsonKey];
        return EndpointData(value: value, date: date);
      }
    }
    debugPrint(
      'Request ${api.getTokenUri()} failed\nResponse: ${response.statusCode} ${response.reasonPhrase}',
    );
    throw response;
  }

  static const Map<Endpoint, String> _responseJsonKeys = {
    Endpoint.cases: 'cases',
    Endpoint.casesSuspected: 'data',
    Endpoint.casesConfirmed: 'data',
    Endpoint.deaths: 'data',
    Endpoint.recovered: 'data',
  };
}
