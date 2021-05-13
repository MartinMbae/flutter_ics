import 'package:flutter/material.dart';

class ProfileRow extends StatelessWidget {
  final title, content;
  const ProfileRow({Key key, @required this.title, @required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("$title : ", style: Theme.of(context).textTheme.subtitle2,overflow: TextOverflow.ellipsis,),
       SizedBox(width: 12,),
        Expanded(
          flex: 1,
            child: Text("$content"),
        ),
      ],
    );
  }
}
