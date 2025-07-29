import 'package:flutter/material.dart';
import 'package:kawaii_app/read/posts.dart';
import 'package:google_fonts/google_fonts.dart';

class ReaderProfile extends StatefulWidget {
  final int id;
  final String imageUrl;
  final String label;

  const ReaderProfile({super.key, required this.id, required this.imageUrl, required this.label});

  @override
  State<ReaderProfile> createState() => ReaderProfileState();
}

class ReaderProfileState extends State<ReaderProfile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: GoogleFonts.dynaPuff(fontSize: 20, color: Colors.white)),
        backgroundColor: const Color(0xFFFFA6C9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// Background + Profile
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Background or header
                Container(
                  height: 120,
                  width: double.infinity,
                  color: Colors.pink[200],
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Welcome!',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),



                // Profile image overlay
                Positioned(
                  bottom: -30, // half of avatar size to make it overlap
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                    ),
                    child: CircleAvatar(

                      radius: 30,
                      backgroundImage: NetworkImage(
                        widget.imageUrl,
                      ),
                    ),

                  ),
                ),
                


              ],
            ),

            const SizedBox(height: 40),

            Text(widget.label, textAlign: TextAlign.justify,),

            const SizedBox(height: 40),
            /// Favorite Quote
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '"A reader lives a thousand lives before he dies..."',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade700,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Tabs
            TabBar(
              controller: _tabController,
              labelColor: Colors.pink,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.pink,
              tabs: const [
                Tab(text: 'Post',),
                Tab(text: 'Favorites'),
              ],
            ),

            /// Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPostTab(),
                  _buildFavoritesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostTab() {
    return const Center(child: Post());
  }

  Widget _buildFavoritesTab() {
    return const Center(child: Text('Favorite books go here'));
  }
}
