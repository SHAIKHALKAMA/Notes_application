// add_notes_page.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


import '../models/noteModel.dart';

class AddNotesPage extends StatefulWidget {
  const AddNotesPage({super.key});

  @override
  State<AddNotesPage> createState() => _AddNotesPageState();
}

class _AddNotesPageState extends State<AddNotesPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _saveNote() async{
    String title = _titleController.text;
    String desc = _descriptionController.text;

    if (title.isNotEmpty && desc.isNotEmpty) {
      final notesBox = await Hive.openBox<Notes>('notesBox');
      final newNote = Notes(title: title, description: desc);
      notesBox.add(newNote);
      
      Navigator.pop(context, newNote);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Colors.grey,
          content: Text("Title & Description cannot be empty"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: const [
          Icon(Icons.notifications_sharp, color: Colors.black),
          SizedBox(width: 5),
          Icon(Icons.delete, color: Colors.black),
          SizedBox(width: 5),
          Icon(Icons.share, color: Colors.black),
          SizedBox(width: 5),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add Notes",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
            ),
            TextFormField(
              cursorColor: Colors.black,
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Title",
              ),
            ),
            TextFormField(
              cursorColor: Colors.black,
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: "Description",
              ),
              maxLines: 5,
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: _saveNote,
              child: Container(
                height: 50,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                child: const Center(
                  child: Text(
                    "Save",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.white,
        child: const Icon(Icons.photo_size_select_actual_rounded, size: 30),
        onPressed: () {},
      ),
    );
  }
}
