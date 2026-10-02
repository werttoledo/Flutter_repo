import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/role_selection_screen.dart';
import 'screens/login_screen.dart';
import 'screens/collaborator_panel.dart';
import 'screens/equipment_reservation_screen.dart';
import 'screens/salon_reservation_screen.dart';
import 'screens/reservation_history_screen.dart';
import 'screens/equipment_rental_screen.dart';
import 'screens/payment_gateway_screen.dart';
import 'screens/classroom_management_screen.dart';
import 'theme/app_theme.dart';
import 'providers/reservation_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme(),
      initialRoute: '/role',
      routes: {
        '/role': (context) => RoleSelectionScreen(),
        '/login': (context) => LoginScreen(),
        '/collaborator': (context) => CollaboratorPanel(),
        '/equipment': (context) => EquipmentReservationScreen(),
        '/salon': (context) => SalonReservationScreen(),
        '/history': (context) => ReservationHistoryScreen(),
        '/rental': (context) => EquipmentRentalScreen(),
        '/payment': (context) => PaymentGatewayScreen(),
        '/classrooms': (context) => ClassroomManagementScreen(),
      },
    );
  }
}