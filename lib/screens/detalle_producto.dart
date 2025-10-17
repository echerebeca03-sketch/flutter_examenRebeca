import 'package:flutter/material.dart';
import '../models/producto.dart';

//  Pantalla de DETALLE DE PRODUCTO
// Aquí se muestra toda la información del producto seleccionado desde la lista.
class DetalleProductoScreen extends StatelessWidget {
  final Producto producto;

  const DetalleProductoScreen({super.key, required this.producto});

  // 🔧 Widget reutilizable para mostrar cada dato del producto en formato bonito
  Widget _info(String label, String value, IconData icon) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF7B1FA2), size: 28),
        title: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A148C),
            fontSize: 15,
          ),
        ),
        subtitle: Text(label, style: const TextStyle(color: Colors.black54)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),

      //  Barra superior morada
      appBar: AppBar(
        title: const Text('Detalle del Producto'),
        centerTitle: true,
        backgroundColor: const Color(0xFF8E24AA),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),

      //  Contenido del detalle
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Nombre grande del producto
            Text(
              producto.nombre,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A148C),
              ),
            ),

            const SizedBox(height: 15),

            //  Sección con todos los datos del producto
            _info('Descripción', producto.descripcion, Icons.description_outlined),
            _info('Categoría', producto.categoria, Icons.category_outlined),
            _info('Código de Barras', producto.codigoBarras, Icons.qr_code),
            _info('Proveedor', producto.proveedor, Icons.local_shipping_outlined),
            _info('Precio', '\$${producto.precio}', Icons.attach_money),
            _info('Stock', producto.stock.toString(), Icons.inventory_2_rounded),
            _info('Estado', producto.activo ? 'Activo' : 'Inactivo',
                producto.activo ? Icons.check_circle_outline : Icons.cancel_outlined),

            const SizedBox(height: 25),

            //  Botón para volver a la lista
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: const Text(
                  'Volver',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E24AA),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
