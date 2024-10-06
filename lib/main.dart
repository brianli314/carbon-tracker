
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:tracker_app/auth/auth.dart';
import 'package:tracker_app/firebase_options.dart';
import 'package:tracker_app/pages/emission_page.dart';
import 'package:tracker_app/pages/test_page.dart';
import 'package:tracker_app/services/database_provider.dart';
import 'package:tracker_app/units.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tracker_app/themes.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ChangeNotifierProvider(create: (context) => DatabaseProvider()),
    ChangeNotifierProvider(create: (context) => UnitsProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime lastUpdated = DateTime.now();
  final locationController = Location();
  LocationData? lastLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await fetchLocationUpdates());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthPage(),
        '/emissions': (context) => const EmissionPage(),
        '/test': (context) => const TestPage()
      },
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }

  Future<void> fetchLocationUpdates() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    User? user = FirebaseAuth.instance.currentUser;
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await locationController.serviceEnabled();

    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((location) async {
      if (location.latitude != null && location.longitude != null) {
        if (lastLocation == null || lastLocation!.latitude == null || lastLocation!.longitude == null){
          lastLocation = location;
        } else {
          double distance = Geolocator.distanceBetween(
            location.latitude!, 
            location.longitude!,
            lastLocation!.latitude!, 
            lastLocation!.longitude!, 
            
          );
          
          print(distance);
          double speed = distance / DateTime.now().difference(lastUpdated).inSeconds;
          String? type = transportationType(speed);

          if (type != null && user != null){
            await provider.addMileage(user.uid, distance/1000, type);
          }
          lastLocation = location;
          lastUpdated = DateTime.now();
        }
      }
    });
  }
  
  

  String? transportationType(double speedMps) {
    // Define the speed ranges in m/s
    if (speedMps > 0 && speedMps <= 1.7) {
      return "Walk";
    } else if (speedMps > 1.7 && speedMps <= 3) {
      return "Bike";
    } else if (speedMps > 3 && speedMps <= 40) {
      return "Car";
    } else if (speedMps > 150) {
      return "Plane";
    }
    return null; 
  }
}
