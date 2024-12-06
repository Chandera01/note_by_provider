import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/note_model.dart';
import 'package:untitled/provider_note.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DbProvider(),
      child: MaterialApp(
        title: 'Note App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NotesScreen(),
      ),
    );
  }
}

class NotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DbProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddNoteDialog(context),
          ),
        ],
      ),
      body: FutureBuilder(
        future: dbProvider.fetchAllNotes(),  // Fetch all notes on UI load
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return ListView.builder(
            itemCount: dbProvider.getAllNotes().length,
            itemBuilder: (context, index) {
              final note = dbProvider.getAllNotes()[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.desc),
                tileColor: Color(int.parse(note.color)), // Assuming 'color' is a hex code string
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => dbProvider.deleteNote(note.id!),
                ),
                onTap: () => _showEditNoteDialog(context, note),
              );
            },
          );
        },
      ),
    );
  }

  // Show a dialog to add a new note
  void _showAddNoteDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController colorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: colorController,
                decoration: InputDecoration(labelText: 'Color (Hex code)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newNote = NoteModel(
                  title: titleController.text,
                  desc: descController.text,
                  color: colorController.text,
                );
                Provider.of<DbProvider>(context, listen: false).addNote(newNote);
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Show a dialog to edit an existing note
  void _showEditNoteDialog(BuildContext context, NoteModel note) {
    final TextEditingController titleController = TextEditingController(text: note.title);
    final TextEditingController descController = TextEditingController(text: note.desc);
    final TextEditingController colorController = TextEditingController(text: note.color);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: colorController,
                decoration: InputDecoration(labelText: 'Color (Hex code)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final updatedNote = NoteModel(
                  id: note.id,
                  title: titleController.text,
                  desc: descController.text,
                  color: colorController.text,
                );
                Provider.of<DbProvider>(context, listen: false).updateNote(updatedNote);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
