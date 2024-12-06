import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/note_model.dart';

class DbHelper {
  // Step 1 make a private Constructor
  DbHelper._();

  //Step 2 creating a  static  global instance to this class
  static final instance = DbHelper._();

  // static DbHelper getInstance() => DbHelper._(); //you can also use this function

  Database? mDb;
  static final String Table_Note = 'note';
  static final String Table_id = 'id';
  static final String Table_Column_title = 'title';
  static final String Tabel_Column_desc = 'desc';
  static final String Table_Column_Colur = 'color';

  Future<Database> initDb() async {
    mDb = mDb ?? await openDb();
    return mDb!;
  }

  Future<Database> openDb() async {
    var dairpath = await getApplicationCacheDirectory();
    var dbpath = join(dairpath.path, 'note.db');
    return openDatabase(dbpath, version: 1, onCreate: (db, version) {
      db.execute(
          "create table $Table_Note ( $Table_id integer primary key autoincrement, $Table_Column_title text, $Tabel_Column_desc text, $Table_Column_Colur text)");
    });
  }

  ////add a note
  Future<bool> addNote(NoteModel newnote) async {
    Database db = await initDb();
    int rowseffected = await db.insert(Table_Note, newnote.toMap());
    return rowseffected > 0;
  }

  ///fetch note
  Future<List<NoteModel>> fetchallNote() async {
    Database db = await initDb();
    List<NoteModel> mData = [];

    List<Map<String, dynamic>> alltask = await db.query(Table_Note);

    for (Map<String, dynamic> eachdata in alltask) {
      NoteModel eachNotes = NoteModel.fromMap(eachdata);
      mData.add(eachNotes);
    }
    return mData;
  }

  ////update note
  Future<bool> updateNote(NoteModel newnote) async {
    Database db = await initDb();
    int rowseffected = await db.update(Table_Note, newnote.toMap(),
        where: "$Table_id = ?",
        whereArgs: [newnote.id]);
    return rowseffected > 0;
  }
  
  Future<bool> deleteNote(int id)async{
    Database db = await initDb();
    int rowseffected = await db.delete(Table_Note, where: "$Table_id = ?",whereArgs: [id]);
    return rowseffected>0;
  }
}
