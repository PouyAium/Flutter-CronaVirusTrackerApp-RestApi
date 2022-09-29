import 'dart:io';

import 'package:coronavirus_rest_api_flutter_course/app/repositories/data_repository.dart';
import 'package:coronavirus_rest_api_flutter_course/app/repositories/endpoints_data.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/api.dart';
import 'package:coronavirus_rest_api_flutter_course/ui/endpoint_card.dart';
import 'package:coronavirus_rest_api_flutter_course/ui/last_updated_status_text.dart';
import 'package:coronavirus_rest_api_flutter_course/ui/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  EndpointsData _endpointsData = const EndpointsData(
    values: {},
  );

  Future<void> _updateData() async {
    try {
      final dataRepository = Provider.of<DataRepository>(
        context,
        listen: false,
      );
      final endpointsData = await dataRepository.getAllEndpointsData();

      setState(
        () {
          _endpointsData = endpointsData;
        },
      );
    } on SocketException catch (_) {
      await showAlertDialog(
        context: context,
        title: 'Connection Error',
        content: 'Could not retrieve data, please try again later.',
        defaultText: 'Ok',
      );
    } catch (_) {
      await showAlertDialog(
        context: context,
        title: 'Unknown Error',
        content: 'Please contact support or try again later.',
        defaultText: 'Ok',
      );
    }
  }

  @override
  void initState() {
    final dataRepository = Provider.of<DataRepository>(
      context,
      listen: false,
    );
    _updateData();
    _endpointsData = dataRepository.getAllEndpointsCachedData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = LastUpdatedDateFormatter(
      lastUpdated:
          _endpointsData.values[Endpoint.cases]?.date ?? DateTime.now(),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Coronavirus Tracker',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _updateData,
        child: ListView(
          children: [
            const SizedBox(height: 4.0),
            LastUpdatedStatusText(
              text: formatter.lastUpdatedStatusText(),
            ),
            for (var endpoint in Endpoint.values)
              EndpointCard(
                endpoint: endpoint,
                value: _endpointsData.values[endpoint]?.value ?? 0,
              ),
          ],
        ),
      ),
    );
  }
}
