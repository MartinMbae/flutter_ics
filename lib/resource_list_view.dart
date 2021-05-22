import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:flutter_ics/models/category_downloads.dart';
import 'package:flutter_ics/pdf_file_view.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:flutter_ics/utils/custom_methods.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ResourceListView extends StatefulWidget {
  const ResourceListView(
      {Key key,
      this.resource,
      this.animationController,
      this.animation,
      this.permission})
      : super(key: key);

  final CategoryDownload resource;
  final AnimationController animationController;
  final Animation<dynamic> animation;


  final Permission permission;

  @override
  _ResourceListViewState createState() => _ResourceListViewState();
}

class _ResourceListViewState extends State<ResourceListView> {
  final Permission _permission = Permission.storage;
  bool isLoading;
  String progress="";
  Dio dio;

  @override
  void initState() {
    super.initState();
    dio=Dio();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05),
      decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(
              Icons.picture_as_pdf_outlined,
              color: primaryColor,
              size: 30,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.resource.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  decoration: TextDecoration.underline),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.resource.description.toString().trim().isEmpty
                  ? 'No resource description found'
                  : widget.resource.description,
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.start,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            GestureDetector(
              onTap: () {
                showMaterialModalBottomSheet(
                  expand: false,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Material(
                      child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Text('Download'),
                          leading: Icon(Icons.download_rounded),
                          onTap: () async {
                            final status = await _permission.request();
                            if (status.isGranted) {
                              String folderName = "ICS Downloads";
                              var path = "storage/emulated/0/$folderName";
                              try{
                                await  new Directory(path).create();
                              }catch(e){}
                              print(widget.resource.getUrlLink());
                              Navigator.of(context).pop();
                              try{
                            await   downloadFile(widget.resource.getUrlLink(), "$path/${widget.resource.url_download}");
                              }catch(e){
                                print(e.toString());
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      "You must first grant storage permission",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                        ),
                        ListTile(
                          title: Text('View File'),
                          leading: Icon(Icons.remove_red_eye_rounded),
                          onTap: () {
                            Navigator.of(context).pop();
                            navigateToPage(context, PdfFileView(pdfUrl: widget.resource.getUrlLink(),));
                            // navigateToPage(context, PDFScreen(widget.resource.getUrlLink()));
                          },
                        ),
                      ],
                    ),
                  )),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.file_download,
                    color: primaryColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  Future downloadFile(String url,path) async {
    try{
      ProgressDialog progressDialog=ProgressDialog(context,type: ProgressDialogType.Normal);
      progressDialog.style(message: "Downloading File");
      progressDialog.show();
      try {
        await dio.download(url, path, onReceiveProgress: (rec, total) {
          setState(() {
            isLoading = true;
            progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
            progressDialog.update(message: "Downloading $progress");
          });

          if((rec / total) == 1){
            Fluttertoast.showToast(
                msg:
               "Has has been saved to 'ICS Downloads'",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        });
      }catch(ee){
        Fluttertoast.showToast(
            msg:
           ee.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      progressDialog.hide();

    }catch( e) {}
  }

}


class PDFScreen extends StatelessWidget {
  String pathPDF = "";
  PDFScreen(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text("Document"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        path: pathPDF);
  }
}
