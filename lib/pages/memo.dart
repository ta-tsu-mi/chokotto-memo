import 'package:cloud_firestore/cloud_firestore.dart';

class Memo{
  String id;
  String title;
  String content;
  Timestamp createdAt;
  Timestamp? updatedAt;

    Memo({
      required this.id,
      required this.title,
      required this.content,
      required this.createdAt,
      this.updatedAt
  });
}