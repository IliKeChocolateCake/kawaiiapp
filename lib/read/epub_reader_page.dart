import 'dart:io';
import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart';



class EpubReaderScreen extends StatelessWidget {

  final String epubPath;

  const EpubReaderScreen({super.key, required this.epubPath});

  @override
  Widget build(BuildContext context) {
    final controller = EpubController(
      document: EpubReader.readBook(
        File(epubPath).readAsBytesSync(),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Reading EPUB')),
      body: EpubView(
        controller: controller,
      ),
    );
  }
}
