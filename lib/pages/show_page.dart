import 'package:flutter/material.dart';

import 'memo.dart';

class ShowPage extends StatelessWidget {
  final Memo memo;
  const ShowPage(this.memo,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(memo.title)
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('メモ詳細',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            Text(memo.content,style: const TextStyle(fontSize: 18),),
      ],
    ),
    )
  );
  }
}
