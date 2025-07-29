import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kawaii_app/home/shorts.dart';


class AnimalHomePage extends StatefulWidget {
  const AnimalHomePage({super.key});

  @override
  State<AnimalHomePage> createState() => _AnimalHomePageState();
}

class _AnimalHomePageState extends State<AnimalHomePage> {
  int _current = 0;

  final SearchController searchController = SearchController();

  final List<Map<String, dynamic>> homePage = [
    {
      'cover': 'https://ik.imagekit.io/mnwxsrjlz/kawaii/kuma.png?updatedAt=1753254555741',
      'url': ''
    },
    {
      'cover': 'https://ik.imagekit.io/mnwxsrjlz/kawaii/weasel.png?updatedAt=1753254555710',
      'url': ''
    },
    {
      'cover': 'https://ik.imagekit.io/mnwxsrjlz/kawaii/bunny.png?updatedAt=1753254555727',
      'url': ''
    },
    {
      'cover': 'https://ik.imagekit.io/mnwxsrjlz/kawaii/mouse.png?updatedAt=1753255624937',
      'url': ''
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: GoogleFonts.dynaPuff(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFFA6C9),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchAnchor.bar(
                searchController: searchController,
                barHintText: 'Search here.',

                suggestionsBuilder: (context, controller) {
                  final query = controller.text.toLowerCase();
                  final items = ['Bear', 'Penguin', 'Rabbit'];
                  final filtered = items
                      .where((item) => item.toLowerCase().contains(query))
                      .toList();

                  return filtered.map((suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                      onTap: () {
                        controller.text = suggestion;
                        searchController.closeView(suggestion);
                      },
                    );
                  }).toList();
                },
              ),
              const SizedBox(height: 40),

              /// Carousel Slider
              CarouselSlider(
                items: homePage.map((item) {
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: false,
                  viewportFraction: 1.0,
                  aspectRatio: 1.2,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
              ),

              const SizedBox(height: 12),

              /// Dots Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: homePage.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => setState(() => _current = entry.key),
                    child: Container(
                      width: 20.0,
                      height: 7.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == entry.key
                            ? const Color(0xFFC48590)
                            : Theme.of(context).scaffoldBackgroundColor,
                        border: Border.all(
                          color: const Color(0xFFC48590),
                          width: 1,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),

              /// Animal Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
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

              const SizedBox(height: 30),

              Text('Explore', style: GoogleFonts.dynaPuff(fontSize: 24)),
              const SizedBox(height: 5),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: ExploreItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 4,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(item.title),
                              subtitle: Text(item.subtitle),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),




              const SizedBox(height: 20),

              Text('Discover', style: GoogleFonts.dynaPuff(fontSize: 24)),
              const SizedBox(height: 15),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: 250,
                          child: YouTubeShortWidget(shortUrl: 'https://www.youtube.com/shorts/VUogf5sXZJo'),
                        ),
                        const SizedBox(width: 10,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: 250,
                          child: YouTubeShortWidget(shortUrl: 'https://www.youtube.com/shorts/dzUQh5zkzBo'),
                        ),
                      ],
                    ),




                  ],
                ),
              ),

            ],
          ),
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


class Explore {

  late String title;
  late String subtitle;
  late String imageUrl;

 Explore({
    required this.title,
    required this.subtitle,
   required this.imageUrl,

});

  factory Explore.fromJson(Map<String, dynamic> json){

    return Explore(
    title: 'title',
    subtitle: 'subtitle',
  imageUrl: 'imageUrl'



    );






  }

}

final List<Explore> ExploreItems =[

  Explore(
    title: 'Cute Bear',
    subtitle: 'Loves honey and naps',
    imageUrl: 'https://ik.imagekit.io/mnwxsrjlz/kawaii/kuma.png',
  ),
  Explore(
    title: 'Happy Bunny',
    subtitle: 'Hops around the forest',
    imageUrl: 'https://ik.imagekit.io/mnwxsrjlz/kawaii/bunny.png',
  ),

  Explore(
    title: 'Happy Bunny',
    subtitle: 'Hops around the forest',
    imageUrl: 'https://ik.imagekit.io/mnwxsrjlz/kawaii/bunny.png',
  ),


];