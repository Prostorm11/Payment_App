import 'package:flutter/material.dart';
import 'package:fee_payment_app/Dashboard/dashboard.dart';
import 'package:fee_payment_app/Payment/payment.dart';
import 'package:fee_payment_app/Profile/profile.dart';
import 'package:fee_payment_app/Receipt/receipt.dart';
import 'package:fee_payment_app/Refund/refund.dart';

void main() {
  runApp(const MyApp());
}

/// Color palette for the app
class AppColors {
  static const primary = Color(0xFF1976D2);
  static const textPrimary = Color(0xFF1a4971);
  static const textSecondary = Color(0xFF6d93b8);
  static const textDark = Color(0xFF0d2b43);
  static const placeholderText = Color(0xFF767676);
  static const background = Color(0xFFe3f2fd);
  static const cardBackground = Color(0xFFf5f9ff);
  static const inputBackground = Color(0xFFf0f8ff);
  static const border = Color(0xFFbbdefb);
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fee Payment App',
      debugShowCheckedModeBanner: false,

      // Light theme
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        cardColor: AppColors.cardBackground,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: AppColors.inputBackground,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.border),
          ),
        ),
        /* textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
        ), */
        iconTheme: const IconThemeData(color: AppColors.textDark),
        dividerColor: AppColors.border,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.placeholderText,
        ),
      ),

      // Dark theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.textDark,
        cardColor: AppColors.black,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: AppColors.textPrimary,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.border),
          ),
        ),
        /* textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.white),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
        ), */
        iconTheme: const IconThemeData(color: AppColors.white),
        dividerColor: AppColors.border,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.textPrimary,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.placeholderText,
        ),
      ),

      themeMode: ThemeMode.system,
      home: const EntryScreen(),
    );
  }
}

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    PaymentScreen(),
    RefundScreen(),
    ReceiptScreen(),
    ProfileScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onTabSelected,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
            BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: "Payment"),
            BottomNavigationBarItem(icon: Icon(Icons.refresh), label: "Refund"),
            BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Receipt"),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
