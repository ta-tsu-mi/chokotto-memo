import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_first_app/pages/memo.dart';
import 'package:flutter_first_app/pages/show_page.dart';

import 'create_edit_page.dart';
// import 'package:flutter_first_app/pages/show_page.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key, required this.title});
  final String title;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  final memoCollection = FirebaseFirestore.instance.collection('memo');

  Future<void> deleteMemo(String id) async{
    final doc = FirebaseFirestore.instance.collection('memo').doc(id);
    await doc.delete();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ちょこっとメモアプリ'),
      ),
      body:StreamBuilder<QuerySnapshot>(
        stream: memoCollection.orderBy('createdAt',descending: true).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const CircularProgressIndicator();
          }

          if(!snapshot.hasData){
            return const Center(child: Text('データがありません'));
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context,index){
                Map<String,dynamic> data = docs[index].data() as Map<String,dynamic>;
                final Memo fetchMemo = Memo(
                  id: docs[index].id,
                  title: data['title'],
                  content: data['content'],
                  createdAt: data['createdAt'],
                  updatedAt: data['updatedAt']
                );
                return ListTile(
                  title:Text(fetchMemo.title),
                  trailing: IconButton(
                    onPressed: (){
                      showModalBottomSheet(context: context, builder: (context){
                        return SafeArea(
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  onTap: (){
                                    Navigator.pop(context);
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => CreateEditPage(currentMemo: fetchMemo,)));

                                  },
                                  leading: const Icon(Icons.edit),
                                  title:const Text('編集'),
                                ),
                                ListTile(
                                  onTap: () async{
                                    await deleteMemo(fetchMemo.id);
                                    Navigator.pop(context);

                                  },
                                    leading: const Icon(Icons.delete),
                                    title:const Text('削除'),
                                ),
                              ],
                            ),
                        );
                      });
                    },
                    icon:const Icon(Icons.edit_square),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ShowPage(fetchMemo)));
                  },
                  // content:Text(memoList[index].content),
                );
              });
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateEditPage()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}