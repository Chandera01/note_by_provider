import 'dbhelper.dart';

class NoteModel{
  int ? id;
  String title;
  String desc;
  String color;

  NoteModel({
    this.id,
    required this.title,
    required this.desc,
    required this.color
 });

   //Convert a note object to a map object (for saving into SQLite)
  Map<String, dynamic> toMap(){
    return {
      DbHelper.Table_id : id,
      DbHelper.Table_Column_title : title,
      DbHelper.Tabel_Column_desc : desc,
      DbHelper.Table_Column_Colur : color,
     };
  }

    //Convert a Map object to a Note object
  factory NoteModel.fromMap(Map<String,dynamic> map){
    return NoteModel(
        id: map[DbHelper.Table_id],
        title: map[DbHelper.Table_Column_title],
        desc: map[DbHelper.Tabel_Column_desc],
        color: map[DbHelper.Table_Column_Colur],
    );
  }

}

