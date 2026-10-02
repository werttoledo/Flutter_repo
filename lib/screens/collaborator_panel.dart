import 'package:flutter/material.dart';

class CollaboratorPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Panel de Colaborador')),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildTile(context, 'Gestión de Docentes', Icons.person, null),
          _buildTile(context, 'Mis Reservas', Icons.book, null),
          _buildTile(context, 'Salones Reservados', Icons.meeting_room, '/salon'),
          _buildTile(context, 'Equipos Reservados', Icons.computer, '/equipment'),
          _buildTile(context, 'Historial de Reservas', Icons.history, '/history'),
          _buildTile(context, 'Alquiler de Equipos', Icons.shopping_cart, '/rental'),
          _buildTile(context, 'Gestión de Aulas', Icons.class_, '/classrooms'),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, String title, IconData icon, String? route) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF0033A0)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.arrow_forward, color: Colors.yellow),
        onTap: route != null ? () => Navigator.pushNamed(context, route) : null,
      ),
    );
  }
}