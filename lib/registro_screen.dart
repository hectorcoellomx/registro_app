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
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _notasController = TextEditingController();
  String _sexo = 'Hombre';
  DateTime _fecha = DateTime.now();
  bool _esCristiano = false;
  bool _asisteOtraIglesia = false;

  void _guardarRegistro() async {
    if (_formKey.currentState!.validate()) {
      final registro = {
        'nombre': _nombreController.text,
        'sexo': _sexo,
        'fecha': _fecha.toIso8601String(),
        'telefono': _telefonoController.text,
        'direccion': _direccionController.text,
        'esCristiano': _esCristiano ? 1 : 0,
        'asisteOtraIglesia': _asisteOtraIglesia ? 1 : 0,
        'notas': _notasController.text,
      };
      await DatabaseHelper().insertRegistro(registro);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro guardado')),
      );
      _formKey.currentState!.reset();
      _nombreController.clear();
      _telefonoController.clear();
      _direccionController.clear();
      _notasController.clear();
      setState(() {
        _sexo = 'Hombre';
        _fecha = DateTime.now();
        _esCristiano = false;
        _asisteOtraIglesia = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro Sola Gracia')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                ),
                DropdownButtonFormField(
                  value: _sexo,
                  items: ['Hombre', 'Mujer']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() => _sexo = value!),
                  decoration: const InputDecoration(labelText: 'Sexo'),
                ),
                TextFormField(
                  controller: _telefonoController,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: _direccionController,
                  decoration: const InputDecoration(labelText: 'Dirección'),
                ),
                SwitchListTile(
                  title: const Text('¿Es cristiano?'),
                  value: _esCristiano,
                  onChanged: (value) => setState(() => _esCristiano = value),
                ),
                SwitchListTile(
                  title: const Text('¿Asiste a otra iglesia?'),
                  value: _asisteOtraIglesia,
                  onChanged: (value) => setState(() => _asisteOtraIglesia = value),
                ),
                TextFormField(
                  controller: _notasController,
                  decoration: const InputDecoration(labelText: 'Notas'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _guardarRegistro,
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
