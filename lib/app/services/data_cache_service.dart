import 'package:coronavirus_rest_api_flutter_course/app/repositories/endpoints_data.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/api.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/endpoint_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataCacheService {
  const DataCacheService({required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  static String endpointValueKey(Endpoint endpoint) => '$endpoint/value';
  static String endpointDateKey(Endpoint endpoint) => '$endpoint/date';

  EndpointsData getData() {
    Map<Endpoint, EndpointData> values = {}; 
    for (var endpoint in Endpoint.values) {
      final value = sharedPreferences.getInt(
        endpointValueKey(endpoint),
      );
      final dateString = sharedPreferences.getString(
        endpointDateKey(endpoint),
      );
      final date = DateTime.tryParse(dateString ?? '') ?? DateTime.now();
      values[endpoint] = EndpointData(value: value ?? 0, date: date);
    }
    return EndpointsData(values: values);
  }

  Future<void> setData(EndpointsData endpointsData) async {
    endpointsData.values.forEach(
      (endpoint, endpointData) async {
        await sharedPreferences.setInt(
          endpointValueKey(endpoint),
          endpointData.value,
        );

        await sharedPreferences.setString(
          endpointDateKey(endpoint),
          endpointData.date.toIso8601String(),
        );
      },
    );
  }
}
