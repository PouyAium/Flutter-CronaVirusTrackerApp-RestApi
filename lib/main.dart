import 'package:coronavirus_rest_api_flutter_course/app/repositories/data_repository.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/api.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/api_service.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/data_cache_service.dart';
import 'package:coronavirus_rest_api_flutter_course/ui/dashboard.dart'; 
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'en_US';
  await initializeDateFormatting();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  runApp(
    MyApp(
      sharedPreferences: sharedPreferences,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.sharedPreferences}) : super(key: key);

  final SharedPreferences sharedPreferences;
  @override
  Widget build(BuildContext context) {
    return Provider<DataRepository>(
      create: (context) => DataRepository(
        dataCacheService: DataCacheService(
          sharedPreferences: sharedPreferences,
        ),
        apiService: APIService(
          api: API.sandbox(),
        ),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Coronavirus Tracker',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF101010),
          cardColor: const Color(0xFF222222),
        ),
        home: const Dashboard(),
      ),
    );
  }
}