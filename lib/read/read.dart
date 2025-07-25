import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kawaii_app/read/epub_reader_page.dart';
import 'package:google_fonts/google_fonts.dart';

class Read extends StatelessWidget {
  Read({super.key});

  final List<Map<String, dynamic>> epubBooks = [
    {
      'cover': 'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&auto=format&fit=crop&w=2850&q=80',
      'filePath': 'assets/book1.epub',
    },
    {
      'cover': 'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&auto=format&fit=crop&w=2850&q=80',
      'filePath': 'assets/book2.epub',
    },
  ];

  final List<Map<String, dynamic>> epubBooks2 = []; // Romance
  final List<Map<String, dynamic>> epubBooks3 = []; // Comedy

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Read', style: GoogleFonts.dynaPuff(fontSize: 20, color: Colors.white)),
        backgroundColor: const Color(0xFFFFA6C9),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleListItem(imageUrl: 'https://ik.imagekit.io/mnwxsrjlz/kawaii/bunny.png?updatedAt=1753254555727', label: 'Bunny'),
                  SizedBox(width: 12,),
                  CircleListItem(imageUrl: 'https://ik.imagekit.io/mnwxsrjlz/kawaii/bunny.png?updatedAt=1753254555727', label: 'Bunny'),
                  SizedBox(width: 12,),
                  CircleListItem(imageUrl: 'https://ik.imagekit.io/mnwxsrjlz/kawaii/bunny.png?updatedAt=1753254555727', label: 'Bunny'),
                  SizedBox(width: 12,),
                  CircleListItem(imageUrl: 'https://ik.imagekit.io/mnwxsrjlz/kawaii/bunny.png?updatedAt=1753254555727', label: 'Bunny'),
                  SizedBox(width: 12,),
                  CircleListItem(imageUrl: 'https://ik.imagekit.io/mnwxsrjlz/kawaii/bunny.png?updatedAt=1753254555727', label: 'Bunny'),
                  SizedBox(width: 12,),
                  CircleListItem(imageUrl: 'https://ik.imagekit.io/mnwxsrjlz/kawaii/bunny.png?updatedAt=1753254555727', label: 'Bunny'),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Text('Literature', style: GoogleFonts.dynaPuff(fontSize: 18)),
            const SizedBox(height: 10),
            SizedBox(
              height: 400,
              child: CarouselSlider(
                options: CarouselOptions(
                  scrollDirection: Axis.vertical,
                  enlargeCenterPage: true,
                  height: 400,
                ),
                items: epubBooks.map((book) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EpubReaderScreen(epubPath: book['filePath']),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
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
            ),

            // You can repeat this section for epubBooks2 and epubBooks3
            if (epubBooks2.isNotEmpty) ...[
              const SizedBox(height: 30),
              Text('Romance', style: GoogleFonts.dynaPuff(fontSize: 18)),
              // Add CarouselSlider here for epubBooks2
            ],
          ],
        ),
      ),
    );
  }
}

class CircleListItem extends StatelessWidget {
  final String imageUrl;
  final String label;

  const CircleListItem({
    super.key,
    required this.imageUrl,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: const BoxDecoration(
            color: Colors.black12,
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}






