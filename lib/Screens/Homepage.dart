import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_application/Screens/AddNotesPage.dart';
import 'package:notes_application/models/noteModel.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // final _searchController = TextEditingController();
  String _searchQuery = '';
  List<Notes> _notes = [];
  late Box<Notes> _notesBox; // to operate  a box data 


// ------initialization Hive Box to store the list present -------
  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    _notesBox = await Hive.openBox<Notes>('notesBox'); // opening hive box 
    _loadNotes(); 
  }

  void _loadNotes(){  //loding Notes preent inside hive box
    setState(() {
      _notes = _notesBox.values.toList();
    });
  }

// navigation to addNotes page and coming back with data of notes
  void _navigateToAddNotesPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNotesPage(),
      ),
    );

    if (result != null && result is Notes) {
      setState(() {
       _notes.add(result);
       setState(() {});
      });
    }
  }


// -----search mechanism------
  void _searchNotes(String query){
    setState(() {
      _searchQuery = query ;
    });
  }

  List<Notes> get _filteredNotes{
    if(_searchQuery.isEmpty){
      return _notes;
    } else {
      return _notes.where((note)=>note.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.note),
            SizedBox(width: 10),
            Text(
              "Notes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        elevation: 0.5,
        actions: const [
          Icon(Icons.notifications_sharp, color: Colors.black),
          SizedBox(width: 10),
          Icon(Icons.severe_cold_outlined, color: Colors.black),
          SizedBox(width: 10),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: TextFormField(
                cursorColor: Colors.black,
                // controller: _searchController,
                onChanged: _searchNotes,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 214, 214, 214),
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredNotes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      tileColor: const Color.fromARGB(255, 214, 214, 214),
                      title: Text(_filteredNotes[index].title,style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900
                      ),),
                      subtitle: Text(_filteredNotes[index].description),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.white,
        onPressed: _navigateToAddNotesPage,
        child: const Icon(Icons.add_box, size: 30),
      ),
    );
  }
}
