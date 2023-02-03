import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:mb2/song.dart';

import 'global.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, routes: {
    '/': (context) => const MyApp(),
    'song': (context) => const Song()
  }));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final assetAudioPlayer = AssetsAudioPlayer();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Rainbow Music",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemBuilder: (context, i) {
          return Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(
                  "${Global.music[i]['image']}",
                ),
              ),
              title: Text(
                "${Global.music[i]['title']}",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                "${Global.music[i]['subtitle']}",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.white,
              ),
              tileColor: Global.music[i]['color'],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onTap: () {
                Navigator.of(context)
                    .pushNamed('song', arguments: Global.music[i]);
              },
            ),
          );
        },
        itemCount: Global.music.length,
      ),
      backgroundColor: Colors.black,
    ));
  }
}
