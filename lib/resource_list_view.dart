import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
  String progress = "";
  Dio dio;

  @override
  void initState() {
    super.initState();
    dio = Dio();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            height: 60,
            width: 60,
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: GestureDetector(
                  child: Hero(
                    tag:"imageHero${widget.resource.file_id}",
                    child: CachedNetworkImage(
                      imageUrl: widget.resource.getIconImageLink(),
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Center(child: Icon(Icons.error)),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return SingleImageScreen(
                          tag: "imageHero${widget.resource.file_id}",
                          imageUrl: widget.resource.getIconImageLink());
                    }));
                  }),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            ),
          ),
          title: Text(
            widget.resource.title,
          ),
          subtitle: Text(widget.resource.url_download),
          isThreeLine: true,
          trailing: GestureDetector(
              onTapDown: (TapDownDetails details) {
                _showPopupMenu(details.globalPosition);
              },
              child: Icon(Icons.more_vert_rounded)),
        )
      ],
    );
  }

  _showPopupMenu(Offset offset) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem<String>(
          child: ListTile(
            title: Text('Download'),
            leading: Icon(Icons.download_rounded),
            onTap: () async {
              final status = await _permission.request();
              if (status.isGranted) {
                String folderName = "ICS Downloads";
                var path = "storage/emulated/0/$folderName";
                try {
                  await new Directory(path).create();
                } catch (e) {}
                Navigator.of(context).pop();
                try {
                  await downloadFile(widget.resource.getUrlLink(),
                      "$path/${widget.resource.url_download}");
                } catch (e) {
                }
              } else {
                Fluttertoast.showToast(
                    msg: "You must first grant storage permission",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            },
          ),
        ),
        PopupMenuItem<String>(
          child: ListTile(
            title: Text('View File'),
            leading: Icon(Icons.remove_red_eye_rounded),
            onTap: () {
              Navigator.of(context).pop();
              navigateToPage(
                  context,
                  PdfFileView(
                    pdfUrl: widget.resource.getUrlLink(),
                  ));
            },
          ),
        ),
      ],
      elevation: 8.0,
    );
  }

  Future downloadFile(String url, path) async {
    try {
      ProgressDialog progressDialog =
          ProgressDialog(context, type: ProgressDialogType.Normal);
      progressDialog.style(message: "Downloading File");
      progressDialog.show();
      try {
        await dio.download(url, path, onReceiveProgress: (rec, total) {
          setState(() {
            isLoading = true;
            progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
            progressDialog.update(message: "Downloading $progress");
          });

          if ((rec / total) == 1) {
            Fluttertoast.showToast(
                msg: "Has has been saved to 'ICS Downloads'",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        });
      } catch (ee) {
        Fluttertoast.showToast(
            msg: ee.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      progressDialog.hide();
    } catch (e) {}
  }
}



class SingleImageScreen extends StatelessWidget {
  final imageUrl, tag;

  const SingleImageScreen({Key key, @required this.imageUrl, this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: Hero(
            tag: tag,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  Center(child: Icon(Icons.error)),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

