import 'package:coronavirus_rest_api_flutter_course/app/services/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EndpointCardData {
  const EndpointCardData({
    required this.title,
    required this.imageUrl,
    required this.color,
  });

  final String title;
  final String imageUrl;
  final Color color;
}

class EndpointCard extends StatelessWidget {
  const EndpointCard({
    Key? key,
    required this.endpoint,
    required this.value,
  }) : super(key: key);

  final Endpoint endpoint;
  final int value;

  static const Map<Endpoint, EndpointCardData> _cardData = {
    Endpoint.cases: EndpointCardData(
      title: 'Cases',
      imageUrl: 'assets/count.png',
      color: Color(0xFFFFF492),
    ),
    Endpoint.casesSuspected: EndpointCardData(
      title: 'Suspected Cases',
      imageUrl: 'assets/suspect.png',
      color: Color(0xFFEEDA28),
    ),
    Endpoint.casesConfirmed: EndpointCardData(
      title: 'Confirmed Cases',
      imageUrl: 'assets/fever.png',
      color: Color(0xFFE99600),
    ),
    Endpoint.deaths: EndpointCardData(
      title: 'Deaths',
      imageUrl: 'assets/death.png',
      color: Color(0xFFE40000),
    ),
    Endpoint.recovered: EndpointCardData(
      title: 'Recovered',
      imageUrl: 'assets/patient.png',
      color: Color(0xFF70A901),
    ),
  };

  String get formattedValue {
    return NumberFormat('#,###,###,###').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final cardData = _cardData[endpoint];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cardData!.title,
                style: TextStyle(
                  color: cardData.color,
                  fontSize: 24.0,
                ),
              ),
              const SizedBox(height: 4.0),
              SizedBox(
                height: 52,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      cardData.imageUrl,
                      color: cardData.color,
                    ),
                    Text(
                      formattedValue,
                      style: TextStyle(
                        color: cardData.color,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
