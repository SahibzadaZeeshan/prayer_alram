import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:intl/intl.dart';
import 'services/location_service.dart';
import 'services/prayer_times_service.dart';
import 'services/notification_service.dart';
import 'widgets/prayer_times_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isNotificationAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isNotificationAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  AwesomeNotifications().initialize(
    'resource://drawable/app_icon',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for prayer reminders',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,

      )
    ],
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prayer Times',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16.0),
        ),
      ),
      home: PrayerTimesScreen(),
    );
  }
}

class PrayerTimesScreen extends StatefulWidget {
  @override
  _PrayerTimesScreenState createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  final LocationService _locationService = LocationService();
  final PrayerTimesService _prayerTimesService = PrayerTimesService();
  final NotificationService _notificationService = NotificationService();

  List<dynamic> _prayerTimes = [];

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  Future<void> _checkNotificationPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    _notificationService.initNotifications();

    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    bool permissionGranted = await _locationService.requestLocationPermission();

    if (permissionGranted) {
      _fetchPrayerTimes(); //  Fetch prayer times only if location is allowed
    } else {
      print("User denied location permission. Skipping prayer time fetch.");
    }
  }

  Future<void> _fetchPrayerTimes() async {
    try {
      final position = await _locationService.getCurrentLocation();
      final prayerTimes = await _prayerTimesService.fetchPrayerTimes(
          position.latitude, position.longitude, DateTime.now().month, DateTime.now().year);

      setState(() {
        _prayerTimes = prayerTimes;
      });

      _schedulePrayerNotifications(prayerTimes);
    } catch (e) {
      print("Error fetching prayer times: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _schedulePrayerNotifications(List<dynamic> prayerTimes) {
    for (var day in prayerTimes) {
      String dateString = day['date']['gregorian']['date']; // e.g., "01-02-2025"
      String fajrTime = day['timings']['Fajr']; // e.g., "05:53 (PKT)"

      fajrTime = fajrTime.split(" ")[0];

      List<String> dateParts = dateString.split("-");
      String formattedDate = "${dateParts[2]}-${dateParts[1]}-${dateParts[0]}"; // YYYY-MM-DD

      String finalDateTimeString = "$formattedDate $fajrTime";

      try {
        DateTime finalDateTime = DateFormat("yyyy-MM-dd HH:mm").parse(finalDateTimeString);
        _notificationService.scheduleNotification('Prayer Time', 'It\'s time for Fajr prayer', finalDateTime);
      } catch (e) {
        print("Error parsing date: $e");
      }
    }
  }

  void _showAwesomeNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'Prayer Time',
        body: 'It\'s Prayer Time',

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 6.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.blue.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        title: Text(
          'Prayer Times',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: PrayerTimesList(prayerTimes: _prayerTimes),
      floatingActionButton: GestureDetector(
        onTap: _showAwesomeNotification,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.blue.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade700.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
            child: Icon(Icons.notifications, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}


