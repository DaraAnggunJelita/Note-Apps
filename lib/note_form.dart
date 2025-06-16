import 'package:flutter/material.dart';
import 'models/note.dart';

class NoteForm extends StatefulWidget {
  final Note? note;
  final Function(Note) onSave;
  final bool isEditing;

  const NoteForm({
    super.key,
    this.note,
    required this.onSave,
    this.isEditing = false,
  });

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
  }

  void saveNote() {
    final newNote = Note(
      title: titleController.text,
      content: contentController.text,
      date: DateTime.now(),
    );
    widget.onSave(newNote);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        title: Text(widget.isEditing ? 'Edit Note' : 'New Note'),
        actions: widget.isEditing
            ? [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Navigator.pop(context); // Kamu bisa tambahkan confirm delete di sini
            },
          )
        ]
            : [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: saveNote,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
