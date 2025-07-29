
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class SimplePlaylist extends StatefulWidget {
  const SimplePlaylist({super.key});

  @override
  State<SimplePlaylist> createState() => _SimplePlaylistState();
}

class _SimplePlaylistState extends State<SimplePlaylist> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? currentlyPlaying;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool isPaused = false;

  List<QueryDocumentSnapshot> _songs = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        title: Text('My Playlist',
            style: GoogleFonts.dynaPuff(fontSize: 20, color: Colors.white)),
        backgroundColor: const Color(0xFFFFA6C9),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('songs')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          _songs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            scrollDirection: Axis.vertical,
            itemCount: _songs.length,
            itemBuilder: (context, index) {
              final song = _songs[index];
              final id = song.id;
              final title = song['title'];
              final artist = song['artist'];
              final url = song['audio_url'];
              final imageUrl = song['image_url'];
              final isPlaying = currentlyPlaying == id;

              return SingleChildScrollView(

                child:Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(title, style: GoogleFonts.dynaPuff(fontSize: 16)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(artist, style: GoogleFonts.dynaPuff(fontSize: 12)),
                        if (isPlaying)
                          Slider(
                            label: _formatDuration(_duration),
                            min: 0,
                            max: _duration.inSeconds.toDouble(),
                            value: _position.inSeconds
                                .toDouble()
                                .clamp(0, _duration.inSeconds.toDouble()),
                            activeColor: Colors.pinkAccent,
                            onChanged: (value) async {
                              final position = Duration(seconds: value.toInt());
                              await _audioPlayer.seek(position);
                            },
                          ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isPlaying && !isPaused
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        size: 36,
                        color: Colors.pinkAccent,
                      ),
                      onPressed: () {
                        if (isPlaying) {
                          _pauseOrResume();
                        } else {
                          _playSong(url, id);
                        }
                      },
                    ),
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
