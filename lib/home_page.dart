import 'package:flutter/material.dart';
import 'note_form.dart';
import 'models/note.dart';
import 'splash_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];
  List<Note> filteredNotes = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredNotes = notes;
    searchController.addListener(_filterNotes);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterNotes);
    searchController.dispose();
    super.dispose();
  }

  void addNote(Note note) {
    setState(() {
      notes.add(note);
      _filterNotes();
    });
  }

  void editNote(int index, Note newNote) {
    setState(() {
      notes[index] = newNote;
      _filterNotes();
    });
  }

  void deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
      _filterNotes();
    });
  }

  void goToSplashScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SplashScreen()),
    );
  }

  void _filterNotes() {
    final query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredNotes = notes;
      } else {
        filteredNotes = notes.where((note) {
          final titleLower = note.title.toLowerCase();
          final contentLower = note.content.toLowerCase();
          return titleLower.contains(query) || contentLower.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = searchController.text.isEmpty
        ? []
        : notes.where((note) {
      final query = searchController.text.toLowerCase();
      return note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: goToSplashScreen,
        ),
        title: const Text('Notes'),
        backgroundColor: const Color(0xFF2196F3), // Biru
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search notes...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (suggestions.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = suggestions[index];
                        return ListTile(
                          title: Text(suggestion.title),
                          onTap: () {
                            searchController.text = suggestion.title;
                            _filterNotes();
                            FocusScope.of(context).unfocus();
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: filteredNotes.isEmpty
                ? const Center(child: Text('No notes found'))
                : ListView.builder(
              itemCount: filteredNotes.length,
              itemBuilder: (_, index) {
                final note = filteredNotes[index];
                return Card(
                  elevation: 3,
                  margin:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(note.content),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NoteForm(
                            note: note,
                            onSave: (newNote) {
                              final originalIndex = notes.indexOf(note);
                              editNote(originalIndex, newNote);
                            },
                            isEditing: true,
                          ),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NoteForm(
                                  note: note,
                                  onSave: (newNote) {
                                    final originalIndex =
                                    notes.indexOf(note);
                                    editNote(originalIndex, newNote);
                                  },
                                  isEditing: true,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            final originalIndex = notes.indexOf(note);
                            deleteNote(originalIndex);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2196F3), // Biru
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NoteForm(
                onSave: addNote,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
