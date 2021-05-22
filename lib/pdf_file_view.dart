import 'package:flutter/material.dart';
import 'package:pdf_viewer_jk/pdf_viewer_jk.dart';

class PdfFileView extends StatefulWidget {
  final pdfUrl;
  const PdfFileView({Key key, @required this.pdfUrl}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PdfFileViewState();
}

class _PdfFileViewState extends State<PdfFileView> {
  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    setState(() {
      _isLoading = true;
    });
    document = await PDFDocument.fromURL(widget.pdfUrl);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("Resource Preview"),
            ),
            body: Center(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : PDFViewer(
                  document: document,
                  zoomSteps: 1,
                  //preload all pages
                  // lazyLoad: false,
                  // scroll vertically
                  scrollDirection: Axis.vertical,

                  //uncomment below code to replace bottom navigation with your own
                  /* navigationBuilder:
                      (context, page, totalPages, jumpToPage, animateToPage) {
                    return ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.first_page),
                          onPressed: () {
                            jumpToPage()(page: 0);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            animateToPage(page: page - 2);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            animateToPage(page: page);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.last_page),
                          onPressed: () {
                            jumpToPage(page: totalPages - 1);
                          },
                        ),
                      ],
                    );
                  }, */
                ))));
  }
}