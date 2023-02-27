import 'package:flutter/material.dart';
import 'listeners.dart';

class Lyrics extends StatefulWidget {
  const Lyrics({super.key});

  @override
  State<Lyrics> createState() => _LyricsState();
}

class _LyricsState extends State<Lyrics> {
  List<String> lyrics = LyricData.lyrics.value;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: LyricData.index,
      builder: (context, lyricIndex, child){
        return Container(
          color: const Color.fromARGB(255, 8, 57, 80),
          child: ShaderMask(
            shaderCallback: (rect){
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color.fromARGB(255, 8, 57, 80),
                ],
                stops: [
                  0.25, 0.95
                ]
              ).createShader(rect);
            },
            blendMode: BlendMode.dstOut,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              decoration: const BoxDecoration(
              ),
              child: ListView.builder(
                controller: PrimaryScrollController.of(context),
                itemCount: lyrics.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    // Adjust padding and SizedBox height when lyrics change
                    child: Text(
                      lyrics[index],
                      maxLines: 10,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: lyricIndex == index ? Colors.white :Colors.white38, //Current notInFocus colour
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  );
                }
              ),
            ),
          ),
        
        );
      }
    );
  }
}

