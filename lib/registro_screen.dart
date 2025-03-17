import 'package:flutter/material.dart';
import 'database_helper.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  String _sexo = 'Hombre';
  DateTime _fecha = DateTime.now();

  void _guardarRegistro() async {
    if (_formKey.currentState!.validate()) {
      final registro = {
        'nombre': _nombreController.text,
        'sexo': _sexo,
        'fecha': _fecha.toIso8601String(),
        'telefono': '',
        'direccion': '',
        'esCristiano': 0,
        'asisteOtraIglesia': 0,
        'notas': '',
      };
      await DatabaseHelper().insertRegistro(registro);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registro guardado')));
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nombreController, decoration: const InputDecoration(labelText: 'Nombre'), validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null),
              DropdownButtonFormField(
                value: _sexo,
                items: ['Hombre', 'Mujer'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (value) => setState(() => _sexo = value!),
                decoration: const InputDecoration(labelText: 'Sexo'),
              ),
              ElevatedButton(
                onPressed: _guardarRegistro,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
