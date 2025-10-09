// school_classes_page.dart
import 'package:flutter/material.dart';
import 'package:sms/entity/school_class.dart';
import 'package:sms/service/school_class_service.dart';


class SchoolClassesPage extends StatefulWidget {
  @override
  _SchoolClassesPageState createState() => _SchoolClassesPageState();
}

class _SchoolClassesPageState extends State<SchoolClassesPage> {
  final SchoolClassService _service = SchoolClassService();
  final TextEditingController _nameController = TextEditingController();

  late Future<List<SchoolClass>> _classesFuture;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  void _loadClasses() {
    _classesFuture = _service.getAllClasses();
  }

  void _createClass() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    try {
      await _service.createClass(name);
      _nameController.clear();
      setState(() {
        _loadClasses();
      });
    } catch (e) {
      _showError('Failed to create class');
    }
  }

  void _deleteClass(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Class'),
        content: Text('Are you sure you want to delete this class?'),
        actions: [
          TextButton(child: Text('Cancel'), onPressed: () => Navigator.pop(context, false)),
          TextButton(child: Text('Delete'), onPressed: () => Navigator.pop(context, true)),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _service.deleteClass(id);
        setState(() {
          _loadClasses();
        });
      } catch (e) {
        _showError('Failed to delete class');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('School Classes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add class form
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Class Name',
                          hintText: 'e.g. 5-A, 6-B',
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _createClass,
                      child: Text('Create'),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Class list
            Expanded(
              child: FutureBuilder<List<SchoolClass>>(
                future: _classesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  else if (snapshot.hasError)
                    return Center(child: Text('Error loading classes'));
                  else if (!snapshot.hasData || snapshot.data!.isEmpty)
                    return Center(child: Text('No classes available'));

                  final classes = snapshot.data!;
                  return ListView.separated(
                    itemCount: classes.length,
                    separatorBuilder: (_, __) => Divider(height: 1),
                    itemBuilder: (context, index) {
                      final cls = classes[index];
                      return ListTile(
                        title: Text(cls.name),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteClass(cls.id),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
