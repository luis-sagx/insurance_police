import 'package:flutter/material.dart';
import 'view/pages/propietario_page.dart';
import 'view/pages/automovil_page.dart';
import 'view/pages/poliza_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seguros',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const AutomovilPage(),
    const PolizaPage(),
    const PropietarioPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Pólizas'),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Automóviles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Propietarios',
          ),
        ],
      ),
    );
  }
}
