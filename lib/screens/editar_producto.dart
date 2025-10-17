import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/inventario_service.dart';

// Pantalla para EDITAR un producto existente
// Permite modificar los datos de un producto y actualizar la información en la base de datos.
class EditarProductoScreen extends StatefulWidget {
  final Producto producto;

  const EditarProductoScreen({super.key, required this.producto});

  @override
  State<EditarProductoScreen> createState() => _EditarProductoScreenState();
}

class _EditarProductoScreenState extends State<EditarProductoScreen> {
  // Clave global del formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos
  late TextEditingController nombreController;
  late TextEditingController descripcionController;
  late TextEditingController categoriaController;
  late TextEditingController precioController;
  late TextEditingController stockController;
  late TextEditingController proveedorController;

  // Estado del producto (activo o inactivo)
  late bool activo;

  @override
  void initState() {
    super.initState();

    // Se inicializan los controladores con los datos actuales del producto
    final p = widget.producto;
    nombreController = TextEditingController(text: p.nombre);
    descripcionController = TextEditingController(text: p.descripcion);
    categoriaController = TextEditingController(text: p.categoria);
    precioController = TextEditingController(text: p.precio.toString());
    stockController = TextEditingController(text: p.stock.toString());
    proveedorController = TextEditingController(text: p.proveedor);
    activo = p.activo;
  }

  // Función que guarda los cambios llamando al servicio de la API
  Future<void> _actualizar() async {
    if (_formKey.currentState!.validate()) {
      // Se preparan los datos actualizados
      final data = {
        'nombre': nombreController.text,
        'descripcion': descripcionController.text,
        'categoria': categoriaController.text,
        'precio': precioController.text,
        'stock': stockController.text,
        'proveedor': proveedorController.text,
        'activo': activo ? '1' : '0',
      };

      // Se llama al servicio PHP para guardar los cambios
      final success = await InventarioService.actualizarProducto(widget.producto.id, data);

      // Si la actualización fue exitosa, se regresa a la lista
      if (success && mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),

      // AppBar morado con esquinas redondeadas
      appBar: AppBar(
        title: const Text('Editar Producto'),
        centerTitle: true,
        backgroundColor: const Color(0xFF8E24AA),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),

      // Formulario principal
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campos de texto para editar los datos
              _input('Nombre', nombreController),
              _input('Categoría', categoriaController),
              _input('Proveedor', proveedorController),
              _input('Descripción', descripcionController, lines: 3),
              _input('Precio', precioController, type: TextInputType.number),
              _input('Stock', stockController, type: TextInputType.number),

              const SizedBox(height: 10),

              //  Switch para activar o desactivar el producto
              SwitchListTile(
                title: const Text(
                  'Activo',
                  style: TextStyle(color: Color(0xFF4A148C), fontWeight: FontWeight.w600),
                ),
                value: activo,
                onChanged: (v) => setState(() => activo = v),
                activeColor: const Color(0xFF8E24AA),
              ),

              const SizedBox(height: 20),

              // Botón para guardar los cambios
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _actualizar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8E24AA),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Actualizar Producto',
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

  //  Crea un campo de texto con diseño uniforme
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
