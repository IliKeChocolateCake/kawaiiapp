import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kawaii_app/read/epub_reader_page.dart';
import 'package:google_fonts/google_fonts.dart';

class Read extends StatelessWidget {

   Read ({super.key});

  final List<Map<String, dynamic>> epubBooks = [
    {
      'cover': 'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
      'filePath': 'assets/book1.epub',
    },
    {
      'cover': 'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
      'filePath': 'assets/book2.epub',
    },
    // Add more books here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Read',
          style: GoogleFonts.dynaPuff(fontSize: 20, color: Colors.white)),
        backgroundColor: const Color(0xFFFFA6C9),),
      body: CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height,
          scrollDirection: Axis.vertical,
          enlargeCenterPage: true,
          autoPlay: false,
        ),
        items: epubBooks.map((book) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => EpubReaderScreen(epubPath: book['filePath']),
              ));
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(book['cover']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
