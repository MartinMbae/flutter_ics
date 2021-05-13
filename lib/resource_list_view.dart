import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_ics/models/category_downloads.dart';
import 'package:flutter_ics/utils/app_colors.dart';

class ResourceListView extends StatelessWidget {
  const ResourceListView(
      {Key key,
        this.resource,
        this.animationController,
        this.animation})
      : super(key: key);

  final CategoryDownload resource;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width* 0.05),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(Icons.picture_as_pdf_outlined, color: primaryColor, size: 30,),
            SizedBox(height: 5,),
            Text(resource.title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, decoration: TextDecoration.underline),),
            SizedBox(height: 10,),
            Text(resource.description.toString().trim().isEmpty ?  'No resource description found' : resource.description , style: TextStyle(fontWeight: FontWeight.w400,), textAlign: TextAlign.start,maxLines: 3, overflow: TextOverflow.ellipsis,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.file_download, color: primaryColor,),
              ],
            )
          ],
        ),
      ),
    );
  }
}
