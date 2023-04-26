import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class Song extends StatefulWidget {
  const Song({Key? key}) : super(key: key);

  @override
  State<Song> createState() => _SongState();
}

class _SongState extends State<Song> with TickerProviderStateMixin {
  final assetAudioPlayer = AssetsAudioPlayer();

  bool play = true;

  AnimationController? myController;

  @override
  void initState() {
    super.initState();
    myController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    super.dispose();
    assetAudioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    assetAudioPlayer.open(Audio(data['audio']));
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Now Playing",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              centerTitle: true,
              backgroundColor: Colors.black,
            ),
            body: Stack(children: [
              SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Image.asset(
                  data['image'],
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 250,
                        width: 250,
                        child: Image.asset(
                          data['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        data['title'],
                        style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        data['subtitle'],
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white60,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  assetAudioPlayer.stop();
                                });
                              },
                              icon: const Icon(
                                Icons.stop,
                                color: Colors.white,
                                size: 35,
                              )),
                          const SizedBox(
                            width: 30,
                          ),
                          StreamBuilder(
                            builder: (context, snapshot) {
                              if (snapshot.data!) {
                                myController!.forward();
                              }
                              return IconButton(
                                  onPressed: () {
                                    if (snapshot.data!) {
                                      assetAudioPlayer.pause();
                                      myController!.reverse();
                                    } else {
                                      assetAudioPlayer.play();
                                      myController!.forward();
                                    }
                                  },
                                  icon: AnimatedIcon(
                                    icon: AnimatedIcons.play_pause,
                                    color: Colors.white,
                                    size: 35,
                                    progress: myController!,
                                  ));
                            },
                            stream: assetAudioPlayer.isPlaying,
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.headphones,
                                color: Colors.white,
                                size: 35,
                              )),
                        ],
                      ),
                      StreamBuilder(
                          stream: assetAudioPlayer.currentPosition,
                          builder: (context, snapshot) {
                            return Column(
                              children: [
                                Slider(
                                  value: snapshot.data!.inSeconds.toDouble(),
                                  onChanged: (val) {
                                    setState(() {
                                      assetAudioPlayer
                                          .seek(Duration(seconds: val.toInt()));
                                    });
                                  },
                                  max: (assetAudioPlayer.current.value != null)
                                      ? assetAudioPlayer.current.value?.audio
                                              .duration.inSeconds
                                              .toDouble() ??
                                          0
                                      : 0,
                                  min: 0,
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.white60,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      snapshot.data.toString().split('.')[0],
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    const Text("/",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white)),
                                    (assetAudioPlayer.current.value != null)
                                        ? Text(
                                            "${assetAudioPlayer.current.value?.audio.duration.toString().split('.')[0]}",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.white))
                                        : const Text("0:00:00",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white))
                                  ],
                                )
                              ],
                            );
                          })
                    ],
                  ))
            ])));
  }
}
