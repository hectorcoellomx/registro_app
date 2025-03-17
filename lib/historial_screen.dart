import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'detalle_registros_screen.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  _HistorialScreenState createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  Map<String, List<Map<String, dynamic>>> _registrosAgrupados = {};

  @override
  void initState() {
    super.initState();
    _cargarRegistros();
  }

  Future<void> _cargarRegistros() async {
    List<Map<String, dynamic>> registros = await DatabaseHelper().getRegistros();
    Map<String, List<Map<String, dynamic>>> agrupados = {};

    for (var registro in registros) {
      String fecha = registro['fecha'].substring(0, 10);
      if (!agrupados.containsKey(fecha)) {
        agrupados[fecha] = [];
      }
      agrupados[fecha]!.add(registro);
    }

    setState(() {
      _registrosAgrupados = agrupados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial')),
      body: ListView(
        children: _registrosAgrupados.entries.map((entry) {
          return ListTile(
            title: Text("${entry.key} (${entry.value.length})"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetalleRegistrosScreen(fecha: entry.key, registros: entry.value, onUpdate: _cargarRegistros)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
