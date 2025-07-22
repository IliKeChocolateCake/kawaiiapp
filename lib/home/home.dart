import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimalHomePage extends StatelessWidget {
  const AnimalHomePage({super.key});



  @override
  Widget build(BuildContext context) {

    final SearchController searchController = SearchController();

    final List<Map<String, dynamic>> homePage =[

      {
        'cover' : '',
        'url' : ''
      },

      {
        'cover' : '',
        'url' : ''
      },

      {
        'cover' : '',
        'url' : ''
      },

      {
        'cover' : '',
        'url' : ''
      },



    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Home',
            style: GoogleFonts.dynaPuff(fontSize: 20, color: Colors.white)),
        backgroundColor: const Color(0xFFFFA6C9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,

          children:  [

        SearchAnchor.bar(
        searchController: searchController,

          barHintText: 'Search here.',
          suggestionsBuilder: (context, controller) {
            final query = controller.text.toLowerCase();
            final items = ['Bear', 'Penguin', 'Rabbit'];

            final filtered = items.where((item) => item.toLowerCase().contains(query)).toList();

            return filtered.map((suggestion) {
              return ListTile(
                title: Text(suggestion),
                onTap: () {
                  controller.text = suggestion;
                  searchController.closeView(suggestion); // close dropdown
                },
              );
            }).toList();
          },

        ),

            const SizedBox(height: 20,),

        CarouselSlider(

          options: CarouselOptions(
          height: MediaQuery.of(context).size.height,
          scrollDirection: Axis.horizontal,
          enlargeCenterPage: true,
          autoPlay: false,
          ), items: homePage.map( (item){

          final String imageUrl = item['cover'];
          final String linkUrl = item['url'];

          return GestureDetector(
            onTap: () async {
              final Uri url = Uri.parse(linkUrl);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not launch URL')),
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  )
                ],
              ),
            ),
          );

        }

        ).toList()
                ),


            const SizedBox(height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                AnimalButton(
                  imagePath: 'assets/bear.png',
                  label: 'Bear',
                ),
                AnimalButton(
                  imagePath: 'assets/penguin.png',
                  label: 'Penguin',
                ),
                AnimalButton(
                  imagePath: 'assets/rabbit.png',
                  label: 'Rabbit',
                ),

              ],

            ),

            //gesture detector for url links articles

            const SizedBox(height: 20,),

            Text('Explore', style: GoogleFonts.dynaPuff(fontSize: 24),),

            ListView(


            ),


            const SizedBox(height: 5,),

            //carousel slider horizontally

            const SizedBox(height: 20,),

            Text('Discover', style: GoogleFonts.dynaPuff(fontSize: 24),),

            const SizedBox(height: 5,),

            ListView(


            ),

            //videos embedded with youtube.

          ],
        ),
      ),
    );
  }
}

class AnimalButton extends StatelessWidget {
  final String imagePath;
  final String label;

  const AnimalButton({
    super.key,
    required this.imagePath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label tapped!')),
        );
      },
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 24),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}


