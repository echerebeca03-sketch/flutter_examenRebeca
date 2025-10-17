import 'package:flutter/material.dart';
import 'screens/lista_productos.dart';

//  Archivo principal de la app
// Aquí se configura el tema general (colores, estilo) y se define la pantalla inicial.
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 🔹 Oculta el banner de debug
      title: 'Gestión de Inventario',

      //  Tema general de la app (colores moraditos 💜)
      theme: ThemeData(
        primaryColor: const Color(0xFF8E24AA),
        scaffoldBackgroundColor: const Color(0xFFF3E5F5),

        //  Color principal (para botones, barras, etc.)
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8E24AA),
          primary: const Color(0xFF8E24AA),
          secondary: const Color(0xFFBA68C8),
        ),

        //  Personalizamos AppBars
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8E24AA),
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
        ),

        //  Botón flotante (FAB)
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF8E24AA),
          foregroundColor: Colors.white,
        ),

        //  Botones generales (ElevatedButtons)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8E24AA),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),

        //  Estilo de los campos de texto
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF8E24AA), width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF6A1B9A)),
        ),
      ),

      //  Pantalla de inicio de la aplicación
      home: const ListaProductosScreen(),
    );
  }
}
