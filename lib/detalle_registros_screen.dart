import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalleRegistrosScreen extends StatelessWidget {
  final String fecha;
  final List<Map<String, dynamic>> registros;
  final VoidCallback onUpdate;

  const DetalleRegistrosScreen({super.key, required this.fecha, required this.registros, required this.onUpdate});

  Future<void> _confirmarEliminacion(BuildContext context, int id, String name) async {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text("Confirmar eliminación"),
        content: Text("¿Estás seguro de que deseas eliminar a '${name.trim()}'? Esta acción no se puede deshacer."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext), // Cerrar el diálogo sin eliminar
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext); // Cerrar el diálogo
              await DatabaseHelper().deleteRegistro(id);
              onUpdate();
              Navigator.pop(context); // Cerrar la pantalla actual después de eliminar
            },
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}


  void _compartirPorWhatsApp() async {
    String mensaje = "Registros del $fecha:\n\n";
    for (var registro in registros) {
      mensaje += "Nombre: ${registro['nombre']}\nSexo: ${registro['sexo']}\n";
      mensaje += "Teléfono: ${registro['telefono']}\nDirección: ${registro['direccion']}\n";
      mensaje += "Cristiano: ${registro['esCristiano'] == 1 ? 'Sí' : 'No'}\n";
      mensaje += "Asiste a otra iglesia: ${registro['asisteOtraIglesia'] == 1 ? 'Sí' : 'No'}\n";
      mensaje += "Notas: ${registro['notas']}\n\n";
      mensaje += "--------\n\n";
    }

    final uri = Uri.parse("whatsapp://send?text=${Uri.encodeComponent(mensaje)}");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print("WhatsApp no está instalado");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registros del $fecha"), actions: [
        IconButton(icon: const Icon(Icons.share), onPressed: _compartirPorWhatsApp),
      ]),
      body: ListView.builder(
        itemCount: registros.length,
        itemBuilder: (context, index) {
          var registro = registros[index];
          return Card(
            child: ListTile(
              title: Text(registro['nombre']),
              subtitle: Text("Sexo: ${registro['sexo']}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmarEliminacion(context, registro['id'], registro['nombre']),
              ),
            ),
          );
        },
      ),
    );
  }
}
