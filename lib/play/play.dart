import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Play extends StatefulWidget {
  const Play({super.key});

  @override
  State<Play> createState() => PlayState();
}

class PlayState extends State<Play> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? currentlyPlaying;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool isPaused = false;

  List<QueryDocumentSnapshot> _songs = [];
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    _audioPlayer.onDurationChanged.listen((d) {
      setState(() => _duration = d);
    });

    _audioPlayer.onPositionChanged.listen((p) {
      setState(() => _position = p);
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        currentlyPlaying = null;
        isPaused = false;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pageController.dispose();
    super.dispose();
  }

  String _convertDriveLink(String viewUrl) {
    final uri = Uri.parse(viewUrl);
    final id = uri.pathSegments.contains('d') ? uri.pathSegments[2] : null;
    return id != null
        ? 'https://drive.google.com/uc?export=download&id=$id'
        : viewUrl;
  }

  void _playSong(String rawUrl, String id) async {
    final url = _convertDriveLink(rawUrl);
    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(url));
    setState(() {
      currentlyPlaying = id;
      isPaused = false;
    });
  }

  void _pauseOrResume() async {
    if (isPaused) {
      await _audioPlayer.resume();
    } else {
      await _audioPlayer.pause();
    }
    setState(() {
      isPaused = !isPaused;
    });
  }

  void _shufflePlay() {
    if (_songs.isEmpty) return;
    final random = Random();
    final randomIndex = random.nextInt(_songs.length);
    final song = _songs[randomIndex];
    _pageController.jumpToPage(randomIndex);
    _playSong(song['audio_url'], song.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        title: Text('Play',
            style: GoogleFonts.dynaPuff(fontSize: 20, color: Colors.white)),
        backgroundColor: const Color(0xFFFFA6C9),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle, color: Colors.white),
            onPressed: _shufflePlay,
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('songs')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          _songs = snapshot.data!.docs;

          return CarouselSlider.builder(
            itemCount: _songs.length,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.85,
              scrollDirection: Axis.vertical,
              enlargeCenterPage: true,
              viewportFraction: 0.85,
              enableInfiniteScroll: false,
            ),
            itemBuilder: (context, index, realIndex) {
              final song = _songs[index];
              final id = song.id;
              final title = song['title'];
              final artist = song['artist'];
              final url = song['audio_url'];
              final imageUrl = song['image_url'];
              final isPlaying = currentlyPlaying == id;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFFE4E1).withOpacity(0.95),
                        const Color(0xFFFFA6C9).withOpacity(0.95),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.shade100,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          imageUrl,
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(title,
                          style: GoogleFonts.dynaPuff(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      Text(artist, style: GoogleFonts.dynaPuff(fontSize: 16)),
                      const SizedBox(height: 20),
                      IconButton(
                        icon: Icon(
                          isPlaying && !isPaused
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: Colors.pinkAccent,
                          size: 60,
                        ),
                        onPressed: () {
                          if (isPlaying) {
                            _pauseOrResume();
                          } else {
                            _playSong(url, id);
                          }
                        },
                      ),
                      if (isPlaying)
                        Column(
                          children: [
                            Slider(
                              min: 0,
                              max: _duration.inSeconds.toDouble(),
                              value: _position.inSeconds
                                  .toDouble()
                                  .clamp(0, _duration.inSeconds.toDouble()),
                              activeColor: Colors.pink,
                              onChanged: (value) async {
                                final position = Duration(seconds: value.toInt());
                                await _audioPlayer.seek(position);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_formatDuration(_position),
                                      style: const TextStyle(fontSize: 12)),
                                  Text(_formatDuration(_duration),
                                      style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          );

        },
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
