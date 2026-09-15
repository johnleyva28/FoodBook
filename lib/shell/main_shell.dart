import 'package:flutter/material.dart';

import '../../features/ajustes/screens/settings_screen.dart';
import '../../features/cuentas/screens/accounts_screen.dart';
import '../../features/historial/screens/history_screen.dart';
import '../../features/perfil/screens/profile_screen.dart';
import '../../features/principal/screens/daily_screen.dart';

/// Shell principal con la barra de navegación de 5 botones:
/// | Cuentas | Historial | Principal | Perfil | Ajustes |
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 2; // Empieza en "Principal" (centro)

  static const _screens = [
    AccountsScreen(), // 0
    HistoryScreen(), // 1
    DailyScreen(), // 2 (centro)
    ProfileScreen(), // 3
    SettingsScreen(), // 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Cuentas',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Historial',
          ),
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Principal',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}
