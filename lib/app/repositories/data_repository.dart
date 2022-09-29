import 'package:coronavirus_rest_api_flutter_course/app/repositories/endpoints_data.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/api.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/api_service.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/data_cache_service.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/endpoint_data.dart';
import 'package:http/http.dart';

class DataRepository {
  DataRepository({
    required this.apiService,
    required this.dataCacheService,
  });
  final APIService apiService;
  final DataCacheService dataCacheService;

  String accessToken = '';
  Future<EndpointData> getEndpointData(Endpoint endpoint) async =>
      await _getDataRefreshingToken<EndpointData>(
        onGetData: () => apiService.getEndpointData(
            accessToken: accessToken, endpoint: endpoint),
      );

  EndpointsData getAllEndpointsCachedData() => dataCacheService.getData();

  Future<EndpointsData> getAllEndpointsData() async {
    final endpointsData = await _getDataRefreshingToken<EndpointsData>(
      onGetData: _getAllEndpointsData,
    );
    dataCacheService.setData(endpointsData);
    return endpointsData;
  }

  Future<T> _getDataRefreshingToken<T>(
      {required Future<T> Function() onGetData}) async {
    try {
      accessToken = await apiService.getAccessToken();
      return await onGetData();
    } on Response catch (response) {
      // if unauthorized, get access token again
      if (response.statusCode == 401) {
        accessToken = await apiService.getAccessToken();
        return await onGetData();
      }
      rethrow;
    }
  }

  Future<EndpointsData> _getAllEndpointsData() async {
    // final cases = await apiService.getEndpointData(
    //   accessToken: accessToken,
    //   endpoint: Endpoint.cases,
    // );
    // final casesSuspected = await apiService.getEndpointData(
    //   accessToken: accessToken,
    //   endpoint: Endpoint.casesSuspected,
    // );
    // final casesConfirmed = await apiService.getEndpointData(
    //   accessToken: accessToken,
    //   endpoint: Endpoint.casesConfirmed,
    // );
    // final deaths = await apiService.getEndpointData(
    //   accessToken: accessToken,
    //   endpoint: Endpoint.deaths,
    // );
    // final recovered = await apiService.getEndpointData(
    //   accessToken: accessToken,
    //   endpoint: Endpoint.recovered,
    // );

    // All futures executed in parallel(concurrently)
    // When all futures have completed, result is returned.
    final List<EndpointData> values = await Future.wait(
      [
        apiService.getEndpointData(
          accessToken: accessToken,
          endpoint: Endpoint.cases,
        ),
        apiService.getEndpointData(
          accessToken: accessToken,
          endpoint: Endpoint.casesSuspected,
        ),
        apiService.getEndpointData(
          accessToken: accessToken,
          endpoint: Endpoint.casesConfirmed,
        ),
        apiService.getEndpointData(
          accessToken: accessToken,
          endpoint: Endpoint.deaths,
        ),
        apiService.getEndpointData(
          accessToken: accessToken,
          endpoint: Endpoint.recovered,
        ),
      ],
    );

    return EndpointsData(
      values: {
        Endpoint.cases: values[0],
        Endpoint.casesSuspected: values[1],
        Endpoint.casesConfirmed: values[2],
        Endpoint.deaths: values[3],
        Endpoint.recovered: values[4],
      },
    );
  }
}
