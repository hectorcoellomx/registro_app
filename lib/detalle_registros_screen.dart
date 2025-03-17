import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalleRegistrosScreen extends StatelessWidget {
  final String fecha;
  final List<Map<String, dynamic>> registros;
  final VoidCallback onUpdate;

  const DetalleRegistrosScreen({super.key, required this.fecha, required this.registros, required this.onUpdate});

  Future<void> _eliminarRegistro(BuildContext context, int id) async {
    await DatabaseHelper().deleteRegistro(id);
    onUpdate();
    Navigator.pop(context);
  }

  void _compartirPorWhatsApp() async {
    String mensaje = "Registros del $fecha:\n\n";
    for (var registro in registros) {
      mensaje += "Nombre: ${registro['nombre']}, Sexo: ${registro['sexo']}\n";
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
                onPressed: () => _eliminarRegistro(context, registro['id']),
              ),
            ),
          );
        },
      ),
    );
  }
}
