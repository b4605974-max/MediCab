
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/sign_in_screen.dart';
import 'screens/create_account_screen.dart';
import 'screens/account_created_screen.dart';
import 'screens/home_dashboard_screen.dart';
import 'screens/digital_cabinet_screen.dart';
import 'screens/medicine_schedule_screen.dart';
import 'screens/medicine_reminders_screen.dart';
import 'screens/intake_history_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/notification_preferences_screen.dart';
import 'screens/user_profile_screen.dart';
import 'screens/add_edit_medicine_screen.dart';
import 'screens/add_edit_schedule_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MediCabApp());
}

class MediCabApp extends StatelessWidget {
  const MediCabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediCab Smart Medicine Cabinet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/sign-in',
      routes: {
        '/sign-in': (context) => const SignInScreen(),
        '/create-account': (context) => const CreateAccountScreen(),
        '/account-created': (context) => const AccountCreatedScreen(),
        '/home': (context) => const HomeDashboardScreen(),
        '/cabinet': (context) => const DigitalCabinetScreen(),
        '/schedule': (context) => const MedicineScheduleScreen(),
        '/reminders': (context) => const MedicineRemindersScreen(),
        '/history': (context) => const IntakeHistoryScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/notification-preferences': (context) =>
            const NotificationPreferencesScreen(),
        '/profile': (context) => const UserProfileScreen(),
        '/add-medicine': (context) => const AddEditMedicineScreen(),
        '/add-schedule': (context) => const AddEditScheduleScreen(),
      },
    );
  }
}
