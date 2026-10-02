import 'package:flutter/material.dart';

class Classroom {
  final String number;
  final String tower;
  final int floor;
  final String type;
  final bool hasEquipment;

  Classroom(
      {required this.number,
      required this.tower,
      required this.floor,
      required this.type,
      required this.hasEquipment});
}

class ClassroomManagementScreen extends StatefulWidget {
  @override
  _ClassroomManagementScreenState createState() =>
      _ClassroomManagementScreenState();
}

class _ClassroomManagementScreenState extends State<ClassroomManagementScreen> {
  final List<Classroom> _classrooms = [
    Classroom(
        number: 'C-101',
        tower: 'C',
        floor: 1,
        type: 'Teórica',
        hasEquipment: true),
    Classroom(
        number: 'B-201',
        tower: 'B',
        floor: 2,
        type: 'Laboratorio',
        hasEquipment: false),
  ];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _towerController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  bool _hasEquipment = false;

  void _addClassroom() {
    setState(() {
      _classrooms.add(Classroom(
        number: _numberController.text,
        tower: _towerController.text,
        floor: int.parse(_floorController.text),
        type: _typeController.text,
        hasEquipment: _hasEquipment,
      ));
      _numberController.clear();
      _towerController.clear();
      _floorController.clear();
      _typeController.clear();
      _hasEquipment = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final filteredClassrooms = _classrooms.where((classroom) {
      final searchTerm = _searchController.text.toLowerCase();
      return classroom.number.toLowerCase().contains(searchTerm) ||
          classroom.tower.toLowerCase().contains(searchTerm) ||
          classroom.type.toLowerCase().contains(searchTerm);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Aulas', style: TextStyle(color: Colors.yellow)),
        backgroundColor: Color(0xFF0033A0),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar aula... (número, tipo, torre, equipamiento)',
                prefixIcon: Icon(Icons.search, color: Color(0xFF0033A0)),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: filteredClassrooms.length,
              itemBuilder: (context, index) {
                final classroom = filteredClassrooms[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.meeting_room, color: Color(0xFF0033A0)),
                    title: Text(classroom.number,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Torre: ${classroom.tower} | Piso: ${classroom.floor}'),
                        Text('Tipo: ${classroom.type}'),
                        Text(
                          'Estado: ${classroom.hasEquipment ? 'Con equipamiento' : 'Sin equipamiento'}',
                          style: TextStyle(
                            color: classroom.hasEquipment
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {}),
                        IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {}),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Agregar Aula',
                        style: TextStyle(color: Color(0xFF0033A0))),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _numberController,
                            decoration: InputDecoration(
                                labelText: 'Número de Aula',
                                icon: Icon(Icons.meeting_room)),
                          ),
                          TextField(
                            controller: _towerController,
                            decoration: InputDecoration(
                                labelText: 'Torre', icon: Icon(Icons.home)),
                          ),
                          TextField(
                            controller: _floorController,
                            decoration: InputDecoration(
                                labelText: 'Piso',
                                icon: Icon(Icons.format_list_numbered)),
                            keyboardType: TextInputType.number,
                          ),
                          TextField(
                            controller: _typeController,
                            decoration: InputDecoration(
                                labelText: 'Tipo de Aula',
                                icon: Icon(Icons.category)),
                          ),
                          Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.yellow),
                              Checkbox(
                                value: _hasEquipment,
                                onChanged: (value) =>
                                    setState(() => _hasEquipment = value!),
                              ),
                              Text('¿Tiene equipamiento?'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancelar',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      ElevatedButton(
                        onPressed: _addClassroom,
                        child: Text('Agregar'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('+ Agregar Aula'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Color(0xFF0033A0),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
