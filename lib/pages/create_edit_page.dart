import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_first_app/pages/memo.dart';

class CreateEditPage extends StatefulWidget {
  final Memo? currentMemo;
  const CreateEditPage({Key? key,this.currentMemo}) : super(key: key);

  @override
  State<CreateEditPage> createState() => _CreateEditPageState();
}

class _CreateEditPageState extends State<CreateEditPage> {
  TextEditingController textController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  Future<void> createMemo() async{
    final memoCollection = FirebaseFirestore.instance.collection('memo');
    await memoCollection.add({
      'title':textController.text,
      'content':contentController.text,
      'createdAt':Timestamp.now()
    });
  }


  Future<void> updateMemo() async{
    final doc = FirebaseFirestore.instance.collection('memo').doc(widget.currentMemo!.id);
    await doc.update({
      'title':textController.text,
      'content':contentController.text,
      'updatedAt':Timestamp.now()
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.currentMemo != null){
      textController.text = widget.currentMemo!.title;
      contentController.text = widget.currentMemo!.content;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currentMemo == null ? 'memo追加': 'メモ編集'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text('タイトル'),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey)
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: textController,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10)
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text('詳細'),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey)
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: contentController,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10)
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              alignment: Alignment.center,
              child:ElevatedButton(
                onPressed: () async{
                  //新規メモ
                  if(widget.currentMemo == null){
                  await createMemo();

                  }else{
                  await updateMemo();

                  }
                  Navigator.pop(context);
                },
                child: Text(widget.currentMemo == null ? '追加': '更新'),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
