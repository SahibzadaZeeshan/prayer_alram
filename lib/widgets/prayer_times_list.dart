import 'package:flutter/material.dart';

class PrayerTimesList extends StatelessWidget {
  final List<dynamic> prayerTimes;

  PrayerTimesList({required this.prayerTimes});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade900,
            Colors.blue.shade500,
            Colors.blue.shade300],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ListView.builder(
        itemCount: prayerTimes.length,
        padding: EdgeInsets.symmetric(vertical: 16.0),
        itemBuilder: (context, index) {
          final day = prayerTimes[index];

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 6.0,
              shadowColor: Colors.black26,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.blue.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Day Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Day ${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        Icon(Icons.access_time, color: Colors.blue.shade700, size: 28),
                      ],
                    ),
                    SizedBox(height: 10.0),

                    // Prayer Times
                    _buildPrayerTimeRow(Icons.wb_twighlight, "Fajr", day['timings']['Fajr']),
                    _buildPrayerTimeRow(Icons.wb_sunny, "Dhuhr", day['timings']['Dhuhr']),
                    _buildPrayerTimeRow(Icons.wb_cloudy, "Asr", day['timings']['Asr']),
                    _buildPrayerTimeRow(Icons.nightlight_round, "Maghrib", day['timings']['Maghrib']),
                    _buildPrayerTimeRow(Icons.brightness_3, "Isha", day['timings']['Isha']),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPrayerTimeRow(IconData icon, String prayerName, String time) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade700, size: 22),
          SizedBox(width: 10),
          Text(
            '$prayerName: $time',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
