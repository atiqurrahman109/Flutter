// sections_page.dart
import 'package:flutter/material.dart';
import 'package:sms/entity/school_class.dart';
import 'package:sms/entity/section.dart';
import 'package:sms/service/school_class_service.dart';
import 'package:sms/service/section_service.dart';


class SectionsPage extends StatefulWidget {
  @override
  _SectionsPageState createState() => _SectionsPageState();
}

class _SectionsPageState extends State<SectionsPage> {
  final SectionService _sectionService = SectionService();
  final SchoolClassService _classService = SchoolClassService();

  late Future<List<Section>> _sectionsFuture;
  late Future<List<SchoolClass>> _classesFuture;

  final _nameController = TextEditingController();
  SchoolClass? _selectedClass;
  int? _editingSectionId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _sectionsFuture = _sectionService.getAllSections();
    _classesFuture = _classService.getAllClasses();
  }

  void _saveSection() async {
    final name = _nameController.text.trim();
    final cls = _selectedClass;
    if (name.isEmpty || cls == null) {
      _showError('Name and Class must be provided');
      return;
    }

    Section section = Section(
      id: _editingSectionId ?? 0,
      name: name,
      schoolClass: cls,
    );

    try {
      if (_editingSectionId != null) {
        await _sectionService.updateSection(_editingSectionId!, section);
      } else {
        await _sectionService.createSection(section);
      }
      _clearForm();
      setState(() {
        _loadData();
      });
    } catch (e) {
      _showError('Failed to save section');
    }
  }

  void _editSection(Section section) {
    setState(() {
      _editingSectionId = section.id;
      _nameController.text = section.name;
      _selectedClass = section.schoolClass;
    });
  }

  void _deleteSection(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Section'),
        content: Text('Are you sure to delete this section?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete')),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await _sectionService.deleteSection(id);
        setState(() {
          _loadData();
        });
      } catch (e) {
        _showError('Failed to delete section');
      }
    }
  }

  void _clearForm() {
    _editingSectionId = null;
    _nameController.clear();
    _selectedClass = null;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sections')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form for add/edit
            FutureBuilder<List<SchoolClass>>(
              future: _classesFuture,
              builder: (context, clsSnapshot) {
                if (clsSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (clsSnapshot.hasError) {
                  return Text('Error loading classes');
                } else {
                  final classes = clsSnapshot.data!;
                  return Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Section Name',
                              hintText: 'e.g. A, B, C',
                            ),
                          ),
                          SizedBox(height: 12),
                          DropdownButton<SchoolClass>(
                            hint: Text('Select Class'),
                            value: _selectedClass,
                            isExpanded: true,
                            items: classes.map((cls) {
                              return DropdownMenuItem<SchoolClass>(
                                value: cls,
                                child: Text(cls.name),
                              );
                            }).toList(),
                            onChanged: (cls) {
                              setState(() {
                                _selectedClass = cls;
                              });
                            },
                          ),
                          SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _saveSection,
                            child: Text(_editingSectionId != null ? 'Update Section' : 'Save Section'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            // List of sections
            Expanded(
              child: FutureBuilder<List<Section>>(
                future: _sectionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error loading sections'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No sections available'));
                  }

                  final sections = snapshot.data!;
                  return ListView.separated(
                    itemCount: sections.length,
                    separatorBuilder: (_, __) => Divider(),
                    itemBuilder: (context, index) {
                      final sec = sections[index];
                      return ListTile(
                        title: Text(sec.name),
                        subtitle: Text('Class: ${sec.schoolClass.name}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.grey),
                              onPressed: () => _editSection(sec),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteSection(sec.id),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
