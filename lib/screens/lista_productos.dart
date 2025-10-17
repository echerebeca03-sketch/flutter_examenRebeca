import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/inventario_service.dart';
import 'agregar_producto.dart';
import 'editar_producto.dart';
import 'detalle_producto.dart';

// 🟪 Pantalla principal del inventario
// Aquí se muestran todos los productos, con búsqueda, indicadores visuales
// y las opciones para agregar, editar, eliminar o ver detalles.
class ListaProductosScreen extends StatefulWidget {
  const ListaProductosScreen({super.key});

  @override
  State<ListaProductosScreen> createState() => _ListaProductosScreenState();
}

class _ListaProductosScreenState extends State<ListaProductosScreen> {
  // Lista de productos obtenidos desde la API
  List<Producto> productos = [];

  // Controladores y variables para la búsqueda
  final TextEditingController _searchController = TextEditingController();
  String _busqueda = '';

  // Control de carga y errores
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    // Cuando se abre la app, se cargan los productos del servidor
    cargarProductos();
  }

  // 🔄 Función que obtiene los productos desde la API PHP
  Future<void> cargarProductos() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });
      final productosObtenidos = await InventarioService.obtenerProductos();
      setState(() {
        productos = productosObtenidos;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  // ❌ Función para eliminar un producto con confirmación
  Future<void> _eliminarProducto(Producto producto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFF3E5F5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Eliminar producto',
          style: TextStyle(color: Color(0xFF4A148C), fontWeight: FontWeight.bold),
        ),
        content: Text('¿Seguro que deseas eliminar "${producto.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B1FA2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      final success = await InventarioService.eliminarProducto(producto.id);
      if (success) cargarProductos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8ECFF),

      // 🔹 Barra superior
      appBar: AppBar(
        title: const Text('Inventario de Tienda'),
        centerTitle: true,
        elevation: 4,
        backgroundColor: const Color(0xFF8E24AA),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),

      // 📋 Cuerpo principal
      body: _buildContent(),

      // 🔘 Botón flotante para agregar productos
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AgregarProductoScreen()),
          );
          cargarProductos();
        },
        label: const Text('Agregar'),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF8E24AA),
      ),
    );
  }

  // 🧩 Construye el contenido principal dependiendo del estado
  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF8E24AA)));
    }
    if (error != null) {
      return Center(child: Text('Error: $error'));
    }
    if (productos.isEmpty) {
      return const Center(
        child: Text(
          'No hay productos aún',
          style: TextStyle(fontSize: 16, color: Color(0xFF4A148C)),
        ),
      );
    }

    // 🌸 Fondo con degradado suave
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF3E5F5), Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // 🔍 Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (valor) {
                setState(() => _busqueda = valor.toLowerCase());
              },
              decoration: InputDecoration(
                hintText: 'Buscar producto por nombre o código...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF8E24AA)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // 📋 Lista de productos
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];

                // 🔍 Filtro por nombre o código de barras
                if (_busqueda.isNotEmpty &&
                    !producto.nombre.toLowerCase().contains(_busqueda) &&
                    !producto.codigoBarras.toLowerCase().contains(_busqueda)) {
                  return const SizedBox.shrink(); // No muestra si no coincide
                }

                // 🟣 Tarjeta para cada producto
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                    // 🧺 Icono que cambia según el stock
                    leading: CircleAvatar(
                      backgroundColor: producto.stock < 10
                          ? Colors.redAccent
                          : const Color(0xFFCE93D8),
                      radius: 26,
                      child: Icon(
                        producto.stock < 10
                            ? Icons.warning_amber_rounded
                            : Icons.inventory_2_rounded,
                        color: Colors.white,
                      ),
                    ),

                    // 🟣 Nombre del producto
                    title: Text(
                      producto.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A148C),
                        fontSize: 16,
                      ),
                    ),

                    // 🧾 Detalles y etiquetas visuales
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Código: ${producto.codigoBarras}\nPrecio: \$${producto.precio.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                        const SizedBox(height: 4),

                        // 📊 Indicadores visuales
                        Row(
                          children: [
                            if (producto.stock < 10)
                              const Text(
                                '⚠️ Stock bajo  ',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            Text(
                              producto.activo ? '🟢 Activo' : '🔴 Inactivo',
                              style: TextStyle(
                                color: producto.activo
                                    ? Colors.green
                                    : Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // ✏️ Botones para editar y eliminar
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Color(0xFF7E57C2)),
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditarProductoScreen(producto: producto),
                              ),
                            );
                            cargarProductos();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.redAccent),
                          onPressed: () => _eliminarProducto(producto),
                        ),
                      ],
                    ),

                    // 👁️ Al tocar la tarjeta, se abre el detalle del producto
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              DetalleProductoScreen(producto: producto),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
