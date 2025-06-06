import 'package:flutter/material.dart';

class ListBuild extends StatelessWidget {
  
  const ListBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 15,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.photo),
          title: Text('Photo $index',
              style: TextStyle(
                fontSize: 15,
              )),
          subtitle: Text('Description of photo $index'),
          onTap: () {
            Navigator.pushNamed(context, '/photoDetail',
                arguments: {'photoId': index, 'photoName': 'Photo $index'});
          },
        );
      },
    );
  }
}
