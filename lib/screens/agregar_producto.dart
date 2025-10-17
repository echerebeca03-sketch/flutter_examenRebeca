import 'package:flutter/material.dart';
import '../services/inventario_service.dart';

// Pantalla para AGREGAR un nuevo producto al inventario
// Aquí el usuario puede llenar los campos y guardar un producto nuevo en la base de datos.
class AgregarProductoScreen extends StatefulWidget {
  const AgregarProductoScreen({super.key});

  @override
  State<AgregarProductoScreen> createState() => _AgregarProductoScreenState();
}

class _AgregarProductoScreenState extends State<AgregarProductoScreen> {
  // Clave global para validar el formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores para capturar los valores de los TextFields
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final codigoController = TextEditingController();
  final categoriaController = TextEditingController();
  final precioController = TextEditingController();
  final stockController = TextEditingController();
  final proveedorController = TextEditingController();

  //  Función que guarda el producto llamando al servicio de la API
  Future<void> _guardarProducto() async {
    if (_formKey.currentState!.validate()) {
      // Se preparan los datos que se enviarán al backend
      final data = {
        'nombre': nombreController.text,
        'descripcion': descripcionController.text,
        'codigo_barras': codigoController.text,
        'categoria': categoriaController.text,
        'precio': precioController.text,
        'stock': stockController.text,
        'proveedor': proveedorController.text,
        'activo': '1', // por defecto, activo
      };

      // Se llama al servicio PHP para guardar
      final success = await InventarioService.crearProducto(data);

      // Si todo sale bien, volvemos a la pantalla anterior
      if (success && mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),

      // Barra superior con color morado y título centrado
      appBar: AppBar(
        title: const Text('Agregar Producto'),
        centerTitle: true,
        backgroundColor: const Color(0xFF8E24AA),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),

      //  Cuerpo principal del formulario
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campos de texto (nombre, código, categoría, etc.)
              _input('Nombre del producto', nombreController),
              _input('Código de Barras', codigoController),
              _input('Categoría', categoriaController),
              _input('Proveedor', proveedorController),
              _input('Descripción', descripcionController, lines: 3),
              _input('Precio', precioController, type: TextInputType.number),
              _input('Stock', stockController, type: TextInputType.number),

              const SizedBox(height: 20),

              // Botón morado redondeado para guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _guardarProducto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8E24AA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Guardar Producto',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  Función auxiliar que crea cada campo de texto con estilo uniforme
  Widget _input(String label, TextEditingController controller,
      {int lines = 1, TextInputType? type}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        maxLines: lines,
        keyboardType: type,
        validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Color(0xFF6A1B9A)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF8E24AA), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
