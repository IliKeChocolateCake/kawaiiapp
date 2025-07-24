import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kawaii_app/home/home.dart';

import 'package:kawaii_app/read/read.dart';
import 'package:kawaii_app/play/music_playlist.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {}); // Just rebuild the current tab
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const Center(child: AnimalHomePage()),
      Center(child: Read()),
      const Center(child: SimplePlaylist()),
    ];

    final currentPage = _pages[_selectedIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5), // 💮 Soft pink bg
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: currentPage,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFA6C9), // Baby pink background
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.shade100,
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent, // So container bg shows
          selectedItemColor: Colors.pinkAccent,
          unselectedItemColor: Colors.white,
          elevation: 0, // No internal shadow
          selectedLabelStyle: GoogleFonts.dynaPuff(fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.dynaPuff(),
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Read',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle),
              label: 'Play',
            ),
          ],
        ),
      ),
    );
  }
}
