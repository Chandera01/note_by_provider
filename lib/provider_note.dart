import 'package:flutter/cupertino.dart';
import 'package:untitled/dbhelper.dart';
import 'package:untitled/note_model.dart';

class DbProvider extends ChangeNotifier{
  DbHelper dbHelper = DbHelper.instance;

  List<NoteModel> _notes = [];


  //// add Note
  void addNote(NoteModel newnote)async{
    bool check = await dbHelper.addNote(newnote);

    if(check){
    _notes = await dbHelper.fetchallNote();
      notifyListeners();
    }
  }

  //// fetch note
  Future<void> fetchAllNotes()async{
    _notes = await dbHelper.fetchallNote();
    notifyListeners();
  }

  ///update note
  void updateNote(NoteModel updatenote)async{
    bool check = await dbHelper.updateNote(updatenote);

    if(check){
      _notes = await dbHelper.fetchallNote();
      notifyListeners();
    }
  }

  ///Delete note
  void deleteNote(int id)async{
    bool check = await dbHelper.deleteNote(id);

    if(check){
      _notes = await dbHelper.fetchallNote();
      notifyListeners();
    }
  }

  /// Getter for Notes
  List<NoteModel> getAllNotes() => _notes;

}